//
//  ViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import <UIKit/UIKit.h>
@class THKPageContentViewController;
@class THKSegmentControl;

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

@interface THKPageContentViewController : UIViewController <THKPageContentViewControllerDataSource,THKPageContentViewControllerDelegate>

@property (nonatomic, weak) id<THKPageContentViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<THKPageContentViewControllerDelegate> delegate;

@end

