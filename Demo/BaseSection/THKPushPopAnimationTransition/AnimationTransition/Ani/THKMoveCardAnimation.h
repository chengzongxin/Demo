//
//  THKMoveCardAnimation.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKBaseAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@protocol THKMoveCardAnimationPushDelegate <NSObject>

//获取开始位置
- (CGRect)startCardRect:(NSIndexPath *)indexPath;

////获取当前view
//- (UIView *)animationView:(NSInteger)index;

//获取当前图片
- (UIImage * _Nullable)animationImage:(NSIndexPath *)indexPath;

//获取放大后的位置
- (CGRect)endCardRect:(NSIndexPath *)indexPath;

@end

@protocol THKMoveCardAnimationPopDelegate <NSObject>

//获取当前图片的下标
- (NSIndexPath *)indexPathForAnimationView;
////获取view
//- (UIView *)viewForAnimationView;

@end

@interface THKMoveCardAnimation : THKBaseAnimation

@property (nonatomic, weak) id<THKMoveCardAnimationPushDelegate> pushDelegate;
@property (nonatomic, weak) id<THKMoveCardAnimationPopDelegate> popDelegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong)UIView *tmp_pushAnimateTransitionView;

@end

NS_ASSUME_NONNULL_END
