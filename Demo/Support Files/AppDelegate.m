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
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[THKNetworkManager sharedManager] setupNetwork];
    [[TRequestParameter sharedParameter] appendDicParameter:@{@"uuid":@"4298F251-E93C-478E-AA05-B46E47F02BEC"}];
    [THKIdentityConfigManager.shareInstane loadConfigWithResultBlock:^{
        // lanch app
    }];
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
