//
//  TBTBaseRequest.m
//  Pods-TBTNetwork_Example
//
//  Created by 荀青锋 on 2019/6/26.
//

#import "TBTBaseRequest.h"
#import "TBTNetworkManager.h"

@interface TBTBaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;

@property (nonatomic, strong, readwrite, nullable) NSProgress *uploadProgress;
@property (nonatomic, strong, readwrite, nullable) NSProgress *downLoadProgress;

@end

@implementation TBTBaseRequest

#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}

- (BOOL)isCancelled {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}

#pragma mark - Request Configuration

- (void)setCompletionBlockWithSuccess:(TBTRequestCompletionBlock)success
                              failure:(TBTRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

#pragma mark - Request Action

- (void)start {
    [[TBTNetworkManager sharedManager] addRequest:self];
}

- (void)stop {
    self.delegate = nil;
    
    [[TBTNetworkManager sharedManager] cancelRequest:self];
}

- (void)startWithCompletionBlockSuccess:(TBTRequestCompletionBlock)success
                                failure:(TBTRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)startWithUploadProgress:(AFURLSessionTaskProgressBlock)uploadProgress
                        success:(TBTRequestCompletionBlock)success
                        failure:(TBTRequestCompletionBlock)failure {
    self.uploadProgressBlock = uploadProgress;
    
    [self start];
}

- (void)startWithDownloadProgress:(AFURLSessionTaskProgressBlock)downloadProgress
                          success:(TBTRequestCompletionBlock)success
                          failure:(TBTRequestCompletionBlock)failure {
    self.downLoadProgressBlock = downloadProgress;
    
    [self start];
}

#pragma mark - Subclass Override

- (void)requestCompletePreprocessor {}

- (void)requestFailedPreprocessor {}

- (NSString *)baseUrl {
    return @"";
}

- (NSString *)requestPath {
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (id)requestArgument {
    return nil;
}

- (TBTRequestSessionTask)requestSessionTask {
    return TBTRequestSessionDataTask;
}

- (TBTRequestMethod)requestMethod {
    return TBTRequestMethodGET;
}

- (TBTRequestSerializerType)requestSerializerType {
    return TBTRequestSerializerTypeHTTP;
}

- (TBTResponseSerializerType)responseSerializerType {
    return TBTResponseSerializerTypeJSON;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)allowsCellularAccess {
    return YES;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, self.currentRequest.URL, self.currentRequest.HTTPMethod, self.requestArgument];
}

@end
