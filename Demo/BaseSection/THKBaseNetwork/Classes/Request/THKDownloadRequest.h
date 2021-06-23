//
//  THKDownloadRequest.h
//  THKBaseNetwork
//
//  Created by 荀青锋 on 2020/3/2.
//

#import "THKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^THKDownloadProgressBlock)(NSProgress *progress);

@interface THKDownloadRequest : THKBaseRequest

// 下载地址
@property (nonatomic, copy) NSString *downloadPath;

// 开始下载
- (void)downloadWithProgress:(THKDownloadProgressBlock)progressBlock
                     success:(THKRequestSuccess)success
                     failure:(THKRequestFailure)failure;

@end

NS_ASSUME_NONNULL_END
