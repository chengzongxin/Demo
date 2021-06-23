//
//  TBTNetworkManager.m
//  TBTNetwork
//
//  Created by 荀青锋 on 2019/6/26.
//

#import "TBTNetworkManager.h"
#import "TBTNetworkConfig.h"
#import "TBTNetworkPrivate.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

// 此宏定义依赖内部成员变量, 不对外暴露使用, 仅供TBTNetworkManager内部使用
#define Lock()       dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER)
#define Unlock()     dispatch_semaphore_signal(_semaphore)

#define kTBTNetworkIncompleteDownloadFolderName @"Incomplete"

@interface TBTNetworkManager () {
    AFHTTPSessionManager *_manager;
    TBTNetworkConfig *_config;
    AFJSONResponseSerializer *_jsonResponseSerializer;
    AFXMLParserResponseSerializer *_xmlParserResponseSerialzier;
    NSMutableDictionary<NSNumber *, TBTBaseRequest *> *_requestsRecord;
    
    dispatch_queue_t _processingQueue;
    dispatch_semaphore_t _semaphore;
}

@end

@implementation TBTNetworkManager

+ (TBTNetworkManager *)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _config = [TBTNetworkConfig sharedConfig];
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_config.sessionConfiguration];
        _requestsRecord = [NSMutableDictionary dictionary];
        _processingQueue = dispatch_queue_create("com.tubatu.networkmanager.processing", DISPATCH_QUEUE_CONCURRENT);
        _semaphore = dispatch_semaphore_create(1);
        
        _manager.securityPolicy = _config.securityPolicy;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = _config.acceptableContentTypes;
        _manager.completionQueue = _processingQueue;
    }
    return self;
}

#pragma mark - Getter

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier {
    if (!_xmlParserResponseSerialzier) {
        _xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
    }
    return _xmlParserResponseSerialzier;
}

#pragma mark - public

- (void)addRequest:(TBTBaseRequest *)request {
    NSParameterAssert(request != nil);
    
    NSError * __autoreleasing requestSerializationError = nil;
    
    NSURLRequest *customUrlRequest= [request buildCustomUrlRequest];
    if (customUrlRequest) {
        __block NSURLSessionDataTask *dataTask = nil;
        dataTask = [_manager dataTaskWithRequest:customUrlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            [self handleRequest:dataTask uploadProgress:uploadProgress];
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            [self handleRequest:dataTask downloadProgress:downloadProgress];
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self handleRequestResult:dataTask responseObject:responseObject error:error];
        }];
        
        // 兼容AFNetworking3.0以下版本
//        dataTask = [_manager dataTaskWithRequest:customUrlRequest
//                               completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                                   [self handleRequestResult:dataTask responseObject:responseObject error:error];
//                               }];
        request.requestTask = dataTask;
    } else {
        request.requestTask = [self sessionTaskForRequest:request error:&requestSerializationError];
    }
    
    if (requestSerializationError) {
        [self requestDidFailWithRequest:request error:requestSerializationError];
        return;
    }
    
    NSAssert(request.requestTask != nil, @"requestTask should not be nil");
    
    // Set request task priority
    // !!Available on iOS 8 +
    if ([request.requestTask respondsToSelector:@selector(priority)]) {
        switch (request.requestPriority) {
            case TBTRequestPriorityHigh:
                request.requestTask.priority = NSURLSessionTaskPriorityHigh;
                break;
            case TBTRequestPriorityLow:
                request.requestTask.priority = NSURLSessionTaskPriorityLow;
                break;
            case TBTRequestPriorityDefault:
                /*!!fall through*/
            default:
                request.requestTask.priority = NSURLSessionTaskPriorityDefault;
                break;
        }
    }
    
    // Retain request
    NSLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addRequestToRecord:request];
    [request.requestTask resume];
}

