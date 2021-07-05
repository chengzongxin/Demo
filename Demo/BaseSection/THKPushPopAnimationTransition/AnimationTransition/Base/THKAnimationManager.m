//
//  THKAnimationManager.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKAnimationManager.h"

@interface THKAnimationManager ()

///>转场类型
@property (nonatomic, assign) BOOL isPush;

@property (nonatomic, weak) id<UINavigationControllerDelegate> defaultOldDelegate;
@property(nonatomic, weak) UIViewController *applyTransitionTargetViewController;///< 需要外部赋值，表示push此vc或此vc pop时需执行相关自定义的转场效果，其它vc的push/pop不受影响
@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation THKAnimationManager

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    if (self.isPush) {
        [self.animation pushAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView duration:[self transitionDuration:transitionContext]];
    } else {
        [self.animation popAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView duration:[self transitionDuration:transitionContext]];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
//非手势转场交互 for present
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.isPush = YES;
    return self;
}

//非手势转场交互 for dismiss
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.isPush = NO;
    return self;
}

//手势交互 for dismiss
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.popInteractiveTransition.isPanGestureInteration ? self.popInteractiveTransition:nil;
}

//手势交互 for present
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
   return self.pushInteractiveTransition.isPanGestureInteration ? self.pushInteractiveTransition:nil;
}

#pragma mark - UINavigationControllerDelegate
//执行顺序 先
//非手势转场交互 for push or pop
/*****注释:通过 fromVC 和 toVC 我们可以在此设置需要自定义动画的类 *****/
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if (self.applyTransitionTargetViewController) {
        if (operation == UINavigationControllerOperationPush &&
            [toVC isEqual:self.applyTransitionTargetViewController]) {
            self.isPush = (operation == UINavigationControllerOperationPush);
            return self;
        }else if (operation == UINavigationControllerOperationPop &&
                  [fromVC isEqual:self.applyTransitionTargetViewController]) {
            self.isPush = (operation == UINavigationControllerOperationPush);
            return self;
        }
    }
    return nil;
}

//手势交互 for push or pop
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isEqual:self]) {
        if (self.isPush) {
            return self.pushInteractiveTransition.isPanGestureInteration ? self.pushInteractiveTransition:nil;
        } else{
            return self.popInteractiveTransition.isPanGestureInteration ? self.popInteractiveTransition:nil;
        }
    }
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isEqual:self.applyTransitionTargetViewController] &&
        self.animation) {
        self.navigationController.delegate = self;
    }else if (self.applyTransitionTargetViewController) {
            if([[navigationController viewControllers] indexOfObject:self.applyTransitionTargetViewController] == NSNotFound) {
                self.navigationController.delegate = self.defaultOldDelegate;
            }
    }else {
        self.navigationController.delegate = self.defaultOldDelegate;
    }
}


#pragma mark - Public

- (void)configNavigationController:(UINavigationController *)navigationController toVc:(UIViewController *)vc {
    if (_navigationController) {
        _navigationController.delegate = self.defaultOldDelegate;
    }
    _navigationController = navigationController;
    self.defaultOldDelegate = navigationController.delegate;
    _navigationController.delegate = self;
    
    self.applyTransitionTargetViewController = vc;
}

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        self.duration = 0.25;
    }
    return self;
}

@end
