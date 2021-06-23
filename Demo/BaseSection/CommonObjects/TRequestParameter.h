//
//  TRequestParameter.h
//  TBasicLib
//
//  Created by kevin.huang on 14-7-8.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

/*
 *  网络请求的公共参数，所有的网络请求都会添加，用单例配置
 */

#import <Foundation/Foundation.h>

typedef id(^THKObjectBlock)(void);

@interface TRequestParameter : NSObject
// 设备id，UUIDString
@property (nonatomic, strong) NSString *t8t_device_id;
// 用户id
@property (nonatomic, assign) NSInteger uid;
// api版本
@property (nonatomic, strong) NSString *version;
// 用户token
@property (nonatomic, strong) NSString *to8to_token;
// app版本
@property (nonatomic, strong) NSString *appversion;
// 设备系统版本
@property (nonatomic, strong) NSString *systemversion;
// 渠道
@property (nonatomic, strong) NSString *channel;
// 广告唯一标示符 idfa
@property (nonatomic, strong) NSString *idfa;
// 平台 2是ios
@property (nonatomic, assign) NSInteger appostype;
// deviceModel
@property (nonatomic, copy) NSString * deviceModel;
// first_id
@property (nonatomic, copy) NSString *first_id;
// 是否是新安装用户 YES:是新安装用户, NO:不是新安装用户
@property (nonatomic, assign) NSInteger isnew;
// 账户id
@property (nonatomic, assign) NSInteger accountId;
// 城市id
@property (nonatomic, assign) NSInteger cityid;
// 城市名称
@property (nonatomic, copy) NSString *cityName;


+ (instancetype)sharedParameter;

/**
 * userAgent
 */
- (NSString *)userAgent;

/**
 *  向默认的参数中添加更多的参数
 *
 *  @param dicParameter 添加参数的字典
 */
- (void)appendDicParameter:(NSDictionary *)dicParameter;

/**
 *  获取公共的请求参数
 *
 *  @return 返回公共请求参数
 */
- (NSDictionary *)getSharedParameter;
/**
 *  获取公共的请求参数字符串，主要用于get请求
 *
 *  @return 返回公共请求参数字符串
 */
+ (NSString *)parameterStringForGet;
/**
 *  给get链接添加公共参数
 *
 *  @strUrl 将要添加公共参数的url
 *
 *  @return 返回公共请求参数字符串
 */
+ (NSString *)addCommonParameterForUrl:(NSString *)strUrl;

- (void)setCityIdBlock:(THKObjectBlock)cityIdBlock;

- (void)setCityNameBlock:(THKObjectBlock)cityNameBlock;

@end
