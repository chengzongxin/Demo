//
//  UIViewController+THKAnimationTransition.m
//  HouseKeeper
//
//  Created by ben.gan on 2020/11/24.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "UIViewController+THKAnimationTransition.h"

@implementation UIViewController (THKAnimationTransition)

//TMAssociatedPropertyWeakTypeSetterGetter(THKTransitionAnimation, pushTransitionAnimation);
//TMAssociatedPropertyWeakTypeSetterGetter(THKTransitionAnimation, presentTransitionAnimation);

TMAssociatedPropertyStrongTypeSetterGetter(THKTransitionAnimation, pushTransitionAnimation);
TMAssociatedPropertyStrongTypeSetterGetter(THKTransitionAnimation, presentTransitionAnimation);

- (void)thk_pushViewControler:(UIViewController *)viewController animation:(THKTransitionAnimation*)transitionAnimation {
    if (!viewController || !transitionAnimation) {
        return;
    }
    if (self.navigationController) {
        self.navigationController.delegate = transitionAnimation;
        viewController.pushTransitionAnimation = transitionAnimation;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)thk_presentViewControler:(UIViewController *)viewController animation:(THKTransitionAnimation*)transitionAnimation {
    if (!viewController || !transitionAnimation) {
        return;
    }
    viewController.transitioningDelegate = transitionAnimation;

    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        NSLog(@"%@", [(UINavigationController *)(viewController) topViewController]);
        
        [(UINavigationController *)(viewController) topViewController].presentTransitionAnimation = transitionAnimation;
    } else {
        viewController.presentTransitionAnimation = transitionAnimation;
    }
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