- (void)cancelRequest:(TBTBaseRequest *)request {
    NSParameterAssert(request != nil);
    
    if (request.requestSessionTask == TBTRequestSessionDownloadTask && request.resumableDownloadPath) {
        NSURLSessionDownloadTask *requestTask = (NSURLSessionDownloadTask *)request.requestTask;
        [requestTask cancelByProducingResumeData:^(NSData *resumeData) {
            NSURL *localUrl = [self incompleteDownloadTempPathForDownloadPath:request.resumableDownloadPath];
            [resumeData writeToURL:localUrl atomically:YES];
        }];
    } else {
        [request.requestTask cancel];
    }
    
    [request clearCompletionBlock];
    [self removeRequestFromRecord:request];
}

- (void)cancelAllRequests {
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            Lock();
            TBTBaseRequest *request = _requestsRecord[key];
            Unlock();
            
            [request stop];
        }
    }
}

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator {
    return [TBTNetworkUtils validateJSON:json withValidator:jsonValidator];
}

#pragma mark - private

#pragma mark -

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    Lock();
    TBTBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    
    if (!request) {
        return;
    }
    
    NSLog(@"Finished Request: %@", NSStringFromClass([request class]));
    
    NSError * __autoreleasing serializationError = nil;
    
    NSError *requestError = nil;
    BOOL succeed = NO;
    
    request.responseObject = responseObject;
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        request.responseData = responseObject;
        request.responseString = [[NSString alloc] initWithData:responseObject encoding:[TBTNetworkUtils stringEncodingWithRequest:request]];
        
        switch (request.responseSerializerType) {
            case TBTResponseSerializerTypeHTTP:
                // Default serializer. Do nothing.
                break;
            case TBTResponseSerializerTypeJSON:
                request.responseObject = [self.jsonResponseSerializer responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                request.responseJSONObject = request.responseObject;
                break;
            case TBTResponseSerializerTypeXMLParser:
                request.responseObject = [self.xmlParserResponseSerialzier responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                break;
        }
    }
    
    if (error) {
        succeed = NO;
        requestError = error;
    } else if (serializationError) {
        succeed = NO;
        requestError = serializationError;
    } else {
        succeed = YES;
    }
    
    if (succeed) {
        [self requestDidSucceedWithRequest:request];
    } else {
        [self requestDidFailWithRequest:request error:requestError];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        [request clearCompletionBlock];
    });
}

- (void)requestDidSucceedWithRequest:(TBTBaseRequest *)request {
    @autoreleasepool {
        [request requestCompletePreprocessor];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestFinished:)]) {
            [request.delegate requestFinished:request];
        }
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
    });
}

- (void)requestDidFailWithRequest:(TBTBaseRequest *)request error:(NSError *)error {
    /// [Fix][https://bugly.qq.com/v2/crash-reporting/crashes/11974f7df6/401935?pid=2]
    /// -[NSConcreteMutableData localizedDescription]: unrecognized selector sent to instance 0x28195db60
    if (error && [error isKindOfClass:[NSError class]]) {
        request.error = error;
        NSLog(@"Request %@ failed, status code = %ld, error = %@",
               NSStringFromClass([request class]), (long)request.responseStatusCode, error.localizedDescription);
        
        // 保存未完成下载的数据.
        NSData *incompleteDownloadData = error.userInfo[NSURLSessionDownloadTaskResumeData];
        if (incompleteDownloadData) {
            [incompleteDownloadData writeToURL:[self incompleteDownloadTempPathForDownloadPath:request.resumableDownloadPath] atomically:YES];
        }
    }
    
    // 如果下载失败, 从文件中加载响应数据, 清空本地文件
    if ([request.responseObject isKindOfClass:[NSURL class]]) {
        NSURL *url = request.responseObject;
        if (url.isFileURL && [[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            request.responseData = [NSData dataWithContentsOfURL:url];
            request.responseString = [[NSString alloc] initWithData:request.responseData encoding:[TBTNetworkUtils stringEncodingWithRequest:request]];
            
            [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        }
        request.responseObject = nil;
    }
    
    @autoreleasepool {
        [request requestFailedPreprocessor];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil && [request.delegate respondsToSelector:@selector(requestFailed:)]) {
            [request.delegate requestFailed:request];
        }
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    });
}

- (void)handleRequest:(NSURLSessionTask *)task uploadProgress:(NSProgress *)uploadProgress {
    Lock();
    TBTBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    
    if (!request) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil && [request.delegate respondsToSelector:@selector(request:uploadProgress:)]) {
            [request.delegate request:request uploadProgress:uploadProgress];
        }
        if (request.uploadProgressBlock) {
            request.uploadProgressBlock(uploadProgress);
        }
    });
}

