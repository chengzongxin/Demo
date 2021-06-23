//
//  THKUploadRequest.m
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/7/10.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKUploadRequest.h"
#import <AFNetworking/AFNetworking.h>

@interface THKUploadRequest ()

@property (nonatomic, assign) BOOL hasObserver;

@end

@implementation THKUploadRequest

- (void)dealloc {
    if (!self.hasObserver) {
        return;
    }
    
    @try {
        [self.uploadProgress removeObserver:self forKeyPath:@"fractionCompleted"];
    } @catch (NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
}

#pragma mark - THKBaseRequestProtocol

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

#pragma mark - Subclass Override

- (TBTRequestSessionTask)requestSessionTask {
    return TBTRequestSessionUploadTask;
}

#pragma mark - Upload

- (void)uploadWithProgress:(THKUploadProgressBlock)progressBlock
                   success:(THKRequestSuccess)success
                   failure:(THKRequestFailure)failure {
    
    self.uploadProgressBlock = progressBlock;
    
    [self sendSuccess:success failure:failure];
    
    if (self.uploadProgress) {
        [self.uploadProgress addObserver:self
                              forKeyPath:@"fractionCompleted"
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
        self.hasObserver = YES;
    }
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if (![keyPath isEqualToString:@"fractionCompleted"]) {
        return;
    }
    
    if (![object isKindOfClass:[NSProgress class]]) {
        return;
    }
    
    if ([NSThread isMainThread]) {
        if (self.uploadProgressBlock) {
            self.uploadProgressBlock(object);
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.uploadProgressBlock) {
                self.uploadProgressBlock(object);
            }
        });
    }
}

#pragma mark - Getter

- (AFConstructingBlock)constructingBodyBlock {
    
    AFConstructingBlock block = ^(id<AFMultipartFormData>  _Nonnull formData) {
        [self.fileDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSURL *fileUrl = [NSURL fileURLWithPath:obj isDirectory:NO];
            
            NSParameterAssert(fileUrl != nil);
            
            if (fileUrl) {
                NSError *error;
                [formData appendPartWithFileURL:fileUrl name:key error:&error];
                
                if (error) {
                    NSLog(@"AFConstructingBlock---Upload---Error:%@", error);
                }
            }
        }];
    };
    
    return block;
}

@end
