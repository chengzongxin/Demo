//
//  TBTBaseRequest.h
//  Pods-TBTNetwork_Example
//
//  Created by 荀青锋 on 2019/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 HTTP 请求方法

 - TBTRequestMethodGET: GET
 - TBTRequestMethodPOST: POST
 - TBTRequestMethodHEAD: HEAD
 - TBTRequestMethodPUT: PUT
 - TBTRequestMethodDELETE: DELETE
 - TBTRequestMethodPATCH: PATCH
 */
typedef NS_ENUM(NSInteger, TBTRequestMethod) {
    TBTRequestMethodGET = 0,
    TBTRequestMethodPOST,
    TBTRequestMethodHEAD,
    TBTRequestMethodPUT,
    TBTRequestMethodDELETE,
    TBTRequestMethodPATCH,
};

/**
 网络请求入参类型

 - TBTRequestSerializerTypeHTTP: HTTP (对应 AFHTTPRequestSerializer)
 - TBTRequestSerializerTypeJSON: JSON (对应 AFJSONRequestSerializer)
 - TBTRequestSerializerTypeLIST: LIST (对应 AFPropertyListRequestSerializer)
 */
typedef NS_ENUM(NSInteger, TBTRequestSerializerType) {
    TBTRequestSerializerTypeHTTP = 0,
    TBTRequestSerializerTypeJSON,
    TBTRequestSerializerTypeLIST,
};

/**
 网络请求返回数据类型

 - TBTResponseSerializerTypeHTTP: NSData 类型 (默认类型不做任何序列化)
 - TBTResponseSerializerTypeJSON: JSON 类型 (对应 AFJSONResponseSerializer)
 - TBTResponseSerializerTypeXMLParser: NSXMLParser 类型 (对应 AFXMLParserResponseSerializer)
 */
typedef NS_ENUM(NSInteger, TBTResponseSerializerType) {
    TBTResponseSerializerTypeHTTP = 0,
    TBTResponseSerializerTypeJSON,
    TBTResponseSerializerTypeXMLParser,
};

/**
 网络请求优先级 (iOS8之后有效)

 - TBTRequestPriorityLow: 低优先级
 - TBTRequestPriorityDefault: 默认优先级
 - TBTRequestPriorityHigh: 高优先级
 */
typedef NS_ENUM(NSInteger, TBTRequestPriority) {
    TBTRequestPriorityLow = -4L,
    TBTRequestPriorityDefault = 0,
    TBTRequestPriorityHigh = 4,
};

/**
 用来决定使用哪种类型的 NSURLSessionTask 来发起网络请求
 
 - TBTRequestSessionDataTask: NSURLSessionDataTask
 - TBTRequestSessionUploadTask: NSURLSessionUploadTask
 - TBTRequestSessionDownloadTask: NSURLSessionDownloadTask
 */
typedef NS_ENUM(NSUInteger, TBTRequestSessionTask) {
    TBTRequestSessionDataTask = 0,
    TBTRequestSessionUploadTask,
    TBTRequestSessionDownloadTask,
};

@protocol AFMultipartFormData;

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress *progress);

@class TBTBaseRequest;

typedef void(^TBTRequestCompletionBlock)(__kindof TBTBaseRequest *request);

/**
 网络请求代理, 所有的代理方法都在主线程执行
 */
@protocol TBTRequestDelegate <NSObject>

@optional

/**
 网络请求成功代理

 @param request TBTBaseRequest 对象
 */
- (void)requestFinished:(__kindof TBTBaseRequest *)request;

/**
 上传进度代理

 @param request 当前网络请求对象
 @param uploadProgress 上传进度
 */
- (void)request:(__kindof TBTBaseRequest *)request uploadProgress:(NSProgress *)uploadProgress;

/**
 下载进度代理

 @param request 当前网络请求对象
 @param downloadProgress 下载进度
 */
- (void)request:(__kindof TBTBaseRequest *)request downloadProgress:(NSProgress *)downloadProgress;

/**
 网络请求失败代理

 @param request TBTBaseRequest 对象
 */
- (void)requestFailed:(__kindof TBTBaseRequest *)request;

@end

