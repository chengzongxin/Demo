//
//  UINavigationController+Godeye.m
//  Pods
//
//  Created by jerry.jiang on 2018/12/26.
//

#import "UINavigationController+Godeye.h"
#import "UIViewController+Godeye.h"
#import "GEPageViewProcessor.h"
#import "GESwizzer.h"

@implementation UINavigationController (Godeye)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzInstanceMethod(self, @selector(pushViewController:animated:), @selector(ge_pushViewController:animated:));
        // swizzInstanceMethod(self, @selector(popViewControllerAnimated:), @selector(ge_popViewControllerAnimated:));
    });
}

- (void)ge_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController.geDisableAutoTrack) {
        UIViewController *topViewController = [GEPageViewProcessor defaultProcessor].topViewController;
        viewController.gePageReferUid = topViewController.gePageUid;
        viewController.gePageReferUrl = topViewController.gePageUrl;
    }
    [self ge_pushViewController:viewController animated:animated];
}

/**
- (UIViewController *)ge_popViewControllerAnimated:(BOOL)animated {
    UIViewController *topViewController = [GEPageViewProcessor defaultProcessor].topViewController;
    UIViewController *prevVC = [self ge_popViewControllerAnimated:animated];
    if (!self.topViewController.geDisableAutoTrack) {
        self.topViewController.gePageReferUid = topViewController.gePageUid;
        self.topViewController.gePageReferUrl = topViewController.gePageUrl;
    }
    return prevVC;
}
*/

@end
