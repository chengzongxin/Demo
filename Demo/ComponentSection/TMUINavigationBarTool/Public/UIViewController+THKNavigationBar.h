//
//  UIViewController+THKNavigationBar.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2022/6/13.
//  Copyright © 2022 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TMUINavigationBar.h>
#import "THKNavigationTitleProtocol.h"
#import "THKNavigationConst.h"


NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (THKNavigationBar)<TMUINavigationBarProtocol,THKNavigationTitleProtocol>

#pragma mark - 自定义导航栏，访问时会懒加载创建
@property (nonatomic, strong, readonly) TMUINavigationBar *thk_navBar;

- (void)thk_layoutNavgationBar;

- (NSString *)thk_NavBarTitle;

@end

NS_ASSUME_NONNULL_END
