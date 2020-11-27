//
//  ViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import <UIKit/UIKit.h>
@class THKPageContentViewController;

@protocol THKPageContentViewControllerDataSource <NSObject>

@required
- (NSArray <UIViewController *> *)childViewControllers;

@end

@protocol THKPageContentViewControllerDelegate <NSObject>

- (void)pageContentViewController:(THKPageContentViewController *)pageVC from:(NSInteger)fromVC to:(NSInteger)toVC;


@end

@interface THKPageContentViewController : UIViewController <THKPageContentViewControllerDataSource,THKPageContentViewControllerDelegate>

@property (nonatomic, weak) id<THKPageContentViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<THKPageContentViewControllerDelegate> delegate;

@end

