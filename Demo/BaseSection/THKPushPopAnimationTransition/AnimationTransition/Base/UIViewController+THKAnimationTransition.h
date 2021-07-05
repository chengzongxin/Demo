//
//  UIViewController+THKAnimationTransition.h
//  HouseKeeper
//
//  Created by ben.gan on 2020/11/24.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THKTransitionAnimation.h"
//#import "TMAssociatedPropertyMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (THKAnimationTransition)

//TMAssociatedPropertyWeakType(THKTransitionAnimation, pushTransitionAnimation);
//TMAssociatedPropertyWeakType(THKTransitionAnimation, presentTransitionAnimation);
TMAssociatedPropertyStrongType(THKTransitionAnimation, pushTransitionAnimation);
TMAssociatedPropertyStrongType(THKTransitionAnimation, presentTransitionAnimation);

/**
 push动画

 @param viewController 被push viewController
 @param tsransitionAnimation 动画
 */
- (void)thk_pushViewControler:(UIViewController *)viewController animation:(THKTransitionAnimation*)transitionAnimation;

/**
 present动画

 @param viewController 被present viewController
 @param tsransitionAnimation 动画
 */
- (void)thk_presentViewControler:(UIViewController *)viewController animation:(THKTransitionAnimation*)transitionAnimation;

@end

NS_ASSUME_NONNULL_END
