//
//  THKDownloadRequest.m
//  THKBaseNetwork
//
//  Created by 荀青锋 on 2020/3/2.
//

#import "THKDownloadRequest.h"

@interface THKDownloadRequest ()

@property (nonatomic, assign) BOOL hasObserver;

@end

@implementation THKDownloadRequest

- (void)dealloc {
    if (!self.hasObserver) {
        return;
    }
    @try {
        [self.downLoadProgress removeObserver:self forKeyPath:@"fractionCompleted"];
    } @catch (NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
}

#pragma mark - Subclass Override

- (TBTRequestSessionTask)requestSessionTask {
    return TBTRequestSessionDownloadTask;
}

#pragma mark - Download

- (void)downloadWithProgress:(THKDownloadProgressBlock)progressBlock
                     success:(THKRequestSuccess)success
                     failure:(THKRequestFailure)failure {
    
    self.downLoadProgressBlock = progressBlock;
    
    [self sendSuccess:success failure:failure];
    
    if (self.downLoadProgress) {
        [self.downLoadProgress addObserver:self
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
        if (self.downLoadProgressBlock) {
            self.downLoadProgressBlock(object);
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.downLoadProgressBlock) {
                self.downLoadProgressBlock(object);
            }
        });
    }
}

#pragma mark - #pragma mark - Getter

- (NSString *)resumableDownloadPath {
    return self.downloadPath;
}

@end
