//
//  THKPushPopAsLocationToListTransition.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/7.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKPushPopAsLocationToListTransition.h"
#import "THKPushPopAsLocationToListTransition+Private.h"

@interface THKPushPopAsLocationToListTransition()

@end

@implementation THKPushPopAsLocationToListTransition

- (UIView *)animateBgMaskView {
    if (!_animateBgMaskView) {
        _animateBgMaskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _animateBgMaskView.backgroundColor = [UIColor blackColor];
    }
    return _animateBgMaskView;
}
#pragma mark - push
- (void)pushAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration {
    
    self.pushFromSourceRectOnWindow = [self.pushFromSourceView convertRect:self.pushFromSourceView.bounds toView:self.pushFromSourceView.window];
    
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    containerView.backgroundColor = [UIColor clearColor];
    containerView.height = TMUI_SCREEN_HEIGHT;
    
    //tabBar
    UIView *tabBarView = nil;
    if (fromVc.tabBarController && !fromVc.tabBarController.tabBar.hidden) {
        tabBarView = [fromVc.tabBarController.tabBar snapshotViewAfterScreenUpdates:NO];
        tabBarView.frame = fromVc.tabBarController.tabBar.frame;
        fromVc.tabBarController.tabBar.hidden = YES;
        self.tabBarFrame = tabBarView.frame;
        self.tabBarView = tabBarView;
        [containerView addSubview:tabBarView];
    }
    
    [containerView addSubview:toVc.view];
    self.animateBgMaskView.alpha = 0;
    [containerView insertSubview:self.animateBgMaskView belowSubview:toVc.view];
    self.pushFromSourceRectOnWindow = [self.pushFromSourceView convertRect:self.pushFromSourceView.bounds toView:containerView];

//自己计算toVc.view位置.处理push的目标tovc的导航条显示或隐藏时，子视图动画过程中对应的正确的显示位置
//    CGRect toViewRect = containerView.bounds;
//    if (!toVc.navBarHidden) {
//        toViewRect.origin.y = (MAX(20, kSafeAreaTopInset()) + 44);
//        toViewRect.size.height -= toViewRect.origin.y;
//    }
//    toVc.view.frame = toViewRect;
    //
//系统方法得出toVc.view的最终显示frame,按此frame赋值添加到containerView上以支持相关过渡效果
    CGRect toVcEndRect = [transitionContext finalFrameForViewController:toVc];
    //
    toVc.view.frame = toVcEndRect;
    toVc.view.alpha = 0;
    fromVc.view.alpha = 1;
            
    if (self.pushFromSourceImage) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.pushFromSourceRectOnWindow];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = self.pushFromSourceImage;
        self.tmp_pushAnimateTransitionView = imgView;
    }else {
        self.tmp_pushAnimateTransitionView = [self.pushFromSourceView snapshotViewAfterScreenUpdates:NO];
    }
    
    self.tmp_pushAnimateTransitionView.clipsToBounds = YES;
    self.tmp_pushAnimateTransitionView.frame = self.pushFromSourceRectOnWindow;
    self.tmp_pushAnimateTransitionView.layer.cornerRadius = self.pushFromCornerRadius;
    [containerView addSubview:self.tmp_pushAnimateTransitionView];    
        
    self.tmp_pushToSourceRect = self.pushToSourceRect;
    if (CGRectEqualToRect(CGRectZero, self.pushToSourceRect)) {
        CGRect rt = self.pushFromSourceView.window.bounds;
        CGSize fitScaleSize = self.pushFromSourceRectOnWindow.size;
        if (self.pushFromSourceImage) {
            fitScaleSize = self.pushFromSourceImage.size;
        }
        float wScale = rt.size.width / fitScaleSize.width;
        rt.size.height  = fitScaleSize.height * wScale;
        rt.origin.x = 0;
        rt.origin.y = (self.pushFromSourceView.window.bounds.size.height - rt.size.height)/2;
        self.tmp_pushToSourceRect = rt;
    }
    
    if (self.getPushToSourceViewBlock) {
        self.pushToSourceView = self.getPushToSourceViewBlock();
    }
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tmp_pushAnimateTransitionView.frame = self.tmp_pushToSourceRect;
        self.tmp_pushAnimateTransitionView.layer.cornerRadius = self.pushToCornerRadius;
        self.animateBgMaskView.alpha = 1;
    } completion:^(BOOL finished) {
        toVc.view.alpha = 1;
        [self.tmp_pushAnimateTransitionView removeFromSuperview];
        [self.animateBgMaskView removeFromSuperview];
        if (tabBarView) {
            [tabBarView removeFromSuperview];
            fromVc.tabBarController.tabBar.hidden = NO;
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
            
}


#pragma mark - pop
- (void)popAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext duration:(NSTimeInterval)duration {
    
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    containerView.backgroundColor = [UIColor clearColor];
    [containerView insertSubview:toVc.view belowSubview:fromVc.view];
    
    //tabBar
    UIView *tabBarView = nil;
    if (toVc.tabBarController && !toVc.tabBarController.tabBar.hidden && self.tabBarView) {
        tabBarView = self.tabBarView;
        tabBarView.frame = self.tabBarFrame;
        [containerView insertSubview:tabBarView belowSubview:toVc.view];
        toVc.tabBarController.tabBar.hidden = YES;
    }
    
    self.animateBgMaskView.alpha = 1;
    [containerView insertSubview:self.animateBgMaskView belowSubview:fromVc.view];
        
//自己计算toVc.view位置.处理返回的目标tovc的导航条显示或隐藏时，子视图动画过程中对应的正确的显示位置
//    CGRect toViewRect = containerView.bounds;
//    if (!toVc.navBarHidden) {
//        toViewRect.origin.y = (MAX(20, kSafeAreaTopInset()) + 44);
//        toViewRect.size.height -= toViewRect.origin.y;
//    }
//    if ([[toVc.navigationController viewControllers].firstObject isEqual:toVc]) {
//        //返回到某tab主页时，tovc.view.frame调整到合适高度(底部有tabbar显示)
//        toViewRect.size.height -= [[toVc tabBarController] tabBar].bounds.size.height;
//    }
//    toVc.view.frame = toViewRect;
    //
//系统方法得出toVc.view的最终显示frame,按此frame赋值添加到containerView上以支持相关过渡效果
    CGRect toVcEndRect = [transitionContext finalFrameForViewController:toVc];
    //
    toVc.view.frame = toVcEndRect;
    toVc.view.alpha = 1;
    
        
    UIView *sourceView = nil;
    CGFloat fromCornerRadius = 0;
    CGFloat toCornerRadius = 0;
    if (self.getPopFromCornerRadiusBlock) {
        fromCornerRadius = self.getPopFromCornerRadiusBlock();
    }
    if (self.getPopToCornerRadiusBlock) {
        toCornerRadius = self.getPopToCornerRadiusBlock();
    }
    
    CGRect fromRect = self.tmp_pushToSourceRect;
    if (self.getPopFromSourceViewBlock) {
        self.popFromSourceView = self.getPopFromSourceViewBlock();
        if (self.popFromSourceView) {
            sourceView = [self.popFromSourceView snapshotViewAfterScreenUpdates:NO];
            fromRect = [self.popFromSourceView convertRect:self.popFromSourceView.bounds toView:containerView];
        }
    }
        
    if (self.getPopFromSourceImageBlock) {
        UIImage *img = self.getPopFromSourceImageBlock();
        if (img) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:fromRect];
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.image = img;
            sourceView = imgView;
        }
    }
                
    if (!sourceView) {
        sourceView = self.tmp_pushAnimateTransitionView;
    }
    
    sourceView.frame = fromRect;
    sourceView.clipsToBounds = YES;
    sourceView.layer.cornerRadius = fromCornerRadius;
    [containerView addSubview:sourceView];
    
    self.tmp_popAnimateTransitionView = sourceView;
    
    CGRect toRect = self.pushFromSourceRectOnWindow;
    if (self.getPopToSourceRectBlock) {
        CGRect rt = self.getPopToSourceRectBlock();
        if (!CGRectEqualToRect(CGRectZero, rt)) {
            toRect = rt;
        }
    }
    
    if (self.getPopToSourceViewBlock) {
        self.popToSourceView = self.getPopToSourceViewBlock();
    }
    
    self.tmp_popToSourceRect = toRect;
    
    fromVc.view.alpha = 0;
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tmp_popAnimateTransitionView.frame = toRect;
        self.tmp_popAnimateTransitionView.layer.cornerRadius = toCornerRadius;
        self.animateBgMaskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tmp_popAnimateTransitionView removeFromSuperview];
        self.tmp_popAnimateTransitionView = nil;
        [self.animateBgMaskView removeFromSuperview];
        if (tabBarView) {
            [tabBarView removeFromSuperview];
            toVc.tabBarController.tabBar.hidden = NO;
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        fromVc.view.alpha = 1;
    }];
    
}


#pragma mark - transition complete
- (void)pushAnimationEnded:(BOOL)transitionCompleted {
    if (self.pushTransitionEndBlock) {
        self.pushTransitionEndBlock(self, transitionCompleted);
    }
}

- (void)popAnimationEnded:(BOOL)transitionCompleted {
    if (self.popTransitionEndBlock) {
        self.popTransitionEndBlock(self, transitionCompleted);
    }
}

@end
