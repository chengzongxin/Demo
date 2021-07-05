//
//  THKPushPopAsLocationToListTransition+Private.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/8.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKPushPopAsLocationToListTransition.h"

NS_ASSUME_NONNULL_BEGIN

/// 动画过程可能需要的一些数据对象支持
@interface THKPushPopAsLocationToListTransition ()

@property (nonatomic, assign)CGRect pushFromSourceRectOnWindow;
@property (nonatomic, assign)CGRect tmp_pushToSourceRect;
@property (nonatomic, assign)CGRect tmp_popToSourceRect;
@property (nonatomic, strong)UIView *tmp_pushAnimateTransitionView;
@property (nonatomic, strong)UIView *tmp_popAnimateTransitionView;

/// 记录外部对应的相关视图对象，一些动画效果可能需要访问

///push from & to sourceViews
//@property (nonatomic, weak)UIView *pushFromSourceView;// .h里已定义
@property (nonatomic, weak)UIView *pushToSourceView;

@property (nonatomic, weak)UIView *popFromSourceView;
@property (nonatomic, weak)UIView *popToSourceView;

//内部使用的一些辅助对象
@property (nonatomic, strong)UIView *animateBgMaskView;

@property (nonatomic, assign) CGRect tabBarFrame;
@property (nonatomic, strong) UIView *tabBarView;

@end

NS_ASSUME_NONNULL_END
