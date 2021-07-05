//
//  THKMoveViewInteractiveTransition.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/3/4.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKInteractiveTransition.h"
#import "THKMoveViewAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMoveViewInteractiveTransition : THKInteractiveTransition

///>对应的动画
@property (nonatomic, strong, nullable) THKMoveViewAnimation *ani;

- (void)addGestureToViewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
