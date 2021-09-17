//
//  AppDelegate.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "AppDelegate.h"
#import "THKNetworkManager.h"
#import "TRequestParameter.h"
#import "THKIdentityConfigManager.h"
#import "TUUIDGenerator.h"
#import "GEEnvironmentParameter.h"
#import <THKOSSManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    TUUIDGenerator.accessGroup = @"SM5GN8GTPY.com.czx";
    [TRequestParameter sharedParameter].version = @"2.5";
    [GEEnvironmentParameter defaultParameter].user_city = @"深圳";
    [GEEnvironmentParameter defaultParameter].app_name = @"to8to_ios";
    [[TRequestParameter sharedParameter] appendDicParameter:@{@"uuid":[TUUIDGenerator getUUID]}];
    [[THKNetworkManager sharedManager] setupNetwork];
    [[TRequestParameter sharedParameter] appendDicParameter:@{@"uuid":@"4298F251-E93C-478E-AA05-B46E47F02BEC"}];
    // 域名映射
    [THKIdentityConfigManager.shareInstane loadConfigWithResultBlock:^{
        // lanch app
    }];
    
    
    THKOSSManager.sharedInstance.environmentType = OSSManagerEnvironmentType_Test;
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