@interface TBTBaseRequest : NSObject

#pragma mark - Request and Response Information

/**
 NSURLSessionTask 对象
 在网络请求发起之前是nil
 */
@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;

/**
 当前的NSURLRequest, 取自requestTask.currentRequest
 */
@property (nonatomic, strong, readonly) NSURLRequest *currentRequest;

/**
 原始的NSURLRequest, 取自requestTask.originalRequest
 */
@property (nonatomic, strong, readonly) NSURLRequest *originalRequest;

/**
 请求的相应数据, 取自requestTask.response
 */
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;

/**
 网络请求相应的状态码
 */
@property (nonatomic, readonly) NSInteger responseStatusCode;

/**
 网络请求响应头
 */
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;

/**
 原始的网络请求响应数据, 网络请求失败可能会是nil
 */
@property (nonatomic, strong, readonly, nullable) NSData *responseData;

/**
 网络请求字符串响应数据, 网络请求失败可能会是nil
 */
@property (nonatomic, strong, readonly, nullable) NSString *responseString;

/**
 序列化过的网络请求响应数据, 具体类型由TBTResponseSerializerType类决定,网络请求失败可能会是nil
 */
@property (nonatomic, strong, readonly, nullable) id responseObject;

/**
 使用TBTResponseSerializerTypeJSON类型的, 可以通过此方法快捷的获取到响应数据, 如果不是此种类型则为nil
 */
@property (nonatomic, strong, readonly, nullable) id responseJSONObject;

/**
 错误信息, 可能是序列化中的错误, 也可能是网络请求中的错误, 如果没有任何错误则为nil
 */
@property (nonatomic, strong, readonly, nullable) NSError *error;

/**
 网络请求是否被取消, 取自 requestTask.state
 */
@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;

/**
 网络请求是否正在执行, 取自 requestTask.state
 */
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;

/**
 上传进度, 兼容AFNetworking3.0以下版本用到
 */
@property (nonatomic, strong, readonly, nullable) NSProgress *uploadProgress;

/**
 下载进度, 兼容AFNetworking3.0以下版本用到
 */
@property (nonatomic, strong, readonly, nullable) NSProgress *downLoadProgress;

#pragma mark - Request Configuration

/**
 网络请求tag值, 可以用来表示某个网络请求, 默认为0
 */
@property (nonatomic) NSInteger tag;

/**
 其他信息, 可以用来存放和此网络请求有关的信息, 默认为nil
 */
@property (nonatomic, strong, nullable) NSDictionary *userInfo;

/**
 网络请求代理, 默认为nil
 */
@property (nonatomic, weak, nullable) id<TBTRequestDelegate> delegate;

/**
 网络请求成功回调, 如果同时实现了代理方法'requestFinished'和此回调, 代理方法会先执行, 都在主线程执行
 */
@property (nonatomic, copy, nullable) TBTRequestCompletionBlock successCompletionBlock;

/**
 网络请求失败回调, 如果同时实现了代理方法'requestFailed'和此回调, 代理方法先执行, 都在主线程执行
 */
@property (nonatomic, copy, nullable) TBTRequestCompletionBlock failureCompletionBlock;

/**
 上传进度, 如果同时实现了代理方法'request:uploadProgress:'和此回调, 代理方法先执行, 都在主线程执行
 */
@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock uploadProgressBlock;

/**
 下载进度, 如果同时实现了代理方法'request:downLoadProgress:'和此回调, 代理方法先执行, 都在主线程执行
 */
@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock downLoadProgressBlock;

/**
 可以用此Block构建HTTP请求的body, 仅限POST请求, 默认为nil
 */
@property (nonatomic, copy, nullable) AFConstructingBlock constructingBodyBlock;

/**
 可恢复下载路径, NSURLSessionDownloadTask用到的
 */
@property (nonatomic, strong, nullable) NSString *resumableDownloadPath;

/**
 待上传文件路径
 */
@property (nonatomic, strong, nullable) NSString *uploadFilePath;

/**
 网络请求优先级, 仅在iOS8之后有效, 默认 TBTRequestPriorityDefault
 */
@property (nonatomic) TBTRequestPriority requestPriority;

