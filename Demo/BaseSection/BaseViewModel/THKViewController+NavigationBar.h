//
//  THKViewController+NavigationBar.h
//  Demo
//
//  Created by Joe.cheng on 2022/5/16.
//

#import "THKViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NavigationBar)

@property (nonatomic, strong) TMUINavigationBar *navBar;

- (void)addNavgationBar;

@end

NS_ASSUME_NONNULL_END
