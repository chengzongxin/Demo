//
//  UIViewController+PopGestureOfPercentDrivenInteractiveTransition.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/9.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 此类别为辅助THKPushPopTransitionManager使用，但需要在对应的具体的vc里在viewDidLoad中调用相关接口来增加返回手势支持
@interface UIViewController (PopGestureOfPercentDrivenInteractiveTransition)

/// 增加一个pan往上或下方向滑动的pan手势来处理pop转场跟随效果
- (void)addPopGestureOfPercentDrivenInteractiveTransition;

@end

NS_ASSUME_NONNULL_END
