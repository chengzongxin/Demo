//
//  UIViewController+PopGestureOfPercentDrivenInteractiveTransition.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/9.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "UIViewController+PopGestureOfPercentDrivenInteractiveTransition.h"
#import "THKPushPopTransitionManager+Private.h"
#import "THKPushPopAsLocationToListTransition+Private.h"

#define kPopProgress 0.3

@implementation UIViewController (PopGestureOfPercentDrivenInteractiveTransition)

- (void)addPopGestureOfPercentDrivenInteractiveTransition {
    if([self isViewLoaded] && self.pushPopTransitionManager) {
        if (!self.pushPopTransitionManager.popPanGesture) {
            //此方法必须viewDidLoad中或之后调用
            self.pushPopTransitionManager.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(__popPanGestureHandle:)];
            [self.view addGestureRecognizer:self.pushPopTransitionManager.popPanGesture];
        }
    }else {
        NSAssert(NO, @"addPopGestureOfPercentDrivenInteractiveTransition method should be call in or after viewDidLoad method.");
    }
}

static float aniProgress = 0;

- (void)__popPanGestureHandle:(UIPanGestureRecognizer *)pan {
//    if (self.tabBarController && self.navigationController.viewControllers.count <= 2) {
//        //返回到Tab主页时，底部tabbar动画效果不佳.故返回跟随手势不作反馈处理
//        return;
//    }

    if (pan.state == UIGestureRecognizerStateBegan) {
        if (self.pushPopTransitionManager.enablePopGestureOfPercentDrivenInteractiveTransitionBlock) {
            //若外部当前有其它临时弹出视图层，则可以控制不响应返回手势
            BOOL enable = self.pushPopTransitionManager.enablePopGestureOfPercentDrivenInteractiveTransitionBlock();
            if (!enable) {
                return;
            }
        }
        //某些系统会有（0，0）的情况，需区分
        if ([pan translationInView:self.view].y == 0 && [pan translationInView:self.view].x != 0) {
            //滑动方向不对，，仅实现上下滑动回调
            return;
        }
        
        self.pushPopTransitionManager.popGesturePreviousPoint = [pan locationInView:self.view];
        
        if (!self.pushPopTransitionManager.popGesturePercentDrivenInteractiveTransition) {
            self.pushPopTransitionManager.popGesturePercentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        }
        //触发pop转场动画, 由于popGesturePercentDrivenInteractiveTransition已初始化，相关转场进度会交给此对象管理
        [self.navigationController popViewControllerAnimated:YES];
        aniProgress = 0;
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        float progress = fabs([pan translationInView:self.view].y / (self.view.bounds.size.height/2));
        progress = MIN(1,(MAX(0.0, progress)));
        //手动过程中，限制progress最大到xx(<100)%的进度，如果拖动就到100%进度，则松手后，相关动画效果会直接没有
        [self.pushPopTransitionManager.popGesturePercentDrivenInteractiveTransition updateInteractiveTransition:MIN(0.6, progress)];
        
        //在执行默认动画进度控制更新后，再手动调整按拖动过程中的跟随位置(尺寸不能修改，必须与实际的动画进度中的尺寸保持一致)
        UIView *animateView = [self tmp_popAnimateTransitionView];
        CGRect rt = [animateView frame];
        
        CGPoint curPoint = [pan locationInView:self.view];
        rt.origin.x += (curPoint.x - self.pushPopTransitionManager.popGesturePreviousPoint.x);
        rt.origin.y += (curPoint.y - self.pushPopTransitionManager.popGesturePreviousPoint.y);
        self.pushPopTransitionManager.popGesturePreviousPoint = curPoint;
        animateView.frame = rt;
        //微震动
        //8.14以后的版本再加上此效果
//        if (@available(iOS 10.0, *)) {
//            if (aniProgress < kPopProgress && progress > kPopProgress) {
//                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
//                [generator prepare];
//                [generator impactOccurred];
//            } else if (aniProgress > kPopProgress && progress < kPopProgress) {
//                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
//                [generator prepare];
//                [generator impactOccurred];
//            }
//        }
        aniProgress = progress;
    }else if (pan.state == UIGestureRecognizerStateCancelled ||
              pan.state == UIGestureRecognizerStateEnded) {
        float progress = fabs([pan translationInView:self.view].y / (self.view.bounds.size.height/2));
        //限制最大取值，当为1时执行速度会很快，体验不好
        progress = MIN(0.85,(MAX(0.0, progress)));
        
        NSTimeInterval duration = self.pushPopTransitionManager.duration > 0 ? self.pushPopTransitionManager.duration : THKPushPopTransitionDefaultDuration;
        if (progress >= kPopProgress) {
            float speedScale = 0.7;
            if (progress < 0.6) {
                speedScale = (1.0 - (progress - 0.3)) * 1.6;
            }
            
            if (![self hasValidPopToRect]) {
                UIView *animateView = [self tmp_popAnimateTransitionView];
                NSArray *ls = [animateView.layer animationKeys];
    //            ls: (
    //            UIPacingAnimationForAnimatorsKey,
    //            position, --remove
    //            bounds.origin, --remove
    //            bounds.size, --remove
    //            cornerRadius
    //            )
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
                CGRect newToRect = [self getCurrentPopToRect];
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
            
            self.pushPopTransitionManager.popGesturePercentDrivenInteractiveTransition.completionSpeed = speedScale * duration;
            [self.pushPopTransitionManager.popGesturePercentDrivenInteractiveTransition finishInteractiveTransition];
        }else {
            self.pushPopTransitionManager.popGesturePercentDrivenInteractiveTransition.completionSpeed = (1.0-progress) * duration;
            [self.pushPopTransitionManager.popGesturePercentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        //取消或完成后需要设置为nil,若取消后不置为nil，则正常的popViewControllerAnimated:操作也会到 popGesturePercentDrivenInteractiveTransition 的控制逻辑中，由于不像手势有连续的updateInteractiveTransition：更新操作，会导致实际的pop操作失效
        self.pushPopTransitionManager.popGesturePercentDrivenInteractiveTransition = nil;
    }
}

- (UIView *)tmp_popAnimateTransitionView {
    THKPushPopAsLocationToListTransition *transi = (THKPushPopAsLocationToListTransition*)self.pushPopTransitionManager.pushPopTransition;
    if ([transi isKindOfClass:[THKPushPopAsLocationToListTransition class]]) {
        return transi.tmp_popAnimateTransitionView;
    }
    if ([transi isKindOfClass:[THKPushPopBaseTransition class]]) {
        return transi.tmp_popAnimateTransitionView;
    }
    return nil;
}

- (BOOL)hasValidPopToRect {
    THKPushPopAsLocationToListTransition *transi = (THKPushPopAsLocationToListTransition*)self.pushPopTransitionManager.pushPopTransition;
    if ([transi isKindOfClass:[THKPushPopAsLocationToListTransition class]]) {
        CGRect toRt = transi.tmp_popToSourceRect;
        if (toRt.size.width <= 2 ||
            toRt.size.height <= 2) {
            return NO;
        }
    }
    return YES;
}

- (CGRect)getCurrentPopToRect {
    THKPushPopAsLocationToListTransition *transi = (THKPushPopAsLocationToListTransition*)self.pushPopTransitionManager.pushPopTransition;
    if ([transi isKindOfClass:[THKPushPopAsLocationToListTransition class]]) {
        CGRect toRt = transi.tmp_popToSourceRect;
        if (transi.getPopToSourceRectBlock) {
            toRt = transi.getPopToSourceRectBlock();
            return toRt;
        }
    }
    return CGRectZero;
}

@end
