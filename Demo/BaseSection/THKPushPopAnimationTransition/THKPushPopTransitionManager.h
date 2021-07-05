//
//  THKPushPopTransitionManager.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/7.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "THKPushPopAsLocationToListTransition.h"
#import "THKPushPopAsLocationToListSimulationTransition.h"
#import "THKPushPopAsLocationToListForVideoDetailTransition.h" //常规列表到视频页的动效用这个
#import "UIViewController+PopGestureOfPercentDrivenInteractiveTransition.h"
//#import "THKPushPopVideoDetailTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKPushPopTransitionManager : NSObject<UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign)NSTimeInterval duration;///< 可设置转场动画的过渡时间，若不设置则采取默认0.25s

@property (nonatomic, weak)UINavigationController *navigationController;///< 管理push、pop相关动画代理，需要外部赋值

/// 负责处理具体转场效果的类对象
@property(nonatomic, strong)__kindof THKPushPopBaseTransition *pushPopTransition;

/// 若有相关返回手势跟随效果，则每次手势识别前都判断当前相关的pop手势是否应该执行相关pop逻辑，若不实现则默认响应手势
@property (nonatomic, copy, nullable)BOOL (^enablePopGestureOfPercentDrivenInteractiveTransitionBlock)(void);

@end

@interface UIViewController(THKPushPopTransitionManager)

/// 某个vc被push出来或pop回上级页需要相关自定义交互动画时，可指定相关转场动效对象
///A -Push--> B/ B -PopTo--> A, 将B.pushPopTransitionManager赋值合适值即可
@property (nonatomic, strong, nullable)THKPushPopTransitionManager *pushPopTransitionManager;

@end

NS_ASSUME_NONNULL_END
