//
//  THKBaseRequest.m
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/4/30.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKBaseRequest.h"
#import "THKBaseNetworkManager.h"
#import <MJExtension/MJExtension.h>

#ifndef TLOG_ENABLE
#if __has_include(<TBasicLib/TLog.h>)
#define TLOG_ENABLE 1
#import <TBasicLib/TLog.h>
#else
#define TLOG_ENABLE 0
#endif
#endif

static NSString *const kJavaParameter_args     = @"args";
static NSString *const kJavaParameter_pri_args = @"pri_args";
static NSString *const kJavaParameter_pub_args = @"pub_args";
static NSString *const kJavaParameter_pubArgs  = @"pubArgs";

static NSString *const THKResponseErrorDomain = @"com.tubatu.response.error";

#define THKErrorCodeOfNoData -1
#define THKNotificationOfTokenError @"kNotiNameOfTokenError"

typedef NS_ENUM(NSUInteger, TBTResponseError) {
    TBTResponseErrorInvalidClass = -1,
};

@interface THKBaseRequest ()

@end

@implementation THKBaseRequest

- (void)dealloc {
    NSLog(@"class=%@ dealloc",[self class]);
}

#pragma mark - THKBaseRequestProtocol

- (Class)modelClass {
    return [THKResponse class];
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (NSString *)requestDomain {
    return kMobileApiDomain;
}

- (NSString *)requestUrl {
    return @"";
}

- (NSDictionary *)parameters {
    return nil;
}

- (BOOL)isAddCommonParameter {
    return YES;
}

- (BOOL)needLoginAuthentication {
    return YES;
}

- (THKParameterType)parameterType {
    return THKParameterTypeDefault;
}

- (THKRequestType)requestType {
    return THKRequestTypeJSON;
}

- (nullable NSDictionary<NSString*, NSString*> *)requestHeaderFieldValueDictionary {
    NSString *userAgent = [THKBaseNetworkManager sharedManager].userAgent;
    if (userAgent && [userAgent isKindOfClass:[NSString class]] && userAgent.length > 0) {
        return @{@"User-Agent" : userAgent};
    }
    return nil;
}

- (nonnull NSString *)customRequestCacheFileName {
    return @"";
}

#pragma mark - Subclass Override

// 域名
- (NSString *)baseUrl {
    return [self requestDomain];
}

// URL PATH
- (NSString *)requestPath {
    NSString *requestDomain = [self requestDomain];// 请求域名
    NSString *requestPath   = [self requestUrl];// 请求PATH
    
    // 新网关接口 需要在URL中拼接鉴权参数, URL中仅拼接供网关使用的参数, 其他业务参数放在parameters中.
    // 注: GET请求会将parameters中的参数拼接到URL中, POST请求parameters中的参数将通过body传递过去.
    if (self.parameterType == THKParameterTypeArgsWithUrl) {
        requestPath = [self argsWithUrlRequestPath:requestPath];
    }
    
    if ([requestPath hasPrefix:@"http"]) {// 自身包含有域名, 不再拼接域名
        return requestPath;
    }
    
    if ([requestDomain isEqualToString:kMobileApiDomain]) {// PHP接口
        if (requestPath.length > 0) {
            if ([requestPath hasPrefix:@"/"]) {
                requestPath = [NSString stringWithFormat:@"%@%@", kMobileApiPath, requestPath];
            } else {
                requestPath = [NSString stringWithFormat:@"%@/%@", kMobileApiPath, requestPath];
            }
        }else {
            requestPath = kMobileApiPath;
        }
    } else if ([requestDomain isEqualToString:kSheJiBenDomain]) {// 设计本接口
        if (requestPath.length > 0) {
            if ([requestPath hasPrefix:@"/"]) {
                requestPath = [NSString stringWithFormat:@"%@%@", kSheJiBenPath, requestPath];
            } else {
                requestPath = [NSString stringWithFormat:@"%@/%@", kSheJiBenPath, requestPath];
            }
        }else {
            requestPath = kSheJiBenPath;
        }
    } else if ([requestDomain isEqualToString:kJavaServerDomain]) {// Java接口
        if (requestPath.length > 0) {
            if ([requestPath hasPrefix:@"/"]) {
                requestPath = [NSString stringWithFormat:@"%@%@", kJavaServerPath, requestPath];
            } else {
                requestPath = [NSString stringWithFormat:@"%@/%@", kJavaServerPath, requestPath];
            }
        }else {
            requestPath = kJavaServerPath;
        }
    }
    
    return requestPath;
}

// 网络请求超时时长
- (NSTimeInterval)requestTimeoutInterval {
    return 30;
}

// 请求入参
- (nullable id)requestArgument {
    
    if (self.parameterType == THKParameterTypeDefault) {
        return [self argumentForDefault];
    }
    
    if (self.parameterType == THKParameterTypeArgs) {
        return [self argumentForArgs];
    }
    
    if (self.parameterType == THKParameterTypeArgsWithSubargs) {
        return [self argumentForArgsWithSubargs];
    }
    
    if (self.parameterType == THKParameterTypeArgsWithUrl) {
        return [self argumentForArgsWithUrl];
    }
    
    return [self argumentForDefault];
}

// HTTP Method
- (TBTRequestMethod)requestMethod {
    
    if (self.httpMethod == THKHttpMethodGET) {
        return TBTRequestMethodGET;
    } else if (self.httpMethod == THKHttpMethodPOST) {
        return TBTRequestMethodPOST;
    }
    
    return TBTRequestMethodGET;
}

// 请求入参类型
- (TBTRequestSerializerType)requestSerializerType {
    
    if (self.requestType == THKRequestTypeHTTP) {
        return TBTRequestSerializerTypeHTTP;
    } else if (self.requestType == THKRequestTypeJSON) {
        return TBTRequestSerializerTypeJSON;
    } else if (self.requestType == THKRequestTypeLIST) {
        return TBTRequestSerializerTypeLIST;
    }
    
    return TBTRequestSerializerTypeJSON;
}

// 返回参数类型
- (TBTResponseSerializerType)responseSerializerType {
    return TBTResponseSerializerTypeHTTP;
}

// 缓存文件名称
- (nonnull NSString *)customCacheFileName {
    return [self customRequestCacheFileName];
}

#pragma mark - Request

- (void)sendSuccess:(THKRequestSuccess)success failure:(THKRequestFailure)failure {
    [self sendHttpRequestSuccess:success failure:^(NSError * _Nonnull error) {
        // 主动取消网络请求, 不需要回调回去
        if (error.code == -999) {return;}
        
        if (failure) {failure(error);}
    }];
}

- (void)saveResponseDataToLocalFile {
    [self saveResponseDataToCacheFile:self.responseData];
}

- (void)saveResponseDataToLocalFileAsynchronously {
    [self asynchronouslySaveResponseDataToCacheFile:self.responseData];
}

- (void)loadCacheSuccess:(THKRequestSuccess)success failure:(THKRequestFailure)failure {
    NSError *error;
    
    // 读取缓存失败
    if (![self loadCacheWithError:&error]) {
        if (failure) {failure(error);}
        return;
    }
    
    [self handleResponseData:self.responseData success:success failure:failure];
}

- (void)cancel {
    [self stop];
}

#pragma mark - private

#pragma mark -

// Java接口, 新网关, 公参需要拼接到URL中去
- (NSString *)argsWithUrlRequestPath:(NSString *)path {
    
    NSString *requestPath;
    
    THKBaseNetworkManager *manager = [THKBaseNetworkManager sharedManager];
    NSString *appName = @"tbt-app";
    if (manager.parameters) {
        NSString *temp = [manager.parameters objectForKey:@"appName"];
        if (temp && temp.length > 0) {
            appName = temp;
        }
    }
    if (self.needLoginAuthentication && manager.userId.integerValue > 0) {// 用户已登录, 拼接用户ID和Token
        requestPath = [NSString stringWithFormat:@"%@?uid=%@&ticket=%@&source=%@&appName=%@&isChange=%@",
                       path, manager.userId, manager.token, @"tbt-app", appName, @"true"];
    } else {
        requestPath = [NSString stringWithFormat:@"%@?source=%@&appName=%@&isChange=%@",
                       path, @"tbt-app", appName, @"true"];
    }
    
    return requestPath;
}


#pragma mark -

// 默认入参结构 PHP接口使用到此种入参结构
// 默认类型, 直接传递参数, 不做任何拼装, 如: '@{参数}' -->PHP接口使用此种结构
- (NSDictionary *)argumentForDefault {
    
    if (self.isAddCommonParameter) {
        return [self addCommonParameter:self.parameters];
    }
    
    return self.parameters;
}

// args包裹的入参 部分Java接口使用到此种入参结构
// 参数使用args包裹一层, 如: '@{@"args":@{参数}}' -->部分Java接口使用此种结构
- (NSDictionary *)argumentForArgs {
    
    if (self.isAddCommonParameter) {
        return @{kJavaParameter_args:[self addCommonParameter:self.parameters] ?: @{}};
    }
    
    return @{kJavaParameter_args:self.parameters ?: @{}};
}

// args包裹并且带有子args包裹 Java接口老网关使用到此种结构
// 参数使用args包裹一层, 然后再用子args包裹一层, 例如: '@{@"args":@{@"pri_args":@{参数}, @"pub_args":@{公参}}}' -->Java接口 老网关使用此种结构
- (NSDictionary *)argumentForArgsWithSubargs {
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    NSDictionary *requestParameterDict = [THKBaseNetworkManager sharedManager].parameters;
    
    if (requestParameterDict && [requestParameterDict isKindOfClass:[NSDictionary class]]) {
        args[kJavaParameter_pub_args] = requestParameterDict;
    }
    
    if (self.parameters && [self.parameters isKindOfClass:[NSDictionary class]]) {
        args[kJavaParameter_pri_args] = self.parameters;
    }
    
    return @{kJavaParameter_args:args};
}

// 新网关接口 Java接口新网关使用到此种结构
// GET请求需要将parameters转成JSON字符串, POST请求可以可以直接使用parameters也可以使用JSON字符串, 在此统一使用JSON字符串
// 网关在URL中拼接, 业务参数包裹在args中, 例如:@{@"args":@"JSON字符串"} -->Java接口 新网关使用此种结构
- (NSDictionary *)argumentForArgsWithUrl {
    
    if (self.isAddCommonParameter) {
        NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:self.parameters ?: @{}];
        parameter[kJavaParameter_pubArgs] = [self addCommonParameter:nil].mj_JSONString ?: @"";
        
        if (self.requestMethod == THKHttpMethodGET) {
            NSString *argsComponent = parameter.mj_JSONString;
            argsComponent = [argsComponent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            return @{kJavaParameter_args:argsComponent ?: @{}};
        }
        
        return @{kJavaParameter_args:parameter ?: @{}};
    }
    
    if (self.requestMethod == THKHttpMethodGET) {
        NSString *argsComponent = self.parameters.mj_JSONString;
        argsComponent = [argsComponent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return @{kJavaParameter_args:argsComponent ?: @{}};
    }
    
    return @{kJavaParameter_args:self.parameters ?: @{}};
}

// 添加公参
- (NSDictionary *)addCommonParameter:(NSDictionary *)parameters {
    
    NSDictionary *requestParameterDict  = [THKBaseNetworkManager sharedManager].parameters;
    NSMutableDictionary *arguments      = [NSMutableDictionary dictionaryWithDictionary:requestParameterDict ?: @{}];
    
    [arguments addEntriesFromDictionary:parameters ?: @{}];
    
    return arguments;
}

#pragma mark -

// 发送网络请求
- (void)sendHttpRequestSuccess:(THKRequestSuccess)success failure:(THKRequestFailure)failure {
    if ([THKBaseNetworkManager sharedManager].startRequestBlock) {// 开始请求
        [THKBaseNetworkManager sharedManager].startRequestBlock(self);
    }
    
    [self startWithCompletionBlockSuccess:^(__kindof TBTBaseRequest * _Nonnull request) {
        if (request.requestSessionTask == TBTRequestSessionDownloadTask) {// 下载操作,返回的是本地存储地址
            [self handleResponseData:request.responseObject success:success failure:failure];
        } else {// 普通的网络请求
            [self handleResponseData:request.responseData success:success failure:failure];
        }
        if ([THKBaseNetworkManager sharedManager].successRequestBlock) {// 请求成功
            [THKBaseNetworkManager sharedManager].successRequestBlock(self);
        }
    } failure:^(__kindof TBTBaseRequest * _Nonnull request) {
        if (failure) {failure(request.error);}
        
        if ([THKBaseNetworkManager sharedManager].failureRequestBlock) {// 请求失败
            [THKBaseNetworkManager sharedManager].failureRequestBlock(self);
        }
    }];
}

// 处理请求结果
- (void)handleResponseData:(id)responseData success:(THKRequestSuccess)success failure:(THKRequestFailure)failure {
    NSDictionary *responseDict;
    
    if ([responseData isKindOfClass:[NSData class]]) {
        NSError *error;
        responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            if (failure) {failure(error);}
            return;
        }
    } else if ([responseData isKindOfClass:[NSURL class]]) {
        responseDict = @{@"data" : ((NSURL *)responseData).absoluteString,
                         @"errorCode" : @(200),};
    } else {
        NSError *error = [NSError errorWithDomain:THKResponseErrorDomain
                                             code:TBTResponseErrorInvalidClass
                                         userInfo:@{NSLocalizedDescriptionKey:@"Response is not support"}];
        if (failure) {failure(error);}
        return;
    }
    
    // 判断返回数据类型是否是字典
    if (![responseDict isKindOfClass:[NSDictionary class]]) {
        NSError *error = [NSError errorWithDomain:THKResponseErrorDomain
                                             code:TBTResponseErrorInvalidClass
                                         userInfo:@{NSLocalizedDescriptionKey:@"Response is not NSDictionary class"}];
        if (failure) {failure(error);}
        return;
    }
    
    // 保存解析后的NSDictionary, 供Radar(雷达SDK使用)
    [self setResponseDict:responseDict];
    [self analysisResult:[self unifyResponseObject:responseDict] success:success];
}

// 统一解析网络请求成功的数据
- (void)analysisResult:(NSDictionary *)dict success:(THKRequestSuccess)success {
    // 校验状态码, 做一些统一处理
    [self validateErrorCode:dict];
    
    id obj = nil;
    if (self.modelClass) {
        SEL sel = NSSelectorFromString(@"toModelWithDictionary:");
        if ([self.modelClass respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            obj = [self.modelClass performSelector:sel withObject:dict];
#pragma clang diagnostic pop
        }
    }
    
    if (success) {success(obj);}
}

// 接口返回的数据统一处理, 统一状态码, 返回数据最上层结构统一, 等等
- (NSDictionary *)unifyResponseObject:(NSDictionary *)dict {
    
    NSDictionary *dictValidator = @{@"status" : [NSNumber class],
                                    @"result" : [NSDictionary class]};
    NSDictionary *arrayValidator = @{@"status" : [NSNumber class],
                                     @"result" : [NSArray class]};
    NSDictionary *numberValidator = @{@"status" : [NSNumber class],
                                      @"result" : [NSNumber class]};
    NSDictionary *stringValidator = @{@"status" : [NSNumber class],
                                      @"result" : [NSString class]};
    NSDictionary *onlyStatusNumner = @{@"status" : [NSNumber class]};
    
    // 校验返回的数据结构
    BOOL dictResult  = [TBTNetworkManager validateJSON:dict withValidator:dictValidator];
    BOOL arrayResult = [TBTNetworkManager validateJSON:dict withValidator:arrayValidator];
    BOOL numberResult  = [TBTNetworkManager validateJSON:dict withValidator:numberValidator];
    BOOL stringResult = [TBTNetworkManager validateJSON:dict withValidator:stringValidator];
    BOOL statusNumberResult = [TBTNetworkManager validateJSON:dict withValidator:onlyStatusNumner];
    
    // 判断返回数据的结构
    if (dictResult || arrayResult || numberResult || stringResult || statusNumberResult) {
        NSInteger errorCode = THKErrorCodeOfNoData;
        NSInteger allRows = 0;
        NSString *errorMsg;
        THKStatus thkStatus = THKStatusFailure;
        id data;
        
        id status = dict[@"status"];// 取状态码
        if ([status respondsToSelector:@selector(integerValue)]) {
            errorCode = [status integerValue];
        }
        
        if (errorCode == 200 || errorCode == 0) {// 接口返回成功
            thkStatus = THKStatusSuccess;
            id result = dict[@"result"];
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                id rows  = result[@"rows"];
                id total = result[@"total"];
                
                if (rows && total) {
                    data = rows;
                    
                    if ([total respondsToSelector:@selector(integerValue)]) {
                        allRows = [total integerValue];
                    }
                } else {
                    data = result;
                }
            } else {
                data = result;
            }
        } else {// 接口返回失败, 读取错误信息
            if (dict[@"error"] && [dict[@"error"] isKindOfClass:[NSString class]]) {
                errorMsg = dict[@"error"];
            }
        }
        
        NSMutableDictionary *finalDict = [NSMutableDictionary dictionary];
        
        finalDict[@"errorCode"] = @(errorCode);
        finalDict[@"allRows"]   = @(allRows);
        finalDict[@"errorMsg"]  = errorMsg ?: @"";
        finalDict[@"status"]    = @(thkStatus);
        
        if (data) {
            finalDict[@"data"] = data;
        }
        
        return finalDict;
    }
    
    NSInteger errorCode = THKErrorCodeOfNoData;
    THKStatus thkStatus = THKStatusFailure;
    
    id status = dict[@"errorCode"];
    id errorMsg = dict[@"errorMsg"];
    
    if (status && [status respondsToSelector:@selector(integerValue)]) {
        errorCode = [status integerValue];
    }
    
    if (errorCode == 200 || errorCode == 0) {
        thkStatus = THKStatusSuccess;
    } else {
        id data = dict[@"data"];
        if (!errorMsg && data && [data isKindOfClass:[NSString class]]) {
            errorMsg = data;
        }
    }
    
    NSMutableDictionary *finalDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    finalDict[@"status"] = @(thkStatus);
    if (!finalDict[@"errorMsg"]) {
        finalDict[@"errorMsg"] = errorMsg ?: @"";
    }
    
    return finalDict;
}

// 校验状态码
- (void)validateErrorCode:(NSDictionary *)dict {
    NSInteger errorCode = THKErrorCodeOfNoData;
    
    id code = dict[@"errorCode"];// 取状态码
    if ([code respondsToSelector:@selector(integerValue)]) {
        errorCode = [code integerValue];
    }
    
    if (errorCode != 0 && errorCode != 200 && errorCode != 404 && errorCode != THKErrorCodeOfNoData) {
#if TLOG_ENABLE
        [TLog logErrorInfo:[NSString stringWithFormat:@"post err : %@",dict]];
#endif
    }
    
    if (errorCode == 10009 || errorCode == 10008 || errorCode == 10007 || errorCode == 636 || errorCode == 605) {
        [[NSNotificationCenter defaultCenter] postNotificationName:THKNotificationOfTokenError object:self];
    }
}

#pragma mark - Radar

// HTTP String Method
- (NSString *)getHttpMethod {
    THKHttpMethod method = [self httpMethod];
    
    if (method == THKHttpMethodPOST) {
        return @"POST";
    }
    
    return @"POST";
}

#pragma mark - RAC

- (RACSignal *)rac_requestSignal {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self sendHttpRequestSuccess:^(THKResponse *responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            
            // 主动取消网络请求, 不需要回调回去
            if ([error isKindOfClass:[NSError class]] && error.code == -999) {return;}
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            if (self.isExecuting) {
                [self cancel];
            }
        }];
    }];
    
#if DEBUG
    NSString *description = [[NSString alloc] initWithFormat:@"<%@: %p>", [self class], self];
    [signal setNameWithFormat:@"%@ -RAC_THKRequest", description];
#endif
    
    return signal;
}

@end
