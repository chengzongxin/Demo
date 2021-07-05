//
//  THKMoveCardInteractiveTransition.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKMoveCardInteractiveTransition.h"

#define kPopProgress 0.3

@interface THKMoveCardInteractiveTransition ()

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) CGFloat aniProgress;
@property (nonatomic, assign) CGPoint locationPoint;
@property (nonatomic, weak) UIView *aniView;

@end

@implementation THKMoveCardInteractiveTransition

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
            self.aniProgress = 0;
            self.locationPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
            !self.eventBlock ? : self.eventBlock();
            break;
        }
        case UIGestureRecognizerStateChanged: {
            float progress = fabs(translation.y / (self.viewController.view.bounds.size.height/2));
            progress = MIN(1,(MAX(0.0, progress)));
            //手动过程中，限制progress最大到xx(<100)%的进度，如果拖动就到100%进度，则松手后，相关动画效果会直接没有
            [self updateInteractiveTransition:MIN(0.6, progress)];
            
            UIView *animateView = [self aniView];//[self tmp_popAnimateTransitionView];
            CGPoint ct = [animateView center];
            
            
            CGPoint curPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
            ct.x += (curPoint.x - self.locationPoint.x);
            ct.y += (curPoint.y - self.locationPoint.y);
            self.locationPoint = curPoint;
//            animateView.center = ct;
            
            //微震动
            if (@available(iOS 10.0, *)) {
                if (self.aniProgress < kPopProgress && progress > kPopProgress) {
                    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                    [generator prepare];
                    [generator impactOccurred];
                } else if (self.aniProgress > kPopProgress && progress < kPopProgress) {
                    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
                    [generator prepare];
                    [generator impactOccurred];
                }
            }
            self.aniProgress = progress;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            float progress = fabs(translation.y / (self.viewController.view.bounds.size.height/2));
            //限制最大取值，当为1时执行速度会很快，体验不好
            progress = MIN(0.85,(MAX(0.0, progress)));
            
            NSTimeInterval duration = self.duration;
            if (progress >= kPopProgress) {
                float speedScale = 0.7;
                if (progress < 0.6) {
                    speedScale = (1.0 - (progress - 0.3)) * 1.6;
                }
                
                if (self.endRect.size.width < 2) {
                    UIView *animateView = self.aniView;//[self tmp_popAnimateTransitionView];
                    NSArray *ls = [animateView.layer animationKeys];

                    for (NSString *key in ls) {
                        //移除popTransition动画中涉及的位置变化的animation,然后重新创建一个动画执行
                        //但原自定义的transition的回调流程不能被中断,故仅移除position及bounds.origin,bounds.size的动画
                        if ([key containsString:@"bounds"] ||
                            [key containsString:@"position"]) {
                            [animateView.layer removeAnimationForKey:key];
                        }
                    }
                    
                    //1.
                    //经过调试发现动画中取的frame值比实际UI显示的值size要小，所以这里只能直接让animationView看不见
                    //animateView.alpha = 0;
                    //2. 尝试在放手时重新获取一次popTo的目标位置，此时上一级列表项应该已经执行了重定位逻辑，
                    //可以正确取到对应的位置，若当前取到的位置还有问题，则直接消失
                    //添加的动画block仍然受popTransition管理真实的过渡时长，这里参数与popTransition中的动画时长保持一致即可，在此增加的动画block的completion回调后，会马上执行原transition的自定义动画的completion回调

                    CGRect newToRect = self.endRect;//[self getCurrentPopToRect];
                    if (newToRect.size.width > 10) {//这里因有可能返回{0,0}及{1,1}，故这里的判断稍调大一些
                        [UIView animateWithDuration:duration animations:^{
                            animateView.frame = newToRect;
                        } completion:^(BOOL finished) {
                            animateView.alpha = 0;
                        }];
                    }else {
                        animateView.alpha = 0;
                    }
                }
                
                self.completionSpeed = speedScale * duration;
                [self finishInteractiveTransition];
            }else {
                self.completionSpeed = (1.0-progress) * duration;
                [self cancelInteractiveTransition];
            }
            self.isPanGestureInteration = NO;
            break;
        }
        default:
            break;
    }
}

- (UIView *)aniView {
    if (!_aniView && self.getAnimationViewBlock) {
        _aniView = self.getAnimationViewBlock();
    }
    return _aniView;
}

@end
