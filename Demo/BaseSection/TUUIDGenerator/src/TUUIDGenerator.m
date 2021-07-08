//
//  TUUIDGenerator.m
//  HouseKeeper
//
//  Created by jerry.jiang on 2017/8/31.
//  Copyright © 2017年 binxun. All rights reserved.
//

#import "TUUIDGenerator.h"
#import "KeychainItemWrapper.h"
#import <AdSupport/AdSupport.h>

#ifdef __IPHONE_14_0
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif

@implementation TUUIDGenerator

static NSString *_accessGroup = nil;
static NSString *_identifier = @"to8to.UUID";

+ (void)setAccessGroup:(NSString *)accessGroup {
    _accessGroup = accessGroup;
}

+ (NSString *)accessGroup {
    return _accessGroup;
}

+ (void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
}

+ (NSString *)identifier {
    return _identifier;
}

#pragma mark -
+ (NSString *)getUUID {
    NSAssert(_accessGroup != nil, @"accessGroup should not be nil");
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:_identifier accessGroup:_accessGroup];
    NSString *uuid = (NSString *)[wrapper objectForKey:(__bridge id)kSecAttrService];
    if (!uuid || ![uuid isKindOfClass:[NSString class]] || uuid.length == 0) {
        CFUUIDRef uuidref = CFUUIDCreate(kCFAllocatorDefault);
        uuid = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidref));
        CFRelease(uuidref);
        [wrapper setObject:uuid forKey:(__bridge id)kSecAttrService];
    }
    return uuid;
}


+ (NSString *)getFristId {
    NSAssert(_accessGroup != nil, @"accessGroup should not be nil");
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:_identifier accessGroup:_accessGroup];
    NSString *fristId = (NSString *)[wrapper objectForKey:(__bridge id)kSecValueData];
    if (!fristId || ![fristId isKindOfClass:[NSString class]] || fristId.length == 0) {
        NSString *idfa = [self getIDFA];
        if ([self isValidIDFA:idfa]) {
            fristId = idfa;
        }else {
            fristId = [self getUUID];
        }
        [wrapper setObject:fristId forKey:(__bridge id)kSecValueData];
    }
    return fristId;
}


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

static NSString *_idfa = nil;
static NSString *_idfa_placeholder = @"00000000-0000-0000-0000-000000000000";
static NSInteger _idfa_authorizing_status = 0;

+ (NSString *)getIDFA {
    if (_idfa.length == 0) {
        if (@available(iOS 14, *)) {
            //iOS 14 单独请求授权访问
#if DEBUG
            BOOL checkInfoPlist = [self checkInfoPlistAuthorizationIDFA];
            NSAssert(checkInfoPlist, @"ios 14, app-info.plist must contain the idfa authorization key: NSUserTrackingUsageDescription, the value can be: '请允许获取并使用您的IDFA' .");
#endif
            ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                //已允许,则直接读取
                _idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                //
                [self asyncExcuteIdfaValueUpdateBlockIfNeed];
            }else if (status == ATTrackingManagerAuthorizationStatusNotDetermined) {
                //请求访问授权
                if (_idfa_authorizing_status == 0) {
                    //加访问授权中的状态，防止连续多次调用getIDFA,出现多次授权请求(理论上多次授权请求不会触发)
                    _idfa_authorizing_status = 1;
                    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                        if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                            _idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                        }else {
                            _idfa = _idfa_placeholder;
                        }
                        _idfa_authorizing_status = 0;
                        //
                        [self asyncExcuteIdfaValueUpdateBlockIfNeed];
                    }];
                }
            }else {
                //其它：用户关闭了设备广告跟踪或用户拒绝了app访问idfa权限时，直接使用占位串
                _idfa = _idfa_placeholder;
                //
                [self asyncExcuteIdfaValueUpdateBlockIfNeed];
            }
        }else {
            //iOS13以下
            //此开关在iOS14默认都会返回NO
            if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
                _idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
            } else {
                _idfa = _idfa_placeholder;
            }
            //
            [self asyncExcuteIdfaValueUpdateBlockIfNeed];
        }
    }
    return _idfa.length > 0 ? _idfa : _idfa_placeholder;
}

/// 检查ios系统设备下对应土巴兔app的info.plist里有没有配置授权idfa访问的相关key
+ (BOOL)checkInfoPlistAuthorizationIDFA {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSUserTrackingUsageDescription"];
}

/// 判断idfa串是否有效
///@note 若idfa为nil或@""或@"00000000-0000-0000-0000-000000000000"则会返回NO，其它值坐返回YES
+ (BOOL)isValidIDFA:(NSString *)idfa {
    if (idfa.length == 0 ||
        [idfa isEqualToString:_idfa_placeholder]) {
        return NO;
    }
    
    return YES;
}

static void(^static_idfaInitOrUpdateBlock)(NSString *idfaStr, BOOL isValidIDFA) = nil;
+ (void)setIdfaInitOrUpdateBlock:(void (^)(NSString *, BOOL))idfaInitOrUpdateBlock {
    static_idfaInitOrUpdateBlock = [idfaInitOrUpdateBlock copy];
}

+ (void(^)(NSString *idfaStr, BOOL isValidIDFA))idfaInitOrUpdateBlock {
    return static_idfaInitOrUpdateBlock;
}

// 此方法内部实际执行会简单异步触发相关回调block
+ (void)asyncExcuteIdfaValueUpdateBlockIfNeed {
    //相关值更新后的回调
    if (_idfa.length > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self idfaInitOrUpdateBlock]) {
                [self idfaInitOrUpdateBlock](_idfa, [self isValidIDFA:_idfa]);
            }
        });
    }
}

@end
