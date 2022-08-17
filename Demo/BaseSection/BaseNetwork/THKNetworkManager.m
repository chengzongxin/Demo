//
//  THKNetworkManager.m
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/11/5.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKNetworkManager.h"
#import "THKBaseNetworkManager.h"
#import "THKBaseNetwork.h"
#import <WebKit/WebKit.h>
//#import "TXLogHelper.h"
//#import "TRNetModel.h"
//#import "TRPerformanceMonitor.h"
//#import "NSError+Type.h"
//#import "TComLocationTool.h"
//#import "GEEnvironmentParameter.h"
//#import "THKConfiguration.h"
//#import "THKAppGroupHandler.h"
#import "THKHttpDNSManager.h"
#import "TRequestParameter.h"

@interface THKNetworkManager ()
@property (nonatomic,strong)WKWebView *userAgentWebView;
@property (nonatomic, assign) BOOL isSetUserAgent;
@end

@implementation THKNetworkManager

+ (THKNetworkManager *)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {}
    return self;
}

- (void)setupNetwork {
    [self initRequestParameter];
    [self initSecurityPolicy];
    [self initPerformanceMonitor];
    [self startObsertConnectStatus];
    [self setDefaultUserAgent];
}

#pragma mark - Radar

// HTTP String Method
- (NSString *)getHttpMethodOfRequest:(THKBaseRequest *)request {
    THKHttpMethod method = [request httpMethod];
    
    if (method == THKHttpMethodPOST) {
        return @"POST";
    }
    
    return @"GET";
}

// URL中拼接Model和Action
//- (NSString *)fullUrlOfRequest:(THKBaseRequest *)request {
//
//    NSString *url = request.requestPath;
//
//    if (![url hasPrefix:@"http"]) {
//        url = [NSString stringWithFormat:@"%@%@", request.baseUrl, url];
//    }
//
//    NSMutableString *mStr = url.mutableCopy;
//
//    if ([mStr rangeOfString:@"?"].location != NSNotFound) {
//        mStr = [[[mStr componentsSeparatedByString:@"?"] firstObject] mutableCopy];
//        NSURL *URL = [NSURL URLWithString:url];
//        // 防止误删model、action
//        if ([URL parameterValueForKey:@"model"]) {
//            [mStr appendFormat:@"?model=%@",[URL parameterValueForKey:@"model"]];
//        }
//
//        if ([URL parameterValueForKey:@"action"]) {
//            [mStr appendFormat:@"&action=%@",[URL parameterValueForKey:@"action"]];
//        }
//    }
//
//    NSDictionary *params  = request.parameters;
//
//    if (!params || ![params isKindOfClass:[NSDictionary class]]) {
//        return mStr;
//    }
//
//    if (params[@"model"]) {
//        [mStr appendFormat:@"?model=%@",params[@"model"]];
//    }
//
//    if (params[@"action"]) {
//        [mStr appendFormat:@"&action=%@",params[@"action"]];
//    }
//    if ([TBTNetworkManager sharedManager].formatUrlBlock) {
//        return [TBTNetworkManager sharedManager].formatUrlBlock(mStr);
//    }
//    return mStr;
//}

-(void)initSecurityPolicy{
    // 设置网络请求策略
    TBTNetworkConfig *networkConfig  = [TBTNetworkConfig sharedConfig];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    //是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    networkConfig.debugLogEnabled = YES;
    networkConfig.securityPolicy  = securityPolicy;
    networkConfig.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"application/json", @"text/javascript"]];
}


