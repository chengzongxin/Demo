//
//  THKPushPopBaseTransition.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/7.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 此基类仅相关接口定义，由具体子类实现相关交互的动效
 */
@interface THKPushPopBaseTransition : NSObject

/// push转场动效的实现函数,需要具体的子类实现
/// 注意在相关转场动画执行完后需要主动调用 [transitionContext completeTransition:YES];
- (void)pushAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration;

/// 子类可能需要相关处理push动画结束后的回调
- (void)pushAnimationEnded:(BOOL)transitionCompleted;

/// pop转场动效的实现函数,需要具体的子类实现
/// 注意在相关转场动画执行完后需要主动调用 [transitionContext completeTransition:YES];
- (void)popAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration;

/// 子类可能需要相关处理pop动画结束后的回调
- (void)popAnimationEnded:(BOOL)transitionCompleted;

@end

NS_ASSUME_NONNULL_END