- (void)handleRequest:(NSURLSessionTask *)task downloadProgress:(NSProgress *)downloadProgress {
    Lock();
    TBTBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    
    if (!request) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil && [request.delegate respondsToSelector:@selector(request:downloadProgress:)]) {
            [request.delegate request:request downloadProgress:downloadProgress];
        }
        if (request.downLoadProgressBlock) {
            request.downLoadProgressBlock(downloadProgress);
        }
    });
}

- (void)addRequestToRecord:(TBTBaseRequest *)request {
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecord:(TBTBaseRequest *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    NSLog(@"Request queue size = %zd", [_requestsRecord count]);
    Unlock();
}

#pragma mark -

- (NSString *)httpMethod:(TBTBaseRequest *)request {
    TBTRequestMethod method = [request requestMethod];
    
    switch (method) {
        case TBTRequestMethodGET:
            return @"GET";
        case TBTRequestMethodPOST:
            return @"POST";
        case TBTRequestMethodHEAD:
            return @"HEAD";
        case TBTRequestMethodPUT:
            return @"PUT";
        case TBTRequestMethodDELETE:
            return @"DELETE";
        case TBTRequestMethodPATCH:
            return @"PATCH";
    }
    
    return @"GET";
}

- (NSString *)buildRequestUrl:(TBTBaseRequest *)request {
    NSParameterAssert(request != nil);
    
    NSString *detailUrl = [request requestPath];
    NSURL *temp = [NSURL URLWithString:detailUrl];
    // If detailUrl is valid URL
    if (temp && temp.host && temp.scheme) {
        return detailUrl;
    }
    
    NSString *baseUrl;
    
    if ([request baseUrl].length > 0) {
        baseUrl = [request baseUrl];
    } else {
        baseUrl = [_config baseUrl];
    }
    
    // URL slash compability
    NSURL *url = [NSURL URLWithString:baseUrl];
    
    if (baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    return [NSURL URLWithString:detailUrl relativeToURL:url].absoluteString;
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(TBTBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == TBTRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == TBTRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    requestSerializer.allowsCellularAccess = [request allowsCellularAccess];
    
    // If api needs to add custom value to HTTPHeaderField
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return requestSerializer;
}

- (NSURLSessionTask *)sessionTaskForRequest:(TBTBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    id param = [request requestArgument];
    NSString *url = [self buildRequestUrl:request];
    NSString *method = [self httpMethod:request];
    NSString *uploadPath = request.uploadFilePath;
    NSString *downloadPath = request.resumableDownloadPath;
    
    if(self.formatUrlBlock){
        if(url.length > 0){
            url = self.formatUrlBlock(url);
        }
        if(uploadPath.length > 0){
            uploadPath = self.formatUrlBlock(uploadPath);
        }
        if(downloadPath.length > 0){
            downloadPath = self.formatUrlBlock(downloadPath);
        }
    }
    
    TBTRequestSessionTask sessionTask = [request requestSessionTask];
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    
    if (sessionTask == TBTRequestSessionDataTask) {
        return [self dataTaskWithHTTPMethod:method
                          requestSerializer:requestSerializer
                                  URLString:url
                                 parameters:param
                          constructingBlock:constructingBlock
                                      error:error];
    }
    
    if (sessionTask == TBTRequestSessionUploadTask) {
        NSProgress *uploadProgress;
        NSURLSessionUploadTask *uploadTask = [self uploadTaskWithHTTPMethod:method
                                                                 uploadPath:uploadPath
                                                             uploadProgress:&uploadProgress
                                                          requestSerializer:requestSerializer
                                                                  URLString:url
                                                                 parameters:param
                                                          constructingBlock:constructingBlock
                                                                      error:error];
        if (uploadProgress) {
            request.uploadProgress = uploadProgress;
        }
        return uploadTask;
    }
    
    if (sessionTask == TBTRequestSessionDownloadTask) {
        NSProgress *downloadProgress;
        NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithHTTPMethod:method
                                                                     downloadPath:downloadPath
                                                                 downloadProgress:&downloadProgress
                                                                requestSerializer:requestSerializer
                                                                        URLString:url
                                                                       parameters:param
                                                                            error:error];
        if (downloadProgress) {
            request.downLoadProgress = downloadProgress;
        }
        return downloadTask;
    }
    
    return [self dataTaskWithHTTPMethod:method
                      requestSerializer:requestSerializer
                              URLString:url
                             parameters:param
                      constructingBlock:constructingBlock
                                  error:error];
}

#pragma mark -

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                               constructingBlock:(AFConstructingBlock)constructingBlock
                                           error:(NSError * _Nullable __autoreleasing *)error {
    
    NSMutableURLRequest *request = nil;
    
    if (constructingBlock && method && ![method isEqualToString:@"GET"] && ![method isEqualToString:@"HEAD"]) {
        request = [requestSerializer multipartFormRequestWithMethod:method
                                                          URLString:URLString
                                                         parameters:parameters
                                          constructingBodyWithBlock:constructingBlock
                                                              error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [_manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        [self handleRequest:dataTask uploadProgress:uploadProgress];
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        [self handleRequest:dataTask downloadProgress:downloadProgress];
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleRequestResult:dataTask responseObject:responseObject error:error];
    }];
    
    // 兼容AFNetworking3.0以下版本
//    dataTask = [_manager dataTaskWithRequest:request
//                           completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                               [self handleRequestResult:dataTask responseObject:responseObject error:error];
//                           }];
    return dataTask;
}

- (NSURLSessionUploadTask *)uploadTaskWithHTTPMethod:(NSString *)method
                                          uploadPath:(NSString *)uploadPath
                                      uploadProgress:(NSProgress * __autoreleasing *)uploadProgress
                                   requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                           URLString:(NSString *)URLString
                                          parameters:(id)parameters
                                   constructingBlock:(AFConstructingBlock)constructingBlock
                                               error:(NSError * _Nullable __autoreleasing *)error {
    
    NSMutableURLRequest *request = nil;
    
    if (constructingBlock && method && ![method isEqualToString:@"GET"] && ![method isEqualToString:@"HEAD"]) {
        request = [requestSerializer multipartFormRequestWithMethod:method
                                                          URLString:URLString
                                                         parameters:parameters
                                          constructingBodyWithBlock:constructingBlock
                                                              error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    
    NSURL *uploadUrl;
    // 如果是通过文件路径上传文件, 则校验文件路径,以及此路径下的文件是否存在
    if (uploadPath && uploadPath.length > 0) {
        BOOL isDirectory;
        if(![[NSFileManager defaultManager] fileExistsAtPath:uploadPath isDirectory:&isDirectory]) {
            isDirectory = NO;
        }
        
        NSAssert(isDirectory != YES, @"uploadPath can not be a Directory");
        
        if (isDirectory) {return nil;}
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:uploadPath];
        
        NSAssert(fileExists != NO, @"upload file not Exists");
        
        if (!fileExists) {return nil;}
        
        uploadUrl = [NSURL fileURLWithPath:uploadPath isDirectory:NO];
        
        NSAssert(uploadUrl != nil, @"uploadUrl can not be nil");
        
        if (!uploadUrl) {return nil;}
    }
    
    __block NSURLSessionUploadTask *uploadTask = nil;
    
    uploadTask = [_manager uploadTaskWithRequest:request fromFile:uploadUrl progress:^(NSProgress * _Nonnull uploadProgress) {
        [self handleRequest:uploadTask uploadProgress:uploadProgress];
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleRequestResult:uploadTask responseObject:responseObject error:error];
    }];
    
    // 兼容AFNetworking3.0以下版本
//    uploadTask = [_manager uploadTaskWithRequest:request
//                                        fromFile:uploadUrl
//                                        progress:uploadProgress
//                               completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                                   [self handleRequestResult:uploadTask responseObject:responseObject error:error];
//                               }];
    return uploadTask;
}

- (NSURLSessionDownloadTask *)downloadTaskWithHTTPMethod:(NSString *)method
                                            downloadPath:(NSString *)downloadPath
                                        downloadProgress:(NSProgress * __autoreleasing *)downloadProgress
                                       requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                               URLString:(NSString *)URLString
                                              parameters:(id)parameters
                                                   error:(NSError * _Nullable __autoreleasing *)error {
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    // 确保 downloadTargetPath 指向一个文件而不是文件目录
    if (isDirectory) {
        NSString *fileName = [request.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    
    // AF 使用方法 'moveItemAtURL' 将下载好的文件移动到 downloadTargetPath
    // 如果说 downloadTargetPath 已经存在文件 那么将会移动失败.
    // 所以在我们开始下载之前 需要先清空 downloadTargetPath 下的文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    
    BOOL resumeDataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path];
    NSData *data = [NSData dataWithContentsOfURL:[self incompleteDownloadTempPathForDownloadPath:downloadPath]];
    BOOL resumeDataIsValid = [TBTNetworkUtils validateResumeData:data];
    
    BOOL canBeResumed = resumeDataFileExists && resumeDataIsValid;
    BOOL resumeSucceeded = NO;
    
    __block NSURLSessionDownloadTask *downloadTask = nil;
    
    // 先尝试恢复下载, 如果恢复下载失败则重新下载
    if (canBeResumed) {
        @try {
            downloadTask = [_manager downloadTaskWithResumeData:data progress:^(NSProgress * _Nonnull downloadProgress) {
                [self handleRequest:downloadTask downloadProgress:downloadProgress];
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [self handleRequestResult:downloadTask responseObject:filePath error:error];
            }];
            
            // 兼容AFNetworking3.0以下版本
//            downloadTask = [_manager downloadTaskWithResumeData:data
//                                                       progress:downloadProgress
//                                                    destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//                                                        return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
//                                                    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//                                                        [self handleRequestResult:downloadTask responseObject:filePath error:error];
//                                                    }];
            resumeSucceeded = YES;
        } @catch (NSException *exception) {
            NSLog(@"Resume download failed, reason = %@", exception.reason);
            resumeSucceeded = NO;
        }
    }
    if (!resumeSucceeded) {
        downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            [self handleRequest:downloadTask downloadProgress:downloadProgress];
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [self handleRequestResult:downloadTask responseObject:filePath error:error];
        }];
        
        // 兼容AFNetworking3.0以下版本
//        downloadTask = [_manager downloadTaskWithRequest:request
//                                                progress:downloadProgress
//                                             destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//                                                 return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
//                                             } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//                                                 [self handleRequestResult:downloadTask responseObject:filePath error:error];
//                                             }];
    }
    
    return downloadTask;
}

#pragma mark - Resumable Download

- (NSString *)incompleteDownloadTempCacheFolder {
    NSFileManager *fileManager = [NSFileManager new];
    static NSString *cacheFolder;
    
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:kTBTNetworkIncompleteDownloadFolderName];
    }
    
    NSError *error = nil;
    if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"Failed to create cache directory at %@", cacheFolder);
        cacheFolder = nil;
    }
    return cacheFolder;
}

- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
    NSString *tempPath = nil;
    NSString *md5URLString = [TBTNetworkUtils md5StringFromString:downloadPath];
    tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
    return [NSURL fileURLWithPath:tempPath];
}

@end