/// 初始化网络请求公共参数
-(void)initRequestParameter{
    //接口域名替换
    [TBTNetworkManager sharedManager].formatUrlBlock = ^NSString *(NSString * _Nonnull url) {
        return [[THKHttpDNSManager shareInstane] convertHostForUrlString:url isWebUrl:NO];
    };
    // 初始化网络模块
    NSString *cityName = @"深圳";
    NSInteger cityId   = 1130;
    [TRequestParameter sharedParameter].cityid    = cityId;
    [TRequestParameter sharedParameter].cityName  = cityName;
    [TRequestParameter sharedParameter].accountId = 11277218;//
    [TRequestParameter sharedParameter].first_id = @"4298F251-E93C-478E-AA05-B46E47F02BEC";
    [TRequestParameter sharedParameter].isnew = 0;
    // 用户id
    [THKBaseNetworkManager sharedManager].userIdBlock = ^NSString * _Nullable{
        return [NSString stringWithFormat:@"%d", 172176109];
    };
    
    // token
    [THKBaseNetworkManager sharedManager].tokenBlock = ^NSString * _Nullable{
        return @"vBM5Pe1cQUgQyLkMSR8Dm8Qg9OOpHLLSLJbg-qoVY7xZP7moUuqPk0d3eTeAEuEf2ExBtV7tOc1-eP9r5mEJQlwQivw3yrR3WkSSR3QXtVvxRGJw9eNOk5pPc6CDHaFA";
    };
    
    // userAgent
    [THKBaseNetworkManager sharedManager].userAgentBlock = ^NSString * _Nullable{
        return [[TRequestParameter sharedParameter] userAgent];
    };
    
    // 公参
    [THKBaseNetworkManager sharedManager].parametersBlock = ^NSDictionary * _Nullable{
        return [[TRequestParameter sharedParameter] getSharedParameter];
    };
    
    // 城市ID
    [[TRequestParameter sharedParameter] setCityIdBlock:^id{
        return @(cityId);
    }];
    
    // 城市名称
    [[TRequestParameter sharedParameter] setCityNameBlock:^id{
        return cityName;
    }];
    
    // 同步first_id到AppGroup
//    [[THKAppGroupHandler shareInstane] syncFirstId:[GEEnvironmentParameter defaultParameter].first_id];
    
    ///  开发
    [TRequestParameter sharedParameter].accountId = 11277046;//
    [TRequestParameter sharedParameter].first_id = @"2CC5559F-EDC1-4F2A-8192-36BAAECF573C";
    [TRequestParameter sharedParameter].isnew = 0;
    // 用户id
    [THKBaseNetworkManager sharedManager].userIdBlock = ^NSString * _Nullable{
        return [NSString stringWithFormat:@"%d", 172175695];
    };
    
    // token
    [THKBaseNetworkManager sharedManager].tokenBlock = ^NSString * _Nullable{
        return @"vBM5Pe1cQUgQyLkMSR8Dm0sXQoiAESCZqMLkoALijXnKgrH7GA6kFz5z5t6dROFx2iV-gTkxzCQaXuh-_wGYD1wQivw3yrR3WkSSR3QXtVvxRGJw9eNOk5pPc6CDHaFA";
    };
    
    
}


///开启网络连接状态的监听，无网时会toast提示
- (void)startObsertConnectStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    static AFNetworkReachabilityStatus netState = AFNetworkReachabilityStatusUnknown;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                if(status != netState) {
                    [TMToast toast:@"no net"];
                }
                break;
            default:
                break;
        }
        netState = status;
    }];
    [manager startMonitoring];
}


