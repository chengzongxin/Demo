//
//  UIScrollView+TScroll.h
//  HouseKeeper
//  滑动返回冲突事件
//  Created by ben.gan on 2018/8/15.
//  Copyright © 2018年 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (TScroll)

@property (nonatomic, assign) BOOL allowScrolling;

@property (nonatomic, strong) NSNumber *cannotSetAlwaysBoundcesToYES;

@end
