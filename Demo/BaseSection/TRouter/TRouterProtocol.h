//
//  TRouterProtocol.h
//  Example
//
//  Created by 彭军 on 2019/4/29.
//  Copyright © 2019 to8to. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TRouter.h"
#import "NSObject+TRouter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TRouterProtocol <NSObject>

/**
 判断当前项目内能否处理接收该router

 @param router 路由信息
 @return YES/NO:是否能处理
 */
+ (BOOL)canHandleRouter:(TRouter*)router;

@optional
/**
 根据路由信息找到对应的对象并创建

 @param router 路由信息
 @return 创建的视图控制器对象
 */
+ (id)createVCWithRouter:(TRouter*)router;

/**
 *  创建视图控制器之后，对其进行的处理，PushRouter的默认处理为push跳转,可以不实现这个方法（如果实现的话是在push之前做处理）,CustomRouter的需要实现这个方法
 *
 *  @param router 跳转的参数
 *  @param handler 处理router的对象
 */
+ (void)handleRouter:(TRouter *)router withHandler:(id)handler;

/**
 能否退回到某个页面(一般使用在导航栈存在相同控制器/相同业务页面时，再跳转该控制器页面则直接回退到该控制器)

 @param vc 从哪个页面回
 @param router 路由信息
 @return YES/NO:是否能退回
 */
- (BOOL)canPopFromVC:(UIViewController *)vc withRouter:(TRouter*)router;

@end


@protocol TRouterConfigProtocol <NSObject>
/**
 *  根据路由名称获取子类的类别,子类可以重写该方法以获得固定的类别
 *
 *  @param routeName 路由名称
 *
 *  @return 子类类别
 */
- (Class)routeSubClassForRouteName:(TRouterPath)routeName;

/**
 *  router对应的页面是否需要先登录才能访问
 *
 *  @return 是否需要登录
 */
- (BOOL)isNeedLogin:(TRouter*)router;
@end


NS_ASSUME_NONNULL_END
