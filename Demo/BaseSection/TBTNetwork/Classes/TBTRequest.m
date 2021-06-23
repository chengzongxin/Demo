//
//  TBTRequest.m
//  TBTNetwork
//
//  Created by 荀青锋 on 2019/6/26.
//

#import "TBTRequest.h"
#import "TBTNetworkConfig.h"
#import "TBTNetworkPrivate.h"
#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_QoS_Available 1140.11
#else
#define NSFoundationVersionNumber_With_QoS_Available NSFoundationVersionNumber_iOS_8_0
#endif

NSString *const TBTRequestCacheErrorDomain = @"com.tubatu.request.caching";

static dispatch_queue_t tbt_request_cache_writing_queue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr = DISPATCH_QUEUE_SERIAL;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_With_QoS_Available) {
            attr = dispatch_queue_attr_make_with_qos_class(attr, QOS_CLASS_BACKGROUND, 0);
        }
        queue = dispatch_queue_create("com.tubatu.request.caching", attr);
    });
    
    return queue;
}

@interface TBTCacheMetadata : NSObject<NSSecureCoding>

@property (nonatomic, assign) long long version;
@property (nonatomic, assign) NSStringEncoding stringEncoding;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *appVersionString;

@end

@implementation TBTCacheMetadata

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.version) forKey:NSStringFromSelector(@selector(version))];
    [aCoder encodeObject:@(self.stringEncoding) forKey:NSStringFromSelector(@selector(stringEncoding))];
    [aCoder encodeObject:self.creationDate forKey:NSStringFromSelector(@selector(creationDate))];
    [aCoder encodeObject:self.appVersionString forKey:NSStringFromSelector(@selector(appVersionString))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.version = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(version))] integerValue];
    self.stringEncoding = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(stringEncoding))] integerValue];
    self.creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(creationDate))];
    self.appVersionString = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVersionString))];
    
    return self;
}

@end

@interface TBTRequest ()

@property (nonatomic, strong) NSData *cacheData;
@property (nonatomic, strong) NSString *cacheString;
@property (nonatomic, strong) id cacheJSON;
@property (nonatomic, strong) NSXMLParser *cacheXML;

@property (nonatomic, strong) TBTCacheMetadata *cacheMetadata;
@property (nonatomic, assign) BOOL dataFromCache;

@end

@implementation TBTRequest

- (void)start {
    
    // 本地不缓存数据
    if (!self.isCasheData) {
        [self startWithoutCache];
        return;
    }
    
    // 本地缓存数据, 但是加载失败
    if (![self loadCacheWithError:nil]) {
        [self startWithoutCache];
        return;
    }
    
    _dataFromCache = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        TBTRequest *strongSelf = self;
        
        if (strongSelf.delegate != nil && [strongSelf.delegate respondsToSelector:@selector(requestFinished:)]) {
            [strongSelf.delegate requestFinished:strongSelf];
        }
        
        if (strongSelf.successCompletionBlock) {
            strongSelf.successCompletionBlock(strongSelf);
        }
        
        [strongSelf clearCompletionBlock];
    });
}

- (void)startWithoutCache {
    [self clearCacheVariables];
    [super start];
}

#pragma mark - Subclass Override

- (void)requestCompletePreprocessor {
    [super requestCompletePreprocessor];
    
    if (!self.isCasheData) {return;}
    
    if (self.writeCacheAsynchronously) {
        dispatch_async(tbt_request_cache_writing_queue(), ^{
            [self saveResponseDataToCacheFile:[super responseData]];
        });
    } else {
        [self saveResponseDataToCacheFile:[super responseData]];
    }
}

- (NSInteger)cacheTimeInSeconds {
    return -1;
}

- (long long)cacheVersion {
    return 0;
}

- (BOOL)writeCacheAsynchronously {
    return YES;
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}

#pragma mark - Response Information

- (BOOL)isDataFromCache {
    return _dataFromCache;
}