/// 初始化网络性能监控配置
-(void)initPerformanceMonitor{
//    // 网络性能监控
//    [[THKBaseNetworkManager sharedManager] requestStart:^(THKBaseRequest * _Nonnull request) {
//        NSString *fullUrl = [self fullUrlOfRequest:request];
//
//        // 雷达数据Model
//        TXHttpLogModel *logModel = [TXHttpLogModel modelWithMethod:[self getHttpMethodOfRequest:request]
//                                                               url:fullUrl
//                                                             param:request.requestArgument ?: @{}];
//        request.logModel = logModel;
//
//        TRNetModel *netModel  = [[TRNetModel alloc] init];
//        netModel.url          = fullUrl;
//        netModel.content_type = @"api";
//        request.netModel = netModel;
//
//        request.startTime = TBT_CURRENT_TIMESTAMP;
//    } success:^(THKBaseRequest * _Nonnull request) {
//
//        THKDebugLog(@"%@", [NSString stringWithFormat:@"【%@请求成功】model:%@ action:%@ \nresponseObject:%@ \nparameter:%@ \nurl:%@",
//                        [self getHttpMethodOfRequest:request], kUnNilStr(request.parameters[@"model"]), kUnNilStr(request.parameters[@"action"]),
//                        request.responseDict, request.requestArgument, request.requestTask.currentRequest.URL.absoluteString]);
//
//        // Radar
//        TXHttpLogModel *logModel = (TXHttpLogModel *)request.logModel;
//        [logModel setResponse:request.responseDict error:nil];
//
//        // 网络性能监控
//        TRNetModel *netModel = (TRNetModel *)request.netModel;
//        netModel.cost_time      = (long)(TBT_CURRENT_TIMESTAMP - request.startTime);
//        netModel.status         = request.responseStatusCode;
//        netModel.received_bytes = (NSInteger)request.requestTask.countOfBytesReceived;
//
//        [[TRPerformanceMonitor monitor] addReq:netModel];
//    } failure:^(THKBaseRequest * _Nonnull request) {
//
//        THKDebugLog(@"%@", [NSString stringWithFormat:@"【%@请求成功】model:%@, action:%@ \nresponseObject:%@ \nparameter:%@ \nurl:%@",
//                        [self getHttpMethodOfRequest:request], kUnNilStr(request.parameters[@"model"]), kUnNilStr(request.parameters[@"action"]),
//                        request.responseDict, request.requestArgument, request.requestTask.currentRequest.URL.absoluteString]);
//
//        // Radar
//        TXHttpLogModel *logModel = (TXHttpLogModel *)request.logModel;
//        [logModel setResponse:nil error:request.error];
//
//        // 网络性能监控
//        TRNetModel *netModel = (TRNetModel *)request.netModel;
//        netModel.cost_time  = (long)(TBT_CURRENT_TIMESTAMP - request.startTime);
//        netModel.status     = request.response.statusCode;
//        netModel.error_msg  = request.error.localizedDescription?:@"TNetworkErrorMsg";
//        netModel.error_type = [NSError typeWithCode:request.error.code];
//
//        [[TRPerformanceMonitor monitor] addReq:netModel];
//    }];
}
-(void)setWebUserAgent:(NSString*)webAgent{
    if (webAgent.length == 0) {
        return;
    }
    NSString *newAgent = [[TRequestParameter sharedParameter] userAgent];
    webAgent = [NSString stringWithFormat:@"%@ %@", newAgent, webAgent] ? : @"";
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:webAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    self.isSetUserAgent = YES;
}

// 设置UserAgent
- (void)setDefaultUserAgent
{
    BOOL needLoad = NO;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    SEL privateUASel = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@%@%@",@"_",@"user",@"Agent"]);
    if ([webView respondsToSelector:privateUASel]) {//同步获取webview UserAgent
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        NSString *originalUserAgent = [webView performSelector:privateUASel];
#pragma clang diagnostic pop
        if (originalUserAgent.length > 0) {
            [self setWebUserAgent:originalUserAgent];
        }else{
            needLoad = YES;
        } 
    }else{
        needLoad = YES;
    }
    
    if (needLoad) {
        self.userAgentWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        [self.userAgentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
        @weakify(self);
        [self.userAgentWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString *userAgent, NSError * _Nullable error) {
            NSLog(@"WKWebView:%@",userAgent);
            @strongify(self);
            if (!error && userAgent && [userAgent isKindOfClass:[NSString class]]) {
                [self setWebUserAgent:userAgent];
            }
            self.userAgentWebView = nil;
        }];
    }
    

    NSString *newAgent = [[TRequestParameter sharedParameter] userAgent];
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:[YYWebImageManager sharedManager].headers ?: @{}];
    NSString *imageUserAgent = headers[@"User-Agent"];
    if (imageUserAgent) {
        headers[@"User-Agent"] = [NSString stringWithFormat:@"%@ %@", newAgent ?: @"", imageUserAgent];
    } else {
        headers[@"User-Agent"] = newAgent ?: @"";
    }
    headers[@"referer"] = @"https://to8to.com";
    [YYWebImageManager sharedManager].headers = headers;
}

-(BOOL)isSettedUserAgent{
    return self.isSetUserAgent;
}
@end
