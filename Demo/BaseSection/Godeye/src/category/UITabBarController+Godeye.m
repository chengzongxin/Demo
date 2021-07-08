//
//  UITabBarController+Godeye.m
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/26.
//

#import "UITabBarController+Godeye.h"
#import "GESwizzer.h"
#import "UIViewController+Godeye.h"

@implementation UITabBarController (Godeye)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzInstanceMethod(self, @selector(setSelectedIndex:), @selector(ge_setSelectedIndex:));
        swizzInstanceMethod(self, @selector(setSelectedViewController:), @selector(ge_setSelectedViewController:));
    });
}

- (void)ge_setSelectedIndex:(NSUInteger)selectedIndex
{
    if (self.selectedIndex == selectedIndex) {
        [self ge_setSelectedIndex:selectedIndex];
        return;
    }
    
    UIViewController *fromViewController = self.selectedViewController;
    if ([fromViewController isKindOfClass:[UINavigationController class]]) {
        fromViewController = ((UINavigationController *)fromViewController).topViewController;
    }
    UIViewController *toViewController = self.viewControllers[selectedIndex];
    if ([toViewController isKindOfClass:[UINavigationController class]]) {
        toViewController = ((UINavigationController *)toViewController).topViewController;
    }
    if (!toViewController.geDisableAutoTrack) {
        toViewController.gePageReferUid = fromViewController.gePageUid;
        toViewController.gePageReferUrl = fromViewController.gePageUrl;
    }
    [self ge_setSelectedIndex:selectedIndex];
}

- (void)ge_setSelectedViewController:(__kindof UIViewController *)selectedViewController
{
    if (self.selectedViewController == selectedViewController) {
        [self ge_setSelectedViewController:selectedViewController];
        return;
    }
    
    UIViewController *fromViewController = self.selectedViewController;
    if ([fromViewController isKindOfClass:[UINavigationController class]]) {
        fromViewController = ((UINavigationController *)fromViewController).topViewController;
    }
    UIViewController *toViewController = selectedViewController;
    if ([toViewController isKindOfClass:[UINavigationController class]]) {
        toViewController = ((UINavigationController *)toViewController).topViewController;
    }
    if (!toViewController.geDisableAutoTrack) {
        toViewController.gePageReferUid = fromViewController.gePageUid;
        toViewController.gePageReferUrl = fromViewController.gePageUrl;
    }
    [self ge_setSelectedViewController:selectedViewController];
}

@end
