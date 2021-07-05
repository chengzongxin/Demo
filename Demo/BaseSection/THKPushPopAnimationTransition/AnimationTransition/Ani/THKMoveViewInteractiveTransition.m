//
//  THKMoveViewInteractiveTransition.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/3/4.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKMoveViewInteractiveTransition.h"

#define kPopProgress 0.3

@interface THKMoveViewInteractiveTransition ()

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) CGFloat aniProgress;
@property (nonatomic, assign) CGPoint locationPoint;

@end

@implementation THKMoveViewInteractiveTransition

- (void)addGestureToViewController:(UIViewController *)vc {
    self.viewController = vc;
    if (self.panGestureRecognizer) {
        [vc.view removeGestureRecognizer:self.panGestureRecognizer];
    }
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [vc.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)handleGesture:(UIPanGestureRecognizer*)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGPoint vel = [gestureRecognizer velocityInView:gestureRecognizer.view];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            //某些系统会有（0，0）的情况，需区分
            if (translation.y == 0 && translation.x != 0) {
                //滑动方向不对，，仅实现上下滑动回调
                return;
            }
            self.isPanGestureInteration = YES;
            !self.eventBlock ? : self.eventBlock();
            self.aniProgress = 0;
            self.locationPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            float progress = fabs(translation.y / (self.viewController.view.bounds.size.height/2));
            progress = MAX(0.0, progress);

            UIView *animateView = self.ani.tmp_popAnimateTransitionView;//[self aniView];//[self tmp_popAnimateTransitionView];
            CGPoint ct = [animateView center];
            
            CGFloat scale = 0.35;
            
            CGPoint curPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
            ct.x += (curPoint.x - self.locationPoint.x) * scale;
            ct.y += (curPoint.y - self.locationPoint.y) * scale;
            self.locationPoint = curPoint;
            
            CGFloat newProgress = MIN(0.2, progress * scale);
            
            [self updateInteractiveTransition:newProgress];
            
            animateView.center = ct;
            self.ani.tmp_popAnimateStartView.alpha = 1;
//            //微震动
//            if (@available(iOS 10.0, *)) {
//                if (self.aniProgress < kPopProgress && progress > kPopProgress) {
//                    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
//                    [generator prepare];
//                    [generator impactOccurred];
//                } else if (self.aniProgress > kPopProgress && progress < kPopProgress) {
//                    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
//                    [generator prepare];
//                    [generator impactOccurred];
//                }
//            }
            self.aniProgress = progress;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            float progress = fabs(translation.y / (self.viewController.view.bounds.size.height/2));
            progress = MAX(0.0, progress);
            float speedScale = 0.5;
            self.ani.tmp_popAnimateStartView.alpha = 0;

            NSTimeInterval duration = self.duration;
            if (progress >= kPopProgress) {
                self.completionSpeed = speedScale;
                [self finishInteractiveTransition];
            }else {
                self.completionSpeed = 0.1;
                [self cancelInteractiveTransition];
            }
            self.isPanGestureInteration = NO;
            break;
        }
        default:
            break;
    }
}

@end
