//
//  THKMoveViewAnimation.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/3/4.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKMoveViewAnimation.h"

#define kAniScale   0.93
#define kAniRadiu   12

@interface THKMoveViewAnimation ()

@property (nonatomic, strong)UIView *bkgView;

@property (nonatomic, strong) UIView *fromScreenView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) CGRect tempStartRect;

@property (nonatomic, assign) BOOL changeTabBar;

@property (nonatomic, strong) UIView *tmp_popAnimateTransitionView;
@property (nonatomic, strong) UIView *tmp_popAnimateStartView;

@end

@implementation THKMoveViewAnimation

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
               fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC
             fromView:(UIView *)fromView
               toView:(UIView *)toView
             duration:(CGFloat)duration {
    
    UIView *containerView = transitionContext.containerView;
    
    //tabBar
    if (fromVC.tabBarController && !fromVC.tabBarController.tabBar.hidden) {
        fromVC.tabBarController.tabBar.hidden = YES;
        self.changeTabBar = YES;
    }
    
    CGRect startRect = [self.pushDelegate startRect:self.indexPath];
    CGRect endRect = [self.pushDelegate endRect:self.indexPath];
    UIView *startView = [[self.pushDelegate animationView:self.indexPath] snapshotViewAfterScreenUpdates:NO];
    startView.contentMode = UIViewContentModeScaleAspectFill;
    self.tempStartRect = startRect;
    
    //view背景
    UIView *fromViewBkgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT)];
    fromViewBkgView.backgroundColor = [UIColor blackColor];
    
    //fromScreenView
    UIView *fromScreenView = [TMUI_AppWindow snapshotViewAfterScreenUpdates:NO];
    fromScreenView.frame = fromViewBkgView.frame;
    fromScreenView.layer.masksToBounds = YES;

    //遮罩
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [fromScreenView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(fromScreenView);
    }];
    self.maskView = maskView;
    self.fromScreenView = fromScreenView;
    
    //容器
    UIView *boxView = [[UIView alloc] init];
    boxView.backgroundColor = [UIColor whiteColor];
    boxView.clipsToBounds = YES;

    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromViewBkgView];
    [fromViewBkgView addSubview:self.fromScreenView];
    [containerView addSubview:boxView];
    
    fromVC.navigationController.navigationBar.hidden = YES;

    CGRect toVcEndRect = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = toVcEndRect;
    [toVC.view layoutIfNeeded];
    
    UIView *endView = [toVC.view snapshotViewAfterScreenUpdates:YES];//[self.pushDelegate viewForPushView];
    
    //startView渐消
    //endView渐显
    [boxView addSubview:endView];
    [boxView addSubview:startView];
  
    [self reMakeViewConstraintsOfView:boxView newRect:startRect];

    CGFloat startAs = startRect.size.width > 0 ? startRect.size.height * 1.0 / startRect.size.width : 1.0;
    CGFloat endAs = endRect.size.width > 0 ? endRect.size.height * 1.0 / endRect.size.width : 1.0;

    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(boxView);
        make.height.mas_equalTo(startView.mas_width).multipliedBy(startAs);
    }];
    [endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(boxView);
        make.height.mas_equalTo(endView.mas_width).multipliedBy(endAs);
    }];
    
    [boxView layoutIfNeeded];
    
    endView.alpha = 0;
    startView.alpha = 1;
    self.maskView.alpha = 0;

    fromScreenView.layer.cornerRadius = kAniRadiu;
    boxView.layer.cornerRadius = kAniRadiu;

    [UIView animateWithDuration:duration * 0.2 animations:^{
        startView.alpha = 0.5;
        endView.alpha = 0.5;
        self.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration * 0.2 animations:^{
            endView.alpha = 1;
            startView.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    }];
    
    [UIView animateWithDuration:duration * 0.9 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self reMakeViewConstraintsOfView:boxView newRect:toVcEndRect];
        [boxView layoutIfNeeded];
        fromScreenView.transform = //CGAffineTransformScale(CGAffineTransformIdentity, kAniScale, kAniScale);
        CGAffineTransformMake(kAniScale, 0, 0, kAniScale, 0, MAX(tmui_safeAreaTopInset(), 20) * kAniScale * 0.8);
        
    } completion:^(BOOL finished) {
        fromVC.navigationController.navigationBar.hidden = NO;
        if (self.changeTabBar) {
            fromVC.tabBarController.tabBar.hidden = NO;
            self.changeTabBar = NO;
        }
        if ([transitionContext transitionWasCancelled]) {
            [boxView removeFromSuperview];
            [fromViewBkgView removeFromSuperview];
        } else {
            [containerView bringSubviewToFront:toVC.view];
            endView.alpha = 1;
            startView.alpha = 0;
            toVC.view.alpha = 0;

            [UIView animateWithDuration:0 animations:^{
                toVC.view.alpha = 1;
            } completion:^(BOOL finished) {
                fromScreenView.transform = CGAffineTransformIdentity;
                [boxView removeFromSuperview];
                [fromViewBkgView removeFromSuperview];
                
                if (self.pushEndBlock) {
                    self.pushEndBlock();
                    UIView *fView = [fromVC.view snapshotViewAfterScreenUpdates:YES];
                    CGRect fromViewFrame = [fromVC.view convertRect:fromVC.view.bounds toView:TMUI_AppWindow];
                    fView.frame = fromViewFrame;
                    [self.fromScreenView insertSubview:fView belowSubview:self.maskView];
                }
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView duration:(CGFloat)duration {
 
    UIView *containerView = transitionContext.containerView;
    
    //tabBar
    if (toVC.tabBarController && !toVC.tabBarController.tabBar.hidden) {
        toVC.tabBarController.tabBar.hidden = YES;
        self.changeTabBar = YES;
    }

    //view背景
    UIView *toViewBkgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT)];
    toViewBkgView.backgroundColor = [UIColor blackColor];
    
    //toView
    UIView *toScreenView = self.fromScreenView;
    toScreenView.frame = toViewBkgView.frame;
    
    //容器
    UIView *boxView = [[UIView alloc] init];
    boxView.backgroundColor = [UIColor whiteColor];
    boxView.clipsToBounds = YES;
    boxView.layer.cornerRadius = kAniRadiu;

    //结束
    UIView *endView = [[self.pushDelegate animationView:[self.popDelegate indexForAnimationView]] snapshotViewAfterScreenUpdates:YES];
    
    //开始
    UIView *startView = [fromView snapshotViewAfterScreenUpdates:NO];
    CGRect startRect = startView.frame;
    
    toVC.navigationController.navigationBar.hidden = YES;

    self.tmp_popAnimateTransitionView = boxView;
    self.tmp_popAnimateStartView = startView;
    
    CGRect endRect = self.tempStartRect;

    [boxView addSubview:endView];
    [boxView addSubview:startView];
    [toViewBkgView addSubview:toScreenView];

    [containerView addSubview:toVC.view];
    [containerView addSubview:toViewBkgView];
    [containerView addSubview:boxView];

    startView.alpha = 1;
    endView.alpha = 0;
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    self.maskView.alpha = 1;

    [self reMakeViewConstraintsOfView:boxView newRect:startRect];
    
    CGFloat startAs = startRect.size.width > 0 ? startRect.size.height * 1.0 / startRect.size.width : 1.0;
    CGFloat endAs = endRect.size.width > 0 ? endRect.size.height * 1.0 / endRect.size.width : 1.0;

    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(boxView);
        make.height.mas_equalTo(startView.mas_width).multipliedBy(startAs);
    }];
    [endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(boxView);
        make.height.mas_equalTo(endView.mas_width).multipliedBy(endAs);
    }];
    [boxView layoutIfNeeded];
    
    toScreenView.transform = CGAffineTransformMake(kAniScale, 0, 0, kAniScale, 0, MAX(tmui_safeAreaTopInset(), 20) * kAniScale * 0.8);
    toScreenView.layer.cornerRadius = kAniRadiu;

    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self reMakeViewConstraintsOfView:boxView newRect:endRect];
        [boxView layoutIfNeeded];
        endView.alpha = 1;
        startView.alpha = 0;
        toScreenView.transform = CGAffineTransformIdentity;
        toScreenView.layer.cornerRadius = 0;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        self.maskView.alpha = 0;
        toVC.navigationController.navigationBar.hidden = NO;
        toScreenView.transform = CGAffineTransformIdentity;
        [toViewBkgView removeFromSuperview];
        [boxView removeFromSuperview];

        if ([transitionContext transitionWasCancelled]) {
            endView.alpha = 0;
            startView.alpha = 1;
            [toVC.view removeFromSuperview];
            self.maskView.alpha = 1;
        } else {
            endView.alpha = 1;
            startView.alpha = 0;
            if (self.changeTabBar) {
                toVC.tabBarController.tabBar.hidden = NO;
                self.changeTabBar = NO;
            }
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)changeStartRect:(CGRect)startRect {
    self.tempStartRect = startRect;
}

#pragma mark - Private

- (void)reMakeViewConstraintsOfView:(UIView *)view newRect:(CGRect)rect {
    view.frame = rect;
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(rect.origin.x);
        make.top.mas_equalTo(rect.origin.y);
        make.size.mas_equalTo(rect.size);
    }];
}

#pragma mark - Lazy

- (UIView *)bkgView {
    if (!_bkgView) {
        _bkgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bkgView.backgroundColor = [UIColor blackColor];
    }
    return _bkgView;
}

@end
