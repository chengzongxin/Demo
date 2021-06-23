//
//  THKUploadRequest.h
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/7/10.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^THKUploadProgressBlock)(NSProgress *progress);

@interface THKUploadRequest : THKBaseRequest

/**
 带上传文件字典
 key为文件名，value为文件沙盒路径
 */
@property (nonatomic, strong) NSDictionary *fileDict;

/**
 开始上传

 @param progressBlock 上传进度回调
 @param success 上传成功回调
 @param failure 上传失败回调
 */
- (void)uploadWithProgress:(THKUploadProgressBlock)progressBlock
                   success:(THKRequestSuccess)success
                   failure:(THKRequestFailure)failure;

@end

NS_ASSUME_NONNULL_END
