//
//  GEDispatcher.m
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import "GEDispatcher.h"
#import "GEEnvironmentParameter.h"
#import "GEStorage.h"
//#import "NSData+AES.h"
#import <CommonCrypto/CommonCryptor.h>
//#import "GTMBase64.h"
#import "Godeye.h"

extern NSString *GEApplicationSuspendEventName;
extern NSString *GEApplicationDestroyEventName;
extern NSString *GEApplicationInstallEventName;
extern NSString *GEApplicationLaunchEventName;
//针对积分墙用户主动上报idfa的事件上报 appIdfaAuthorize
extern NSString *GEApplicationAppIdfaAuthorizeEventName;

@interface GEDispatcher () <NSURLSessionDelegate>
@property (nonatomic, strong) NSMutableArray <GETrackerModel *> *eventArray;
@end

@implementation GEDispatcher {
    NSOperationQueue *_operationQueue;
    NSURLSession *_session;
}

#if DEBUG
NSInteger CACHE_COUNT = 1;
#else
NSInteger CACHE_COUNT = 20;
#endif

static NSString * REPORT_URL = @"https://usertracking.to8to.com/sendAppData";
static NSString * const GE_DATA_AES_KEY = @"zt4PFDAw*$2z3qd0";
static NSString * const GE_DATA_AES_KEY_VERSION = @"v1";
+ (instancetype)defaultDispatcher
{
    static GEDispatcher *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GEDispatcher alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.name = @"com.to8to.godeye.networkQueue";
        _operationQueue.maxConcurrentOperationCount = 1;
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:_operationQueue];
        _eventArray = [NSMutableArray array];
    }
    return self;
}

- (void)reportTracker:(GETrackerModel *)tracker
{
    NSParameterAssert(tracker);
    if (!tracker) {
        return;
    }

    [_operationQueue addOperationWithBlock:^{
        GELog(@"Godeye Info: Dispatcher did recieve tracker: \n%@", tracker.dictionaryValue);
        [self.eventArray addObject:tracker];
        
        BOOL imOuter = ([self.immediatelyReportList containsObject:tracker.event]);
        BOOL immediately = imOuter || ([tracker.event isEqualToString:GEApplicationDestroyEventName] ||
                                       [tracker.event isEqualToString:GEApplicationSuspendEventName] ||
                                       [tracker.event isEqualToString:GEApplicationInstallEventName] ||
                                       [tracker.event isEqualToString:GEApplicationLaunchEventName] ||
                                       [tracker.event isEqualToString:GEApplicationAppIdfaAuthorizeEventName]);
        if (self.eventArray.count >= CACHE_COUNT || immediately) {
            [self uploadData];
        }
    }];
}

#pragma mark AES加密
- (NSString *)AES256EncryptWithData:(NSData *)data andKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (buffer == NULL) {
        return nil;
    }
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
//        return [GTMBase64 stringByEncodingData:[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted]];
        return nil;
    }
    free(buffer);
    buffer = NULL;
    return nil;
}

#pragma mark 解密
- (NSString *)AES256DecryptWith:(NSData *)data andKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted] encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

