//
//  GEPageViewProcessor.m
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import "GEPageViewProcessor.h"
#import <objc/runtime.h>
#import "UIResponder+Godeye.h"
#import "UIViewController+Godeye.h"
#import "GEDispatcher.h"
#import "GEProcessor+GodeyePrivate.h"
#import "UIView+Godeye.h"
#import "Godeye.h"
static const char* GEPageViewShowTimeKey = "GEPageViewShowTimeKey";

@implementation GEPageViewProcessor {
    NSHashTable *_hashTable;
}

+ (instancetype)defaultProcessor
{
    static GEPageViewProcessor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GEPageViewProcessor alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

- (void)appResignActive
{
    for (UIViewController *vc in _hashTable) {
        [self reportPageCicleEvent:vc];
    }
}

- (void)appBecomeActive
{
    for (UIViewController *vc in _hashTable) {
        objc_setAssociatedObject(vc, GEPageViewShowTimeKey, @(CURRENT_TIMESTAMP), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)addPageShowEvent:(UIViewController *)vc
{
    if (!vc) {
        return;
    }
    objc_setAssociatedObject(vc, GEPageViewShowTimeKey, @(CURRENT_TIMESTAMP), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [_hashTable addObject:vc];
}

- (void)addPageHideEvent:(UIViewController *)vc
{
    if (!vc) {
        return;
    }
    [self reportPageCicleEvent:vc];
    [_hashTable removeObject:vc];
}

- (void)reportPageCicleEvent:(UIViewController *)vc
{
    NSTimeInterval showTime = [objc_getAssociatedObject(vc, GEPageViewShowTimeKey) doubleValue];
    NSTimeInterval hideTime = CURRENT_TIMESTAMP;
    
    if (showTime == 0) {
        GELog(@"Godeye Warning: ViewController %@ showtime not found, looking for parent viewController...", vc.gePageUid);
        UIViewController *parentVc = vc;
        do {
            parentVc = parentVc.parentViewController;
            if (parentVc) {
                showTime = [objc_getAssociatedObject(parentVc, GEPageViewShowTimeKey) doubleValue];
            }
        } while (showTime == 0 && parentVc != nil);
    }
    if (showTime == 0) {
        GELog(@"Godeye Warning: ViewController %@ get showtime failed, whitch should be a mistake", vc.gePageUid);
    }
#if DEBUG
    if (showTime == 0) {
        NSString *className = NSStringFromClass([vc class]);
        NSString *message = [NSString stringWithFormat:@"%@：showTime can not be zero", className];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
        [alert addAction:confirmAction];
        [self.topViewController presentViewController:alert animated:YES completion:nil];
    }
#endif
    NSString *pageReferUid = vc.gePageReferUid;
    
    if (!pageReferUid) {
        UIViewController *parentVc = vc;
        do {
            parentVc = parentVc.parentViewController;
            if (parentVc) {
                pageReferUid = parentVc.gePageReferUid;
            }
        } while (!pageReferUid && parentVc);
    }
    
    NSMutableDictionary *properties = [@{@"page_uid":vc.gePageUid,
                                         @"page_url":vc.gePageUrl ?: @"",
                                         @"page_class":NSStringFromClass([vc class]),
                                         @"page_show_method":vc.geShowMethod == GEPageShowMethodClick ? @"click":@"scroll",
                                         @"page_refer_uid":pageReferUid ?: @"",
                                         @"page_refer_url":vc.gePageReferUrl ?: @"",
                                         @"page_refer_widget_uid":vc.geWidgetReferUid ?: @"",
                                         @"page_show_time":@((long)(showTime * 1000)),
                                         @"page_hide_time":@((long)(hideTime * 1000)),
                                         } mutableCopy];
    if (vc.gePageName && vc.gePageName.length > 0) {
        [properties setObject:vc.gePageName forKey:@"page_name"];
    }
    [properties setObject:@(vc.gePageNotDisplay?0:1) forKey:@"is_show"];
    if (vc.gePageLevelPath && vc.gePageLevelPath.length > 0) {
        [properties setObject:vc.gePageLevelPath forKey:@"bizlevel"];
    }
    
    [properties addEntriesFromDictionary:vc.geResource];
    [self reportEvent:@"appPageCycle" properties:properties];
}

- (void)addViewPageDetailEvent:(UIViewController *)vc
{
    NSDictionary *resource = vc.geResource;
    NSMutableDictionary *property = [@{@"page_uid":vc.gePageUid,
                                       @"page_class":NSStringFromClass([vc class]),
                                       @"page_show_method":vc.geShowMethod == GEPageShowMethodClick ? @"click":@"scroll",
                                       @"page_refer_uid":vc.gePageReferUid ?: @"",
                                       @"page_refer_widget_uid":vc.geWidgetReferUid ?: @"",
                                       } mutableCopy];
    [property addEntriesFromDictionary:resource];
    [self reportEvent:@"viewPageDetail" properties:property];
}

- (UIViewController *)topViewController {
#if THKNotificationService
    return nil;
#else
    UIWindow *firstWindow = [UIApplication sharedApplication].windows.firstObject;
    UIViewController *rootViewController = firstWindow.rootViewController;
    UIViewController *resultVC = [self ge_topViewController:rootViewController];
    
    while (resultVC.presentedViewController) {
        resultVC = [self ge_topViewController:resultVC.presentedViewController];
    }
    
    BOOL isHaveDisplayedVC = YES;
    while (resultVC.childViewControllers && resultVC.childViewControllers.count > 0 && isHaveDisplayedVC) {
        UIViewController *displayedVC = [self ge_displayedChildViewController:resultVC];
        if (resultVC == displayedVC) {
            isHaveDisplayedVC = NO;
        } else {
            resultVC = displayedVC;
        }
    }
    
    return resultVC;
#endif
}

- (UIViewController *)ge_displayedChildViewController:(UIViewController *)viewController {
    for (UIViewController *childVC in viewController.childViewControllers) {
        if (childVC.isVisible && childVC.view.isDisplayedInScreen) {
            return childVC;
        }
    }
    return viewController;
}

- (UIViewController *)ge_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self ge_topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self ge_topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}

@end