/**
 网络请求结束回调

 @param success 成功回调
 @param failure 失败回调
 */
- (void)setCompletionBlockWithSuccess:(nullable TBTRequestCompletionBlock)success
                              failure:(nullable TBTRequestCompletionBlock)failure;

/**
 清除网络请求结束回调, 包括成功回调和失败回调, 置为nil
 */
- (void)clearCompletionBlock;


#pragma mark - Request Action

/**
 发起网络请求
 */
- (void)start;

/**
 停止网络请求
 */
- (void)stop;

/**
 发起网络请求

 @param success 网络请求成功回调
 @param failure 网络请求失败回调
 */
- (void)startWithCompletionBlockSuccess:(nullable TBTRequestCompletionBlock)success
                                failure:(nullable TBTRequestCompletionBlock)failure;

/**
 开始上传

 @param uploadProgress 上传进度回调
 @param success 上传成功回调
 @param failure 上传失败回调
 */
- (void)startWithUploadProgress:(nullable AFURLSessionTaskProgressBlock)uploadProgress
                        success:(nullable TBTRequestCompletionBlock)success
                        failure:(nullable TBTRequestCompletionBlock)failure;

/**
 开始下载

 @param downloadProgress 下载进度回调
 @param success 下载成功回调
 @param failure 下载失败回调
 */
- (void)startWithDownloadProgress:(nullable AFURLSessionTaskProgressBlock)downloadProgress
                          success:(nullable TBTRequestCompletionBlock)success
                          failure:(nullable TBTRequestCompletionBlock)failure;

#pragma mark - Subclass Override

/**
 网络请求成功前的预处理操作, 网络请求成功后在子线程调用, 如果缓存加载成功则在主线程调用.
 在成功回调和代理之前调用
 */
- (void)requestCompletePreprocessor;

/**
 网络请求失败前的预处理操作, 在子线程调用, 在失败回调和代理之前调用
 */
- (void)requestFailedPreprocessor;

/**
 baseUrl 应该只包含URL的host部分, 例如: http://www.example.com

 @return baseUrl
 */
- (NSString *)baseUrl;

/**
 requestPath 应该只包含URL的path部分, 例如: /v1/user
 requestPath将会通过方法 [NSURL URLWithString:relativeToURL:] 链接起来, 所以baseUrl和requestPath请按照要求来写
 如果requestPath本身是一个有效的URL, 他将会是最终使用的URL,baseUrl将会被忽略

 @return requestPath
 */
- (NSString *)requestPath;

/**
 网络请求超时时间 默认 60秒
 当使用`resumableDownloadPath`(NSURLSessionDownloadTask)的时候NSURLRequest的timeoutInterval属性不起作用.
 可以通过设置NSURLSessionConfiguration的timeoutIntervalForResource属性来达到目的
 
 @return requestTimeoutInterval
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 网络请求参数

 @return requestArgument
 */
- (nullable id)requestArgument;


/**
 网络请求类型, 默认TBTRequestSessionDataTask
 TBTRequestSessionUploadTask: 上传
 TBTRequestSessionDownloadTask: 下载

 @return 网络请求类型
 */
- (TBTRequestSessionTask)requestSessionTask;

/**
 HTTP 请求方法

 @return requestMethod
 */
- (TBTRequestMethod)requestMethod;

/**
 网络请求入参类型

 @return requestSerializerType
 */
- (TBTRequestSerializerType)requestSerializerType;

/**
 网络请求返回结果类型

 @return responseSerializerType
 */
- (TBTResponseSerializerType)responseSerializerType;

/**
 网络请求头

 @return requestHeaderFieldValueDictionary
 */
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary;

/**
 自定义Request 如果返回值不为空, 则requestPath,requestTimeoutInterval,requestArgument,
 allowsCellularAccess,requestMethod,requestSerializerType将会被忽略

 @return buildCustomUrlRequest
 */
- (nullable NSURLRequest *)buildCustomUrlRequest;

/**
 是否允许使用移动蜂窝网 默认允许:YES

 @return allowsCellularAccess
 */
- (BOOL)allowsCellularAccess;

@end

NS_ASSUME_NONNULL_END
