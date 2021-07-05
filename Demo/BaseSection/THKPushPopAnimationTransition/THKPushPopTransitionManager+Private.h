//
//  THKPushPopTransitionManager+Private.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/9.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKPushPopTransitionManager.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const NSTimeInterval THKPushPopTransitionDefaultDuration;

@interface THKPushPopTransitionManager ()

/// 负责手势返回百分比效果，相关手势百分比赋值逻辑需要在对应执行pop的具体vc里自行处理
/// 此属性应用层外部不用关注赋值，通过 UIViewController+PopGestureOfPercentDrivenInteractiveTransition 里的相关方法会自动创建赋值
@property(nonatomic, strong, nullable)__kindof UIPercentDrivenInteractiveTransition *popGesturePercentDrivenInteractiveTransition;

/// 需要存储起来，一些特殊交互场景时可能需要临时关闭或恢复返回手势的支持
@property (nonatomic, strong,nullable)UIPanGestureRecognizer *popPanGesture;

///pop手势自定义跟随效果需要的参考数据，记录手势识别时的位置点，方便手势移动过程，处理相关移动的位置
@property (nonatomic, assign)CGPoint popGesturePreviousPoint;

@end

NS_ASSUME_NONNULL_END
