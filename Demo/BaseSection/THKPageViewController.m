//
//  THKPageViewController.m
//  THKPageViewController
//
//  Created by 荀青锋 on 2019/11/11.
//

#import "THKPageViewController.h"
#import <objc/runtime.h>

#pragma mark - @protocol

@protocol THKViewControllerDelegate <NSObject>

- (void)didShowViewController:(UIViewController *)controller atIndex:(NSInteger)index;

@end

#pragma mark - Category

@interface UIViewController (PageIndex)

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak  ) id <THKViewControllerDelegate> pageDelegate;

@end

@implementation UIViewController (PageIndex)

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(currentPage_viewDidAppear:) with:@selector(viewDidAppear:)];
    });
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, @selector(index), @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<THKViewControllerDelegate>)pageDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPageDelegate:(id<THKViewControllerDelegate>)pageDelegate {
    objc_setAssociatedObject(self, @selector(pageDelegate), pageDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)currentPage_viewDidAppear:(BOOL)animated {
    [self currentPage_viewDidAppear:animated];
    [self showPage];
}

- (void)showPage {
    if ([self.pageDelegate respondsToSelector:@selector(didShowViewController:atIndex:)]) {
        [self.pageDelegate didShowViewController:self atIndex:self.index];
    }
}

@end

#pragma mark - PageViewController

@interface THKPageViewController () <UIPageViewControllerDataSource, THKViewControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *pageViewControllers;
@property (nonatomic, assign) NSInteger numberOfItem;

@end

@implementation THKPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentIndex = NSNotFound;
    self.pageViewControllers = [NSMutableDictionary dictionary];
    self.dataSource = self;
    if ([self.pageDataSource respondsToSelector:@selector(numberOfItemsInPageViewController:)]) {
        self.numberOfItem = [self.pageDataSource numberOfItemsInPageViewController:self];
    }
}

#pragma mark - Public

// 切换到某个index
//- (void)seekToIndex:(NSInteger)index {
//    [self seekToIndex:index animation:YES];
//}
//
//- (void)seekToIndex:(NSInteger)index animation:(BOOL)animation {
//    if (self.currentIndex == index) {return;}
//
//    if (self.numberOfItem > 0) {
//        // 判断index，防止传入异常数据导致角标越界
//        if (index >= self.numberOfItem) index = self.numberOfItem - 1;
//        if (index < 0) index = 0;
//
//        UIPageViewControllerNavigationDirection direction;
//        if (index > self.currentIndex) {
//            direction = UIPageViewControllerNavigationDirectionForward;
//        } else {
//            direction = UIPageViewControllerNavigationDirectionReverse;
//        }
//
//        UIViewController *viewController = [self viewControllerForIndex:index];
//        if (viewController) {
//            [self setViewControllers:@[viewController] direction:direction animated:animation completion:^(BOOL finished) {
//                _currentIndex = index;
//            }];
//        }
//    }
//}

- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    if (index >= 0 && index < self.numberOfItem) {
        UIViewController *viewController = self.pageViewControllers[@(index)];
        if (!viewController) {
            if ([self.pageDataSource respondsToSelector:@selector(pageViewController:newControllerOfIndex:)]) {
                viewController = [self.pageDataSource pageViewController:self newControllerOfIndex:index];
            }
            if (viewController) {
                viewController.index = index;
                viewController.pageDelegate = self;
                self.pageViewControllers[@(index)] = viewController;
            }
        }
        return viewController;
    }
    return nil;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self viewControllerForIndex:viewController.index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    return [self viewControllerForIndex:viewController.index + 1];
}

#pragma mark - THKViewControllerDelegate

- (void)didShowViewController:(UIViewController *)controller atIndex:(NSInteger)index {
    _currentIndex = index;
    if ([self.pageDelegate respondsToSelector:@selector(pageViewController:didShowViewController:atIndex:)]) {
        [self.pageDelegate pageViewController:self didShowViewController:controller atIndex:index];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