- (NSData *)responseData {
    if (_cacheData) {
        return _cacheData;
    }
    return [super responseData];
}

- (NSString *)responseString {
    if (_cacheString) {
        return _cacheString;
    }
    return [super responseString];
}

- (id)responseJSONObject {
    if (_cacheJSON) {
        return _cacheJSON;
    }
    return [super responseJSONObject];
}

- (id)responseObject {
    if (_cacheJSON) {
        return _cacheJSON;
    }
    if (_cacheXML) {
        return _cacheXML;
    }
    if (_cacheData) {
        return _cacheData;
    }
    return [super responseObject];
}

#pragma mark - private

- (BOOL)loadCacheWithError:(NSError * _Nullable __autoreleasing *)error {
    // 校验缓存时间是否有效
    if ([self cacheTimeInSeconds] < 0) {
        if (error) {
            *error = [NSError errorWithDomain:TBTRequestCacheErrorDomain
                                         code:TBTRequestCacheErrorInvalidCacheTime
                                     userInfo:@{NSLocalizedDescriptionKey:@"Invalid cache time"}];
        }
        return NO;
    }
    
    // 加载缓存元数据
    if (![self loadCacheMetadata]) {
        if (error) {
            *error = [NSError errorWithDomain:TBTRequestCacheErrorDomain
                                         code:TBTRequestCacheErrorInvalidMetadata
                                     userInfo:@{NSLocalizedDescriptionKey:@"Invalid metadata. Cache may not exist"}];
        }
        return NO;
    }
    
    // 校验缓存数据的有效性
    if (![self validateCacheWithError:error]) {
        return NO;
    }
    
    // 加载缓存数据
    if (![self loadCacheData]) {
        if (error) {
            *error = [NSError errorWithDomain:TBTRequestCacheErrorDomain
                                         code:TBTRequestCacheErrorInvalidCacheData
                                     userInfo:@{NSLocalizedDescriptionKey:@"Invalid cache data"}];
        }
        return NO;
    }
    
    return YES;
}

// 校验缓存数据的有效性
- (BOOL)validateCacheWithError:(NSError * _Nullable __autoreleasing *)error {
    // 校验日期
    NSDate *creationDate = self.cacheMetadata.creationDate;
    NSTimeInterval duration = -[creationDate timeIntervalSinceNow];
    if (duration < 0 || duration > [self cacheTimeInSeconds]) {
        if (error) {
            *error = [NSError errorWithDomain:TBTRequestCacheErrorDomain
                                         code:TBTRequestCacheErrorExpired
                                     userInfo:@{NSLocalizedDescriptionKey:@"Cache expired"}];
        }
        return NO;
    }
    
    // 缓存版本号
    long long cacheVersionFileContent = self.cacheMetadata.version;
    if (cacheVersionFileContent != [self cacheVersion]) {
        if (error) {
            *error = [NSError errorWithDomain:TBTRequestCacheErrorDomain
                                         code:TBTRequestCacheErrorVersionMismatch
                                     userInfo:@{NSLocalizedDescriptionKey:@"Cache version mismatch"}];
        }
        return NO;
    }
    
    // App 版本号
    NSString *appVersionString = self.cacheMetadata.appVersionString;
    NSString *currentAppVersionString = [TBTNetworkUtils appVersionString];
    if (appVersionString || currentAppVersionString) {
        if (appVersionString.length != currentAppVersionString.length || ![appVersionString isEqualToString:currentAppVersionString]) {
            if (error) {
                *error = [NSError errorWithDomain:TBTRequestCacheErrorDomain
                                             code:TBTRequestCacheErrorAppVersionMismatch
                                         userInfo:@{NSLocalizedDescriptionKey:@"App version mismatch"}];
            }
            return NO;
        }
    }
    
    return YES;
}


