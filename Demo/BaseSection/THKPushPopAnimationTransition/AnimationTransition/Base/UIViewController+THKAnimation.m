//
//  UIViewController+THKAnimation.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "UIViewController+THKAnimation.h"
#import "THKInteractiveTransition.h"

@implementation UIViewController (THKAnimation)

TMAssociatedPropertyStrongTypeSetterGetter(THKAnimationManager, pushTransitionAnimation);
TMAssociatedPropertyStrongTypeSetterGetter(THKAnimationManager, presentTransitionAnimation);

- (void)thk_pushViewControler:(UIViewController *)viewController animationManager:(THKAnimationManager *)animationManager {
    if (!viewController || !animationManager) {
        return;
    }
    if (self.navigationController) {
        viewController.pushTransitionAnimation = animationManager;
        [animationManager configNavigationController:self.navigationController toVc:viewController];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)thk_setViewControlers:(NSArray *)viewControllers animationManager:(THKAnimationManager *)animationManager {
    if (!viewControllers || !animationManager) {
        return;
    }
    if (self.navigationController) {
        [animationManager configNavigationController:self.navigationController toVc:[viewControllers lastObject]];
        [self.navigationController setViewControllers:viewControllers animated:YES];
    }
}

- (void)thk_presentViewControler:(UIViewController *)viewController animationManager:(THKAnimationManager *)animationManager {
    if (!viewController || !animationManager) {
        return;
    }
    viewController.transitioningDelegate = animationManager;

    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)(viewController) topViewController].presentTransitionAnimation = animationManager;
    } else {
        viewController.presentTransitionAnimation = animationManager;
    }
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)thk_registerPushInteractiveTransition:(THKInteractiveTransition *)interactiveTransition block:(dispatch_block_t)block {
    interactiveTransition.eventBlock = block;
    [interactiveTransition addGestureToViewController:self];
    
    if (self.pushTransitionAnimation) {
        self.pushTransitionAnimation.pushInteractiveTransition = interactiveTransition;
    }
    if (self.presentTransitionAnimation) {
        self.presentTransitionAnimation.pushInteractiveTransition = interactiveTransition;
    }
}

- (void)thk_registerPopInteractiveTransition:(THKInteractiveTransition *)interactiveTransition block:(dispatch_block_t)block {
    interactiveTransition.eventBlock = block;
    [interactiveTransition addGestureToViewController:self];

    if (self.pushTransitionAnimation) {
        self.pushTransitionAnimation.popInteractiveTransition = interactiveTransition;
    }
    if (self.presentTransitionAnimation) {
        self.presentTransitionAnimation.popInteractiveTransition = interactiveTransition;
    }
}

@end
