//
//  THKMoveCardAnimation.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/2/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKMoveCardAnimation.h"

#define kAniScale   0.93
#define kAniRadiu   12

@interface THKMoveCardAnimation ()

@property (nonatomic, assign) CGRect tabBarFrame;
@property (nonatomic, strong) UIView *tabBarView;

//内部使用的一些辅助对象
@property (nonatomic, strong)UIView *animateBgMaskView;

@property (nonatomic, strong)UIView *bkgView;

@property (nonatomic, strong) UIView *fromScreenView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) CGRect tempStartRect;

@property (nonatomic, assign) BOOL changeTabBar;

@property (nonatomic, strong) UIView *tmp_popAnimateTransitionView;
@property (nonatomic, strong) UIView *tmp_popAnimateStartView;

@end

@implementation THKMoveCardAnimation

- (UIView *)animateBgMaskView {
    if (!_animateBgMaskView) {
        _animateBgMaskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _animateBgMaskView.backgroundColor = [UIColor blackColor];
    }
    return _animateBgMaskView;
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView duration:(CGFloat)duration {
    UIView *containerView = transitionContext.containerView;
    
    //tabBar
    if (fromVC.tabBarController && !fromVC.tabBarController.tabBar.hidden) {
        fromVC.tabBarController.tabBar.hidden = YES;
        self.changeTabBar = YES;
    }
    
    CGRect startRect = [self.pushDelegate startCardRect:self.indexPath];
    CGRect endRect = [self.pushDelegate endCardRect:self.indexPath];
    UIImage *image = [self.pushDelegate animationImage:self.indexPath];
    UIView *startView = [self animationImageView:self.indexPath];

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
//    UIView *boxView = [[UIView alloc] init];
//    boxView.backgroundColor = [UIColor blackColor];
//    boxView.clipsToBounds = YES;
    UIView *tView = [[UIView alloc] init];
    tView.backgroundColor = [UIColor blackColor];
    tView.clipsToBounds = YES;

    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromViewBkgView];
    [fromViewBkgView addSubview:self.fromScreenView];
    [containerView addSubview:tView];
    [containerView addSubview:startView];
    
    fromVC.navigationController.navigationBar.hidden = YES;

    CGRect toVcEndRect = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = toVcEndRect;
    [toVC.view layoutIfNeeded];
    
//    [boxView addSubview:startView];
  
//    [self reMakeViewConstraintsOfView:boxView newRect:startRect];

    CGFloat startAs = image.size.width > 0 ? image.size.height * 1.0 / image.size.width : 1.0;

//    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.centerX.centerY.equalTo(boxView);
//        make.height.mas_equalTo(startView.mas_width).multipliedBy(startAs);
//    }];

    CGRect endRect1 = CGRectMake(0, (toVcEndRect.size.height - toVcEndRect.size.width * startAs) * 0.5, toVcEndRect.size.width, toVcEndRect.size.width * startAs);
    
//    [boxView layoutIfNeeded];
    
    self.maskView.alpha = 0;
    tView.alpha = 0;
    
    fromScreenView.layer.cornerRadius = kAniRadiu;
//    boxView.layer.cornerRadius = kAniRadiu;
    startView.frame = startRect;
    tView.frame = toVcEndRect;
    startView.layer.cornerRadius = kAniRadiu;

    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
//        [self reMakeViewConstraintsOfView:boxView newRect:toVcEndRect];
//        [boxView layoutIfNeeded];
        fromScreenView.transform = CGAffineTransformMake(kAniScale, 0, 0, kAniScale, 0, MAX(kSafeAreaTopInset(), 20) * kAniScale * 0.8);
        
        startView.frame = endRect1;
        startView.layer.cornerRadius = 0;
        tView.alpha = 1;

    } completion:^(BOOL finished) {
        fromVC.navigationController.navigationBar.hidden = NO;
        if (self.changeTabBar) {
            fromVC.tabBarController.tabBar.hidden = NO;
            self.changeTabBar = NO;
        }
        if ([transitionContext transitionWasCancelled]) {
//            [boxView removeFromSuperview];
            [fromViewBkgView removeFromSuperview];
        } else {
            [containerView bringSubviewToFront:toVC.view];
            startView.alpha = 0;
            toVC.view.alpha = 1;

//            [UIView animateWithDuration:0 animations:^{
//                toVC.view.alpha = 1;
//            } completion:^(BOOL finished) {
                fromScreenView.transform = CGAffineTransformIdentity;
//                [boxView removeFromSuperview];
                [fromViewBkgView removeFromSuperview];
                
//                if (self.pushEndBlock) {
//                    self.pushEndBlock();
//                    UIView *fView = [fromVC.view snapshotViewAfterScreenUpdates:YES];
//                    CGRect fromViewFrame = [fromVC.view convertRect:fromVC.view.bounds toView:kCurrentWindow];
//                    fView.frame = fromViewFrame;
//                    [self.fromScreenView insertSubview:fView belowSubview:self.maskView];
//                }
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            }];
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
    UIView *toViewBkgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
    UIView *endView = [self animationImageView:[self.popDelegate indexPathForAnimationView]];

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
    
    toScreenView.transform = CGAffineTransformMake(kAniScale, 0, 0, kAniScale, 0, MAX(kSafeAreaTopInset(), 20) * kAniScale * 0.8);
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

- (UIView *)animationImageView:(NSIndexPath *)indexPath {
    if ([self.pushDelegate animationImage:indexPath]) {
        UIImage *img = [self.pushDelegate animationImage:indexPath];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = img;
        return imgView;
    }
    return nil;
}

- (void)reMakeViewConstraintsOfView:(UIView *)view newRect:(CGRect)rect {
    view.frame = rect;
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(rect.origin.x);
        make.top.mas_equalTo(rect.origin.y);
        make.size.mas_equalTo(rect.size);
    }];
}

@end
