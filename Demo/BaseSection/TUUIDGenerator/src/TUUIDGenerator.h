//
//  TUUIDGenerator.h
//  HouseKeeper
//
//  Created by jerry.jiang on 2017/8/31.
//  Copyright © 2017年 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUUIDGenerator : NSObject

@property (nonatomic, class) NSString *accessGroup;
@property (nonatomic, class) NSString *identifier;  //默认@"to8to.UUID"，非特殊情况无需修改

+ (NSString *)getUUID;

+ (NSString *)getFristId;

#pragma mark - get idfa string
///MARK: 因2021年开始，IDFA访问需要授权,类似相册访问授权，需要在plist配置对应Key信息：
///plist:
///<key>NSUserTrackingUsageDescription</key>
///<string>请允许获取并使用您的IDFA</string>
///

/// 获取idfa串
/// @note ios14之前的系统若用户未限制idfa访问，则直接读取 [ASIdentifierManager.sharedManager advertisingIdentifier].UUIDString 返回。
/// 若当前用户拒绝或关闭了访问权限，则返回 @"00000000-0000-0000-0000-000000000000"
/// 若ios14及以上系统的用户第一次尝试访问，则先返回 @"00000000-0000-0000-0000-000000000000"，然后会异常执行请求访问idfa权限流程，若用户允许访问，则后面访问时也会读取 [ASIdentifierManager.sharedManager advertisingIdentifier].UUIDString 后返回.
/// 内部逻辑会有缓存，若当前已获取到有效的idfa或者拒绝用户访问则会赋值占位值，并值相关值缓存在内存，后续多次调用方法时直接返回缓存值
+ (NSString *)getIDFA;

/// 判断idfa串是否有效
///@note 若idfa为nil或@""或@"00000000-0000-0000-0000-000000000000"则会返回NO，其它值坐返回YES
+ (BOOL)isValidIDFA:(NSString *)idfa;

#pragma mark - 增加idfa获取成功后的回调，方便上层业务在Idfa赋初始化值或异步授权允许后重新更新相关值后可以监控到更新结果

/// 当idfa被赋初始值或异步授权允许后更新了值后的回调
/// @param idfaStr 更新的Idfa串
/// @param isValidIDFA 更新的idfa是否是有效Idfa串，若是则YES，否则为NO
/// @warning 当ios13及以下，getIDFA方法会直接读取idfa串并返回；当ios14及以上，若当前已授权则直接读取并返回，若当前授权已被拒绝则读取默认00000000-0000-0000-0000-000000000000串返回，若当前触发了授权弹框则内部idfa变量会等待授权弹框操作后再赋值，注意：变量的异步赋值不会影响getIDFA的结果正常返回，当内部变量idfa无值时，方法会返回默认的占位串
@property (nonatomic, copy, nullable, class)void(^idfaInitOrUpdateBlock)(NSString *idfaStr, BOOL isValidIDFA);

@end
