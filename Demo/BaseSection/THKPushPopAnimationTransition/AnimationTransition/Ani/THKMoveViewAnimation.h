//
//  THKMoveViewAnimation.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/3/4.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKBaseAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@protocol THKMoveViewAnimationPushDelegate <NSObject>

//获取开始位置
- (CGRect)startRect:(NSIndexPath *)indexPath;

//获取当前view
- (UIView *)animationView:(NSIndexPath *)indexPath;

//获取放大后的位置
- (CGRect)endRect:(NSIndexPath *)indexPath;

@end

@protocol THKMoveViewAnimationPopDelegate <NSObject>

//获取当前图片的下标
- (NSIndexPath *)indexForAnimationView;

@end

@interface THKMoveViewAnimation : THKBaseAnimation

@property (nonatomic, weak) id<THKMoveViewAnimationPushDelegate> pushDelegate;
@property (nonatomic, weak) id<THKMoveViewAnimationPopDelegate> popDelegate;

@property (nonatomic, strong) NSIndexPath *indexPath;
///> pop运动的View（手势动画用）
@property (nonatomic, strong, readonly) UIView *tmp_popAnimateTransitionView;
@property (nonatomic, strong, readonly) UIView *tmp_popAnimateStartView;
///> push动画结束后的回调
@property (nonatomic, copy, nullable) void (^pushEndBlock)(void);

/**
 改变初始frame
 */
- (void)changeStartRect:(CGRect)startRect;

@end

NS_ASSUME_NONNULL_END
