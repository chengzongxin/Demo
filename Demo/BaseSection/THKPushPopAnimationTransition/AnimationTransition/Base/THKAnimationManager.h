//
//  THKAnimationManager.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THKBaseAnimation.h"
#import "THKInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKAnimationManager : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

///>转场动画的时间 默认为0.25s
@property (nonatomic, assign) NSTimeInterval duration;
///>动画
@property (nonatomic, strong) THKBaseAnimation *animation;
///>入场手势
@property (nonatomic, strong) THKInteractiveTransition *pushInteractiveTransition;
///>退场手势
@property (nonatomic, strong) THKInteractiveTransition *popInteractiveTransition;

/**
 配置导航栏及toVC数据
 */
- (void)configNavigationController:(UINavigationController *)navigationController toVc:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