- (void)setRoomId:(NSString *)roomId {
    _roomId = roomId;
    //保存天眼码，下次启动app时自动注册
    [[NSUserDefaults standardUserDefaults] setValue:roomId?:@"" forKey:kBigDataRoomIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)uploadData
{
    NSArray <GETrackerModel *> *cachedData = [GEStorage getData];
    NSArray <GETrackerModel *> *trackers = [self.eventArray copy];
    [self.eventArray removeAllObjects];
    
    NSMutableArray *temp = [NSMutableArray array];
    [trackers enumerateObjectsUsingBlock:^(GETrackerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp addObject:[obj dictionaryValue]];
    }];
    [cachedData enumerateObjectsUsingBlock:^(GETrackerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp addObject:[obj dictionaryValue]];
    }];
    NSDictionary *header = [[GEEnvironmentParameter defaultParameter] parameter];
    NSDictionary *package = @{@"header":header,
                              @"group":temp,};
    NSData *data = nil;
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithCapacity:3];
    @try {
        NSData *packageData = [NSJSONSerialization dataWithJSONObject:package options:0 error:nil];
        NSString *packageAES= [self AES256EncryptWithData:packageData andKey:GE_DATA_AES_KEY];//[packageData AES256EncryptWithKey:GE_DATA_AES_KEY];
        if (packageAES) {
            //加密成功，上报加密串
            [body setObject:packageAES forKey:@"data"];
            [body setObject:@(1) forKey:@"encryption"];
            [body setObject:GE_DATA_AES_KEY_VERSION forKey:@"version"];
#ifdef DEBUG
            [body setObject:package forKey:@"noAesData"];
#endif
            data = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
        }else{
            //加密失败，直接上报原始串
            data = packageData;
        }
    } @catch (NSException *exception) {
        GELog(@"Godeye Error: Json serialization failed: \n%@", package);
        return;
    } @finally {}

#if DEBUG
    
    NSDictionary *groupDict = temp.firstObject;
    
    NSString *pageUid = groupDict[@"properties"][@"page_uid"];
    NSString *event   = groupDict[@"event"];
    
    NSString *urlStr;
    
    if (pageUid && pageUid.length > 0) {
        urlStr = [NSString stringWithFormat:@"%@?pageUid=%@&event=%@", REPORT_URL, pageUid, event];
    } else {
        urlStr = [NSString stringWithFormat:@"%@?event=%@", REPORT_URL, event];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
#else
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:REPORT_URL]];
#endif
    
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *userAgent = [[GEEnvironmentParameter defaultParameter] userAgent];
    [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];

    BOOL hasDelegate = self.delegate && [self.delegate respondsToSelector:@selector(dispatcherReportTrackers:success:)];
    if (hasDelegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate dispatcherReportTrackers:trackers success:YES];
        });
    }
    
#if DEBUG
    [self uploadToRocketCI:groupDict isFirst:NO];
#endif
    
    NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode/100 == 2) {
            [GEStorage removeData:cachedData];
        } else {
            GELog(@"Godeye Info: Report %zd trackers failed! error info: \n%@", temp.count, error);
            [GEStorage putData:trackers];
        }
    }];
    [task resume];
}

- (void)connectToRocketCI {
    [self uploadToRocketCI:nil isFirst:YES];
}

- (void)uploadToRocketCI:(NSDictionary *)dict isFirst:(BOOL)isFirst {
    if (self.roomId == 0) {
        return;
    }
    
    NSString *debugId = [GEEnvironmentParameter defaultParameter].debugInfo;
    NSString *firstId = [GEEnvironmentParameter defaultParameter].first_id;
    NSString *userName = [[UIDevice currentDevice] name];
    
    NSDictionary *dataDict = @{@"event" : dict ?: @{},
                               @"room" : self.roomId ?: @"",
                               @"debugId" : debugId ?: @"",
                               @"firstId" : firstId ?: @"",
                               @"username" : userName ?: @"",
                               @"isFirst" : @(isFirst)};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:0 error:nil];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.50.11.24:80/sendEvent"]];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:request
                                                          fromData:data
                                                 completionHandler:^(NSData * _Nullable data,
                                                                     NSURLResponse * _Nullable response,
                                                                     NSError * _Nullable error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode == 200) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            GELog(@"sendEventSucccess:-------------------------------------->:%@", dict);
        } else {
            GELog(@"sendEventFailure:-------------------------------------->:%@", error.description);
        }
    }];
    [task resume];
}

- (NSArray *)immediatelyReportList {
    if (!_immediatelyReportList) {
        _immediatelyReportList = @[];
    }
    return _immediatelyReportList;
}

@end
