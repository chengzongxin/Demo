//
//  THKPushPopAsLocationToListSimulationTransition.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/8.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKPushPopAsLocationToListSimulationTransition.h"
#import "THKPushPopAsLocationToListTransition+Private.h"

@implementation THKPushPopAsLocationToListSimulationTransition

- (void)pushAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration {
    [super pushAnimateTransition:transitionContext duration:duration];
    self.pushFromSourceView.alpha = 0;
    self.pushToSourceView.alpha = 0;
}

- (void)popAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration {
    [super popAnimateTransition:transitionContext duration:duration];
    self.popFromSourceView.alpha = 0;
    self.popToSourceView.alpha = 0;
}

- (void)pushAnimationEnded:(BOOL)transitionCompleted {
    self.pushFromSourceView.alpha = 1;
    self.pushToSourceView.alpha = 1;
    [super pushAnimationEnded:transitionCompleted];
}

- (void)popAnimationEnded:(BOOL)transitionCompleted {
    self.popFromSourceView.alpha = 1;
    self.popToSourceView.alpha = 1;
    [super popAnimationEnded:transitionCompleted];
}

@end
