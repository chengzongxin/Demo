//
//  THKPhpUploadRequest.h
//  HouseKeeper
//
//  Created by nigel.ning on 2019/11/28.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKUploadRequest.h"
#import "THKCommonResponse.h"

NS_ASSUME_NONNULL_BEGIN

/**
 php 接口上传功能可使用
 @note 目前在TPMHTTPManager中有使用此上传功能
 */
@interface THKPhpUploadRequest : THKUploadRequest

@property (nonatomic, copy)NSString *uploadUrl;///< 上传的php url地址, 只能指定php接口的地址

@property (nonatomic, strong, nullable)NSDictionary *customParams;///< 上传请求中可能携带的其它参数字典

@property (nonatomic, strong)Class customModelClass;///< 返回的response对应的类，默认为THKCommonResponse

///MARK: 上传文件使用父类里的fileDict即可, key为文件名，value为文件本地可访问到的存储路径

@end

NS_ASSUME_NONNULL_END
