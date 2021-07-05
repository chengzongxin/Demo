//
//  THKMoveCardInteractiveTransition.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THKInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMoveCardInteractiveTransition : THKInteractiveTransition

- (void)addGestureToViewController:(UIViewController *)vc;


//@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, copy, nullable) UIView *_Nullable(^getAnimationViewBlock)(void);
@property (nonatomic, assign) CGRect endRect;

/**
 duration
 aniView
 endRect
 */

@end

NS_ASSUME_NONNULL_END
