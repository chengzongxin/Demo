//
//  THKInteractiveTransition.h
//  HouseKeeper
//  手势
//  Created by ben.gan on 2020/11/24.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ActionBlock)(void);

@interface THKInteractiveTransition : UIPercentDrivenInteractiveTransition

/**
 是否满足侧滑手势交互
 */
@property (nonatomic, assign) BOOL isPanGestureInteration;

/**
 转场时的操作
 */
@property (nonatomic, copy) dispatch_block_t eventBlock;

/**
 转场时的手势
 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

/**
 添加手势到对应vc
 */
- (void)addGestureToViewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
