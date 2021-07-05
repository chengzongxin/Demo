//
//  THKPushPopBaseTransition.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/7.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKPushPopBaseTransition.h"

@implementation THKPushPopBaseTransition

- (void)pushAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration {
    [transitionContext completeTransition:YES];
}

- (void)pushAnimationEnded:(BOOL)transitionCompleted {}


- (void)popAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration {
    [transitionContext completeTransition:YES];
}

- (void)popAnimationEnded:(BOOL)transitionCompleted {}

@end
