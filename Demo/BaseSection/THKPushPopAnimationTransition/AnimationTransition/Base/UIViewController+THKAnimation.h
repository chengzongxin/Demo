//
//  UIViewController+THKAnimation.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THKAnimationManager.h"
//#import "TMAssociatedPropertyMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (THKAnimation)

TMAssociatedPropertyStrongType(THKAnimationManager, pushTransitionAnimation);
TMAssociatedPropertyStrongType(THKAnimationManager, presentTransitionAnimation);

/**
 push动画

 @param viewController 被push viewController
 @param tsransitionAnimation 动画
 */
- (void)thk_pushViewControler:(UIViewController *)viewController animationManager:(THKAnimationManager *)animationManager;

- (void)thk_setViewControlers:(NSArray *)viewControllers animationManager:(THKAnimationManager *)animationManager;

/**
 present动画

 @param viewController 被present viewController
 @param tsransitionAnimation 动画
 */
- (void)thk_presentViewControler:(UIViewController *)viewController animationManager:(THKAnimationManager *)animationManager;

/**
 注册入场手势

 @param direction 方向
 @param blcok 手势转场触发的点击事件
 */
- (void)thk_registerPushInteractiveTransition:(THKInteractiveTransition *)interactiveTransition block:(dispatch_block_t)block;

/**
 注册返回手势

 @param direction 侧滑方向
 @param blcok 手势转场触发的点击事件
 */
- (void)thk_registerPopInteractiveTransition:(THKInteractiveTransition *)interactiveTransition block:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
