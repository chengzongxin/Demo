//
//  TRouterManager.h
//  Example
//
//  Created by 彭军 on 2019/4/29.
//  Copyright © 2019 to8to. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRouterProtocol.h"
NS_ASSUME_NONNULL_BEGIN
/**
 登录结果回调

 @param result <#result description#>
 */
typedef void(^TRouterNeedLoginResultCallback)(BOOL result);

/**
 调起登录回调

 @param router 路由
 @param result <#result description#>
 */
typedef void(^TRouterNeedLoginCallback)(TRouter *router, TRouterNeedLoginResultCallback result);

/**
 当TRouter jumpController为空时，通过这个回调去获取

 @return 跳转导航器 一般为UINavigationController;
 */
typedef UIViewController*(^TRouterJumpControllerDataSource)();

/**
 当 findClassForRouter为空时，通过这个回调去获取升级页面的Router

 @return 取通用升级页面的Router
 */
typedef TRouter*(^TRouterUpgradeRouterDataSource)();

@interface TRouterManager : NSObject

/**
 TRouter配置，如果不设置会取默认配置
 */
@property (nonatomic, strong) id<TRouterConfigProtocol> config;

/**
 调起登录
 */
@property (nonatomic, copy) TRouterNeedLoginCallback doLoginCallback;

/**
 获取跳转导航器回调 一般为UINavigationController
 */
@property (nonatomic, copy) TRouterJumpControllerDataSource jumpControllerDataSource;

/**
获取APP通用升级的页面Router
*/
@property (nonatomic, copy) TRouterUpgradeRouterDataSource upgradeRouterDataSource;

/**
 当前路由的scheme注册
 e.g: to8to
 */
@property (nonatomic, readonly) NSString *scheme;
/**
 当前路由的host注册
 e.g: tbtrouter
 */
@property (nonatomic, readonly) NSArray *hosts;

/**
 TRouterManager实例

 @return <#return value description#>
 */
+ (instancetype)sharedManager;

/**
 注册路由scheme

 @param scheme <#scheme description#>
 */
- (void)registerScheme:(NSString *)scheme;
/**
 注册路由host
 
 @param host host
 */
- (void)registerHost:(NSString *)host;
/**
 *  执行路由跳转
 *
 *  @param router 路由参数model
 *  @return BOOL 是否成功跳转，返回NO代表未跳转或先跳到了其他页面，等待用户操作后才可以跳转到指定页面
 */
- (BOOL)performRouter:(TRouter *)router;

/**
 根据跳转的类型创建对应的页面

 @param router 路由参数
 @return 返回对应路由控制
 */
- (id)createTargetForRouter:(TRouter *)router;

/**
 判断该路由是否支持跳转（当前版本是否实现了该路由协议）
 判断规则：1.必须符合注册Scheme、Host规则 && 2.当前项目中有实现该路由协议
 
 @param routerUrl <#routerUrl description#>
 @return <#return value description#>
 */
- (BOOL)canRouter:(id)routerUrl;
@end

NS_ASSUME_NONNULL_END
