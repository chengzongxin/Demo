//
//  GELoginTracker.h
//  Pods
//
//  Created by jerry.jiang on 2019/2/21.
//

#import "GEProcessor.h"

typedef NS_ENUM(NSInteger, GELoginType) {
    GELoginTypePhone,// 手机号码登录
    GELoginTypeQQ,// QQ授权登录
    GELoginTypeWechat,// 微信授权登录
    GELoginTypeWeibo,// 微博授权登录
    GELoginTypeUid,// 用户id登录
    GELoginTypeOneClick,// 一键登录
    GELoginTypeApple,// appleid登录
};

@interface GELoginTracker : GEProcessor

+ (void)reportLoginEventWithType:(GELoginType)type properties:(NSDictionary *)properties;

+ (void)reportLogoutEventWithProperties:(NSDictionary *)properties;

@end

