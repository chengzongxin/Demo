//
//  THKBaseAnimation.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKBaseAnimation : NSObject

/**
 入场动画
 
 @param contextTransition 实现动画
 */
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView duration:(CGFloat)duration;

/**
 退场动画
 
 @param contextTransition 实现动画
 */
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView duration:(CGFloat)duration;


@end

NS_ASSUME_NONNULL_END
