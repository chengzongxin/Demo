//
//  TRouterManager+Config.m
//  HouseKeeper
//
//  Created by 彭军 on 2020/9/14.
//  Copyright © 2020 binxun. All rights reserved.
//
#import "TRouterManager+Config.h"
#import "THKRouterConfig.h"
//#import "THKHalfPresentLoginVC.h"
#import "AppDelegate.h"

@implementation TRouterManager (Config)

/// 配置土巴兔项目路由环境参数
-(void)configEnvironment{
    //注册路由协议头
    [[TRouterManager sharedManager] registerScheme:TRouter_Scheme];
    //注册路由host
    [[TRouterManager sharedManager] registerHost:TRouter_Host];
    //注册路由build host
    [[TRouterManager sharedManager] registerHost:TRouter_Build_Host];
    [TRouterManager sharedManager].config = [[THKRouterConfig alloc] init];
//    [TRouterManager sharedManager].jumpControllerDataSource = ^UIViewController *{
//        return [[AppDelegate sharedAppDelegate] currentNavController];
//    };
    //配置升级页面
//    [TRouterManager sharedManager].upgradeRouterDataSource = ^TRouter *{
//        //通用的升级页面的router
//        NSDictionary *param = @{@"url" : k_AppUpgradeUrl};
//        TRouter *router = [TRouter routerWithName:TRouterPage_WebView param:param jumpController:nil];
//        return router;
//    };

//    [TRouterManager sharedManager].doLoginCallback = ^(TRouter * _Nonnull router, TRouterNeedLoginResultCallback  _Nonnull result) {
//        if ([kCurrentUser isLoginStatus]) {
//            if (result) {
//                result(YES);
//            }
//            return;
//        }
//        [THKHalfPresentLoginVC judgeLoginStateWithLoginedHandler:^(id loginResult) {
//            if (result) {
//                result(YES);
//            }
//        } failHandler:nil];
//    };
}


@end
