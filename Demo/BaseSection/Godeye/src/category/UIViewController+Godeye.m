//
//  UIViewController+Godeye.m
//  Godeye
//
//  Created by jerry.jiang on 2018/12/25.
//  Copyright © 2018 jerry.jiang. All rights reserved.
//

#import "UIViewController+Godeye.h"
#import <objc/runtime.h>
#import "GESwizzer.h"
#import "GEPageViewProcessor.h"
#import "UIResponder+Godeye.h"

@implementation UIViewController (Godeye)

#pragma mark - Hook

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzInstanceMethod(self, @selector(viewWillAppear:), @selector(ge_viewWillAppear:));
        swizzInstanceMethod(self, @selector(viewWillDisappear:), @selector(ge_viewWillDisappear:));
        swizzInstanceMethod(self, @selector(presentViewController:animated:completion:), @selector(ge_presentViewController:animated:completion:));
        // swizzInstanceMethod(self, @selector(dismissViewControllerAnimated:completion:), @selector(ge_dismissViewControllerAnimated:completion:));
    });
}

- (void)ge_viewWillAppear:(BOOL)animated {
    [self ge_viewWillAppear:animated];
    if (!self.geDisableAutoTrack) {
        [[GEPageViewProcessor defaultProcessor] addPageShowEvent:self];
    }
}

- (void)ge_viewWillDisappear:(BOOL)animated {
    [self ge_viewWillDisappear:animated];
    if (!self.geDisableAutoTrack) {
        [[GEPageViewProcessor defaultProcessor] addPageHideEvent:self];
    }
}

- (void)ge_presentViewController:(UIViewController *)viewControllerToPresent
                        animated:(BOOL)flag
                      completion:(void (^)(void))completion {
    UIViewController *vc = viewControllerToPresent;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)vc).viewControllers.lastObject;
    }
    if (!vc.geDisableAutoTrack) {
        UIViewController *topViewController = [GEPageViewProcessor defaultProcessor].topViewController;
        vc.gePageReferUid = topViewController.gePageUid;
        vc.gePageReferUrl = topViewController.gePageUrl;
    }
    [self ge_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

/**
- (void)ge_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController *vcToDismiss = nil;
    UIViewController *vcToAppear  = nil;
    UIViewController *topViewController = [GEPageViewProcessor defaultProcessor].topViewController;
    if (self.presentedViewController) {
        vcToAppear = [self ge_topViewController];
        vcToDismiss = topViewController;
    } else if (self.presentingViewController) {
        vcToDismiss = topViewController;
        vcToAppear = [self ge_topViewController];
    }
    if ([vcToDismiss isKindOfClass:[UINavigationController class]]) {
        vcToDismiss = ((UINavigationController *)vcToDismiss).viewControllers.lastObject;
    }
    if (!vcToAppear.geDisableAutoTrack) {
        vcToAppear.gePageReferUid = vcToDismiss.gePageUid;
        vcToAppear.gePageReferUrl = vcToDismiss.gePageUrl;
    }
    [self ge_dismissViewControllerAnimated:flag completion:completion];
}
*/

- (UIViewController *)ge_topViewController {
#if THKNotificationService
    return nil;
#else
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if (![tab isKindOfClass:[UITabBarController class]]) {
        return nil;
    }
    UINavigationController *nav = tab.selectedViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        return nav.viewControllers.lastObject;
    }
    return nav;
#endif
}

#pragma mark - Properties

- (NSUInteger)gePageTag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setGePageTag:(NSUInteger)gePageTag {
    objc_setAssociatedObject(self, @selector(gePageTag), @(gePageTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)gePageUid {
    NSString *className = objc_getAssociatedObject(self, _cmd);
    if (className) {
        return className;
    } else {
        className = NSStringFromClass([self class]);
        if (self.gePageTag > 0) {
            className = [className stringByAppendingFormat:@"#%zd", self.gePageTag];
        }
        return className;
    }
}

- (void)setGePageUid:(NSString *)gePageUid {
    objc_setAssociatedObject(self, @selector(gePageUid), gePageUid, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)gePageUrl {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGePageUrl:(NSString *)gePageUrl {
    objc_setAssociatedObject(self, @selector(gePageUrl), gePageUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)geDisableAutoTrack {
    NSNumber *res = objc_getAssociatedObject(self, _cmd);
    if (!res) {
        NSString *clsName = NSStringFromClass([self class]);
        if ([self isKindOfClass:[UITabBarController class]] ||
            [self isKindOfClass:[UINavigationController class]] ||
            [clsName hasPrefix:@"UI"] ||
            [clsName hasPrefix:@"_"]) {
            res = @1;
        } else {
            res = @0;
        }
        self.geDisableAutoTrack = [res boolValue];
    }
    return [res boolValue];
}

- (void)setGeDisableAutoTrack:(BOOL)geDisableAutoTrack
{
    objc_setAssociatedObject(self, @selector(geDisableAutoTrack), @(geDisableAutoTrack), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)gePageReferUid {
    
    NSString *referUid = objc_getAssociatedObject(self, _cmd);
    if (!referUid) {
        referUid = self.parentViewController.gePageReferUid;
    }
    return referUid;
}

- (void)setGePageReferUid:(NSString *)gePageReferUid
{
    objc_setAssociatedObject(self, @selector(gePageReferUid), gePageReferUid, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (GEPageShowMethod)geShowMethod
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setGeShowMethod:(GEPageShowMethod)geShowMethod
{
    objc_setAssociatedObject(self, @selector(geShowMethod), @(geShowMethod), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)geWidgetReferUid
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGeWidgetReferUid:(NSString *)geWidgetReferUid
{
    objc_setAssociatedObject(self, @selector(geWidgetReferUid), geWidgetReferUid, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)gePageReferUrl
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGePageReferUrl:(NSString *)gePageReferUrl
{
    objc_setAssociatedObject(self, @selector(gePageReferUrl), gePageReferUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isVisible {
    return (self.isViewLoaded && self.view.window);
}

- (NSString *)gePageUUID {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGePageUUID:(NSString *)gePageUUID {
    objc_setAssociatedObject(self, @selector(gePageUUID), gePageUUID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)gePageName {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGePageName:(NSString *)gePageName {
    objc_setAssociatedObject(self, @selector(gePageName), gePageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)gePageLevelPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGePageLevelPath:(NSString *)gePageLevelPath {
    objc_setAssociatedObject(self, @selector(gePageLevelPath), gePageLevelPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)gePageNotDisplay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setGePageNotDisplay:(BOOL)gePageNotDisplay {
    objc_setAssociatedObject(self, @selector(gePageNotDisplay), @(gePageNotDisplay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
