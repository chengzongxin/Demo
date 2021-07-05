//
//  THKTransitionAnimation.m
//  HouseKeeper
//
//  Created by ben.gan on 2020/11/24.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKTransitionAnimation.h"

@interface THKTransitionAnimation () 
///>转场类型
@property (nonatomic, assign) BOOL enter;
///>导航栏
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation THKTransitionAnimation

- (void)enterAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:YES];
}

- (void)backAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:YES];
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.enter) {
        [self enterAnimation:transitionContext];
    } else {
        [self backAnimation:transitionContext];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
//非手势转场交互 for present
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.enter = YES;
    return self;
}

//非手势转场交互 for dismiss
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.enter = NO;
    return self;
}

//手势交互 for dismiss
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.backInteractiveTransition.isPanGestureInteration ? self.backInteractiveTransition:nil;
}

//手势交互 for present
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
   return self.enterInteractiveTransition.isPanGestureInteration ? self.enterInteractiveTransition:nil;
}

#pragma mark - UINavigationControllerDelegate
//执行顺序 先
//非手势转场交互 for push or pop
/*****注释:通过 fromVC 和 toVC 我们可以在此设置需要自定义动画的类 *****/
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    self.enter = (operation == UINavigationControllerOperationPush);
//    self.navigationController = navigationController;
    return self;
}

//手势交互 for push or pop
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
//    self.navigationController = navigationController;
    if (self.enter) {
        return self.enterInteractiveTransition.isPanGestureInteration ? self.enterInteractiveTransition:nil;
    } else{
        return self.backInteractiveTransition.isPanGestureInteration ? self.backInteractiveTransition:nil;
    }
}

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        self.duration = 0.3;
    }
    return self;
}

@end
