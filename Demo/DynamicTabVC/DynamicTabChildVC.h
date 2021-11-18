//
//  DynamicTabChildVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/17.
//

#import <UIKit/UIKit.h>
#import "THKViewController.h"
#import "YNPageViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface DynamicTabChildVC : THKViewController <TRouterProtocol,THKTabBarRepeatSelectProtocol,YNPageViewControllerDataSource>

@end

NS_ASSUME_NONNULL_END
