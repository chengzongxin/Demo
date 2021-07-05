//
//  TRouter.h
//  Example
//
//  Created by 彭军 on 2019/4/29.
//  Copyright © 2019 to8to. All rights reserved.
//  路由信息基类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NSString * TRouterPath;

extern TRouterPath  const TRouterPage_WebView; //http&https默认转成该routerName,参数key:url

@interface TRouter : NSObject
/**
 路由页面名称
 */
@property (nonatomic,strong) TRouterPath routeName;

/**
 路由目的页参数,接口配置的路由协议从query取出存到param
 */
@property (nonatomic,strong) NSDictionary *param;

/**
 通过runtime自动设值到对应VC的属性上；（需要key名与目的VC的属性名、类型一致）
 */
@property (nonatomic,strong) NSDictionary *runtimeParam;

/**
 导航器 一般为UINavigationController;
 */
@property (nonatomic,weak) UIViewController *jumpController;

/**
 是否需要登录
 */
@property (nonatomic,assign) BOOL needlogin;

/**
 路由协议
 */
@property (nonatomic, strong) NSString *routerUrl;

/**
 获取路由目的对象
*/
@property (nonatomic, strong, readonly) id build;
/**
 通过路由path构建一个router
 
 @param routeName 路由名称
 @return router
 */
+ (instancetype)routerWithName:(TRouterPath)routeName;

/**
 通过参数构建一个router

 @param routeName 路由名称
 @param param 路由参数，需手动赋值
 @param jumpController 跳转的控制器
 @return router
 */
+ (instancetype)routerWithName:(TRouterPath)routeName param:(NSDictionary * _Nullable)param jumpController:(UIViewController* _Nullable)jumpController;


/**
 通过参数构建一个router
 
 @param routeName 路由名称
 @param runtimeParam 页面对应参数，自动赋值
 @param jumpController 跳转的控制器
 @return router
 */
+ (instancetype)routerWithName:(TRouterPath)routeName runtimeParam:(NSDictionary *)runtimeParam jumpController:(UIViewController* _Nullable)jumpController;

/**
 通过一个路由协议构建一个router
 @param routerUrl 路由协议
 @return router
*/
+ (instancetype)routerFromUrl:(NSString *)routerUrl;

/**
 通过一个路由协议构建一个router

 @param routerUrl 路由协议
 @param jumpController 跳转的控制器
 @return router
 */
+ (instancetype)routerFromUrl:(NSString *)routerUrl jumpController:(UIViewController* _Nullable)jumpController;




/**
 执行路由跳转

 @return 跳转成功或者失败
 */
-(BOOL)perform;

/**
 根据router的runtimeParam参数自动填充object对象的属性的值,runtimeParam里面的key必须为字符串类型
 *
 @param object 要填充的对象
 */
- (void)setValuesForObject:(id)object;

/**
 路由名称匹配

 @param routerName 路由名
 @return YES:NO
 */
- (BOOL)routerMatch:(TRouterPath)routerName;

/**
 判断传入url是否符合路由协议规则
 判断规则：1.必须符合注册Scheme、Host规则

 @param routerUrl NSString/NSURL
 @return YES:NO
 */
+ (BOOL)isRouterUrl:(id)routerUrl;

/**
 判断该路由是否支持跳转（当前版本是否实现了该路由协议）
 判断规则：1.必须符合注册Scheme、Host规则 && 2.当前项目中有实现该路由协议
 @param routerUrl NSString/NSURL
 @return YES:NO
 */
+ (BOOL)canRouter:(id)routerUrl;
@end

NS_ASSUME_NONNULL_END
