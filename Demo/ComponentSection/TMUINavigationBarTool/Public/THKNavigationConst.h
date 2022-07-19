//
//  THKNavigationConst.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2022/6/7.
//  Copyright © 2022 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class THKDynamicTabsPageVC;
//#import "THKDynamicTabsPageVC.h"

#define THKNavBarInTabVC ([self.parentViewController isKindOfClass:NSClassFromString(@"THKDynamicTabsPageVC")])
//#define THKNavBarInTabVC ([self.parentViewController isKindOfClass:THKDynamicTabsPageVC.class])
#define THKNavBarHeight (THKNavBarInTabVC?0:tmui_navigationBarHeight())
#define THKNavBarInsets UIEdgeInsetsMake(THKNavBarHeight, 0, 0, 0)
