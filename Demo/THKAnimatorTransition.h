//
//  THKTransitionAnimator.h
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import "THKInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKAnimatorTransition : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,CAAnimationDelegate>

@property (nonatomic, strong) THKInteractiveTransition *interactiveTransition;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGRect imgFrame;

@end

NS_ASSUME_NONNULL_END
