//
//  THKBaseAnimation.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKBaseAnimation.h"

@implementation THKBaseAnimation

/**
 入场动画
 
 @param contextTransition 实现动画
 */
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView duration:(CGFloat)duration {
    
}

/**
 退场动画
 
 @param contextTransition 实现动画
 */
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView duration:(CGFloat)duration {
    
}

@end