// 加载缓存元数据
- (BOOL)loadCacheMetadata {
    NSString *path = [self cacheMetadataFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        @try {
            _cacheMetadata = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            return YES;
        } @catch (NSException *exception) {
            NSLog(@"Load cache metadata failed, reason = %@", exception.reason);
            return NO;
        }
    }
    return NO;
}

// 加载缓存数据
- (BOOL)loadCacheData {
    NSString *path = [self cacheFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        _cacheData = data;
        _cacheString = [[NSString alloc] initWithData:_cacheData encoding:self.cacheMetadata.stringEncoding];
        switch (self.responseSerializerType) {
            case TBTResponseSerializerTypeHTTP:
                // Do nothing.
                return YES;
            case TBTResponseSerializerTypeJSON:
                _cacheJSON = [NSJSONSerialization JSONObjectWithData:_cacheData options:(NSJSONReadingOptions)0 error:&error];
                return error == nil;
            case TBTResponseSerializerTypeXMLParser:
                _cacheXML = [[NSXMLParser alloc] initWithData:_cacheData];
                return YES;
        }
    }
    
    return NO;
}

- (void)asynchronouslySaveResponseDataToCacheFile:(NSData *)data {
    dispatch_async(tbt_request_cache_writing_queue(), ^{
        [self saveResponseDataToCacheFile:data];
    });
}

// 缓存数据到本地
- (void)saveResponseDataToCacheFile:(NSData *)data {
    if ([self cacheTimeInSeconds] > 0 && ![self isDataFromCache]) {
        if (data != nil) {
            @try {
                // New data will always overwrite old data.
                [data writeToFile:[self cacheFilePath] atomically:YES];
                
                TBTCacheMetadata *metadata = [[TBTCacheMetadata alloc] init];
                metadata.version = [self cacheVersion];
                metadata.stringEncoding = [TBTNetworkUtils stringEncodingWithRequest:self];
                metadata.creationDate = [NSDate date];
                metadata.appVersionString = [TBTNetworkUtils appVersionString];
                [NSKeyedArchiver archiveRootObject:metadata toFile:[self cacheMetadataFilePath]];
            } @catch (NSException *exception) {
                NSLog(@"Save cache failed, reason = %@", exception.reason);
            }
        }
    }
}

// 清理内存缓存
- (void)clearCacheVariables {
    _cacheData     = nil;
    _cacheXML      = nil;
    _cacheJSON     = nil;
    _cacheString   = nil;
    _cacheMetadata = nil;
    _dataFromCache = NO;
}

#pragma mark - FileManager

- (void)createDirectoryIfNeeded:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

- (void)createBaseDirectoryAtPath:(NSString *)path {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    } else {
        [TBTNetworkUtils addDoNotBackupAttribute:path];
    }
}

- (NSString *)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"LazyRequestCache"];
    
    [self createDirectoryIfNeeded:path];
    return path;
}

- (NSString *)cacheFileName {
    if ([self respondsToSelector:@selector(customCacheFileName)]) {
        NSString *fileName = [self performSelector:@selector(customCacheFileName)];
        if (fileName && [fileName isKindOfClass:[NSString class]] && fileName.length > 0) {
            NSString *cacheFileName = [TBTNetworkUtils md5StringFromString:fileName];
            return cacheFileName;
        }
    }
    
    NSString *requestUrl = [self requestPath];
    NSString *baseUrl = [TBTNetworkConfig sharedConfig].baseUrl;
    id argument = [self cacheFileNameFilterForRequestArgument:[self requestArgument]];
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Argument:%@",
                             (long)[self requestMethod], baseUrl, requestUrl, argument];
    NSString *cacheFileName = [TBTNetworkUtils md5StringFromString:requestInfo];
    return cacheFileName;
}

- (NSString *)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

- (NSString *)cacheMetadataFilePath {
    NSString *cacheMetadataFileName = [NSString stringWithFormat:@"%@.metadata", [self cacheFileName]];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheMetadataFileName];
    return path;
}

@end
