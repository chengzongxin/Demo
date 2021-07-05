//
//  THKPushPopTransitionManager.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/7.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKPushPopTransitionManager.h"
#import "THKPushPopTransitionManager+Private.h"

const NSTimeInterval THKPushPopTransitionDefaultDuration = 0.25;

@interface THKPushPopTransitionManager()
/**
 记录修改之前的对象，当相关vc执行push新vc或pop到上层后，内部会将相关delegate还原为此旧值
 @note 当执行此动画效果对应的vc的pop后，在pop结束的回调里，此类内部会将相关delegate还原到上级页push之前的旧值
 */
@property (nonatomic, weak)id<UINavigationControllerDelegate> defaultOldDelegate;

@property (nonatomic, assign)UINavigationControllerOperation currentOperation;///< push或pop的相关回调里需要动态调整修改此值为对应操作行为值

@property(nonatomic, weak)UIViewController *applyTransitionTargetViewController;///< 需要外部赋值，表示push此vc或此vc pop时需执行相关自定义的转场效果，其它vc的push/pop不受影响

@end

@implementation THKPushPopTransitionManager

- (void)setNavigationController:(UINavigationController *)navigationController {
    if (_navigationController) {
        _navigationController.delegate = self.defaultOldDelegate;
    }
    _navigationController = navigationController;
    self.defaultOldDelegate = navigationController.delegate;
    _navigationController.delegate = self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration > 0 ? self.duration : THKPushPopTransitionDefaultDuration;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.currentOperation == UINavigationControllerOperationPush) {
        [self.pushPopTransition pushAnimateTransition:transitionContext duration:[self transitionDuration:transitionContext]];
    }else {
        [self.pushPopTransition popAnimateTransition:transitionContext duration:[self transitionDuration:transitionContext]];
    }
}

- (void)animationEnded:(BOOL)transitionCompleted {
    if (self.currentOperation == UINavigationControllerOperationPush) {
        [self.pushPopTransition pushAnimationEnded:transitionCompleted];
    }else {
        [self.pushPopTransition popAnimationEnded:transitionCompleted];
    }    
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (self.applyTransitionTargetViewController) {
        if (operation == UINavigationControllerOperationPush &&
            [toVC isEqual:self.applyTransitionTargetViewController]) {
            self.currentOperation = operation;
            return self;
        }else if (operation == UINavigationControllerOperationPop &&
                  [fromVC isEqual:self.applyTransitionTargetViewController]) {
            self.currentOperation = operation;
            return self;
        }
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if ([animationController isEqual:self]) {
        if (self.currentOperation == UINavigationControllerOperationPop) {
            //pop操作时返回跟随效果委托对象
            return self.popGesturePercentDrivenInteractiveTransition;
        }
    }
    
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (viewController.hidesBottomBarWhenPushed) {
//        if (navigationController.viewControllers.count == 2 &&
//            !navigationController.tabBarController.tabBar.isHidden) {
//            //从首页vc push到 二级子vc，处理一次隐藏即可| 这里有可能是首页->二级子vc，也有可能是三级子vc返回到二级子vc，所以加多一个tabbar是否隐藏的判断
//            [self hideTabBarIfNeed:YES animated:animated tabController:navigationController.tabBarController];
//        }
//    }else {
//        //从二级子vc pop到 首页，处理一次显示即可
//        if (navigationController.viewControllers.count == 1) {
//            [self hideTabBarIfNeed:NO animated:animated tabController:navigationController.tabBarController];
//        }
//    }
}

- (void)hideTabBarIfNeed:(BOOL)hide animated:(BOOL)animate tabController:(UITabBarController *)tabController {
    UITabBar *tabBar = tabController.tabBar;
    CGRect toRect = tabBar.frame;
    //强制以动画形式修改frame，系统的hidesBottomBarWhenPushed为YES时，会默认尝试对tabbar进行左右方向的push/pop动画，这里动画修改frame后，会使默认的push/pop动画效果失效
    if (hide) {
        if (toRect.origin.y < tabController.view.bounds.size.height) {
            toRect.origin.y = tabController.view.bounds.size.height;
            toRect.origin.x = 0;
            if (animate) {
                [UIView animateWithDuration:[self duration] animations:^{
                    tabBar.frame = toRect;
                } completion:^(BOOL finished) {
                    
                }];
            }else {
                tabBar.frame = toRect;
            }
        }
    }else {
        if (toRect.origin.y >= tabController.view.bounds.size.height ||
            toRect.origin.x < 0) {
            toRect.origin.y = tabController.view.bounds.size.height - toRect.size.height;
            toRect.origin.x = 0;
            if (animate) {
                [UIView animateWithDuration:[self duration] animations:^{
                    tabBar.frame = toRect;
                } completion:^(BOOL finished) {
                    
                }];
            }else {
                tabBar.frame = toRect;
            }
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isEqual:self.applyTransitionTargetViewController] &&
        self.pushPopTransition) {
        self.navigationController.delegate = self;
    }else if (self.applyTransitionTargetViewController) {
            if([[navigationController viewControllers] indexOfObject:self.applyTransitionTargetViewController] == NSNotFound) {
                self.navigationController.delegate = self.defaultOldDelegate;
            }
    }else {
        self.navigationController.delegate = self.defaultOldDelegate;
    }
}

@end


@implementation UIViewController(THKPushPopTransitionManager)

- (void)setPushPopTransitionManager:(THKPushPopTransitionManager *)pushPopTransitionManager {
    pushPopTransitionManager.applyTransitionTargetViewController = self;
    _tmui_setAssociatedStrongObj(self, @selector(pushPopTransitionManager), pushPopTransitionManager);
}

- (THKPushPopTransitionManager *)pushPopTransitionManager {
    return _tmui_associatedStrongObj(self, @selector(pushPopTransitionManager));
}

@end
