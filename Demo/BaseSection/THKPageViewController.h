//
//  THKPageViewController.h
//  THKPageViewController
//
//  Created by 荀青锋 on 2019/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class THKPageViewController;

@protocol THKPageViewControllerDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInPageViewController:(THKPageViewController *)pageViewController;

- (UIViewController *)pageViewController:(THKPageViewController *)pageViewController
                    newControllerOfIndex:(NSInteger)index;

@end

@protocol THKPageViewControllerDelegate <NSObject>

@optional
- (void)pageViewController:(THKPageViewController *)pageViewController
     didShowViewController:(UIViewController *)controller
                   atIndex:(NSInteger)index;

@end

@interface THKPageViewController : UIPageViewController

@property (nonatomic, weak) id <THKPageViewControllerDelegate> pageDelegate;
@property (nonatomic, weak) id <THKPageViewControllerDataSource> pageDataSource;

// 当前页面
@property (nonatomic, assign, readonly) NSInteger currentIndex;

// 跳转到指定页面
- (void)seekToIndex:(NSInteger)index;
- (void)seekToIndex:(NSInteger)index animation:(BOOL)animation;

// 获取对应Index的VC
- (UIViewController *)viewControllerForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
