//
//  THKTransitionAnimation.h
//  HouseKeeper
//  动画父类
//  Created by ben.gan on 2020/11/24.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THKInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKTransitionAnimation : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

///>转场动画的时间 默认为0.3s
@property (nonatomic, assign) NSTimeInterval duration;
///>入场手势
@property (nonatomic, strong) THKInteractiveTransition *enterInteractiveTransition;
///>退场手势
@property (nonatomic, strong) THKInteractiveTransition *backInteractiveTransition;
///>导航栏（动画）
@property (nonatomic, strong, readonly) UINavigationController *navigationController;

/**
 入场动画
 
 @param contextTransition 实现动画
 */
- (void)enterAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;

/**
 退场动画
 
 @param contextTransition 实现动画
 */
- (void)backAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;


@end

NS_ASSUME_NONNULL_END
