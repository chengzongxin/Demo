//
//  TMCardComponentScrollAdsIndicatorView.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/10/30.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN
/**
 滚动的进度指示器或理解为类似pageControl的页面指示器均可
 @note 初始化后会有相关底色及圆角的默认配置值
 @note 外部不要修改子视图的frame
 @note 默认圆角半径1.5| 通常高度给3
 */
@interface TMCardComponentScrollAdsIndicatorView : THKView

@property (nonatomic, strong, readonly) UIView *indicatorView;///< 指示器标记颜色的视图，外部可直接修改其颜色| 外部不要修改其frame

@property (nonatomic, assign)CGFloat indicatorWidth;///< 指示器标记颜色视图的宽度，默认为15

- (void)updateIndicatorProgress:(CGFloat)progress animate:(BOOL)animate;///< 更新当前指示器的位置百分比

@end

NS_ASSUME_NONNULL_END
