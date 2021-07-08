//
//  GELoginTracker.m
//  Pods
//
//  Created by jerry.jiang on 2019/2/21.
//

#import "GELoginTracker.h"
#import "GEProcessor+GodeyePrivate.h"

@implementation GELoginTracker


+ (void)reportLoginEventWithType:(GELoginType)type properties:(NSDictionary *)properties
{
    NSString *loginMethod = nil;
    switch (type) {
        case GELoginTypePhone:
            loginMethod = @"mobile_auth";
            break;
        case GELoginTypeQQ:
            loginMethod = @"qq_auth";
            break;
        case GELoginTypeWeibo:
            loginMethod = @"sina_auth";
            break;
        case GELoginTypeWechat:
            loginMethod = @"wechat_auth";
            break;
        case GELoginTypeUid:
            loginMethod = @"uid_auth";
            break;
        case GELoginTypeOneClick:
            loginMethod = @"one_click_auth";
            break;
        case GELoginTypeApple:
            loginMethod = @"appleid_auth";
            break;
    }
    
    NSMutableDictionary *prop = [NSMutableDictionary dictionary];
    if (loginMethod) {
        prop[@"login_method"] = loginMethod;
    }
    [prop addEntriesFromDictionary:properties];
    
    [[GEProcessor shareProcessor] reportEvent:@"login" properties:prop];
}

+ (void)reportLogoutEventWithProperties:(NSDictionary *)properties
{
    [[GEProcessor shareProcessor] reportEvent:@"logout" properties:properties];
}

@end
