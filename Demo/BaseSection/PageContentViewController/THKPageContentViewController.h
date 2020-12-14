//
//  ViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import <UIKit/UIKit.h>
@class THKPageContentViewController;
#import "THKPageBGScrollView.h"
#import "THKSegmentControl.h"
#import "THKViewController.h"

@protocol THKPageContentViewControllerDataSource <NSObject>

@required
- (NSArray <UIViewController *> *)childViewControllers;

- (NSArray <NSString *> *)titlesForChildViewControllers;

@optional
- (CGFloat)heightForHeader;

- (UIView *)viewForHeader;

- (void)segmentControlConfigBlock:(void (^)(THKSegmentControl *control))configBlock;

@end

@protocol THKPageContentViewControllerDelegate <NSObject>

- (void)pageContentViewControllerDidScrolFrom:(NSInteger)fromVC to:(NSInteger)toVC;

- (void)pageContentViewControllerDidScroll:(UIScrollView *)scrollView;

@end

@interface THKPageContentViewController : THKViewController <THKPageContentViewControllerDataSource,THKPageContentViewControllerDelegate>

@property (nonatomic, weak) id<THKPageContentViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<THKPageContentViewControllerDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger currentIndex;



// component
@property (nonatomic, strong, readonly) THKPageBGScrollView *contentView;
@property (nonatomic, strong, readonly) THKSegmentControl *slideBar;
@property (nonatomic, strong, readonly) UIScrollView *contentScrollView;

// 刷新数据
- (void)reloadData;

- (void)scrollTo:(UIViewController *)vc;

@end

