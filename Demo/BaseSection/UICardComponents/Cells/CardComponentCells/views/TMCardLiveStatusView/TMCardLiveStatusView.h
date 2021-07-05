//
//  TMCardLiveStatusView.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/22.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN
/**
 直播卡片cell上展示的直播状态条视图
 @note 分为直播中和回播两种样式：
 直播lottie-观看人数 or 回放+块背景视图-观看人数
 @note 直播Lottie视图尺寸为16x16
 @note 外部需要约束指定此视图的leading\traling\top\bottom ,其中traling指定最大范围约束即可，因具体宽度由内部文本串等综合宽度决定
 @note 背景色默认黑色-alpha-0.6
 */
@interface TMCardLiveStatusView : THKView

@property (nonatomic, assign, getter = isLiving)BOOL living;///< 直播中的状态，关联联动对应的UI，默认为NO，即表示回放

@property (nonatomic, copy)NSString *watchNumFormatStr;///< 观看人数格式化后的串(e.g: 10, 100, 1000, 1.1w)

@property (nonatomic, assign)CGFloat contentRadius;///< 涉及自身圆角及回放背景块视图的圆角，默认为4;

@end

NS_ASSUME_NONNULL_END
