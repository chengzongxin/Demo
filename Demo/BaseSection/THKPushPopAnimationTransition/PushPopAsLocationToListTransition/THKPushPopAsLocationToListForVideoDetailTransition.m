//
//  THKPushPopAsLocationToListForVideoDetailTransition.m
//  HouseKeeper
//
//  Created by nigel.ning on 2021/1/20.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKPushPopAsLocationToListForVideoDetailTransition.h"
#import "THKPushPopAsLocationToListTransition+Private.h"

@implementation THKPushPopAsLocationToListForVideoDetailTransition

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
            
//            if (sourceView) {
//                CGRect fixRect = CGRectZero;
//                THKVideoDetailSinglePlayerView *playerView = nil;
//                if (self.getAliPlayerViewBlock) {
//                    playerView = self.getAliPlayerViewBlock();
//                }
//
//                if (playerView) {
//                    fixRect = playerView.bounds;
//
//                    float height2Width = 0;
//                    if (playerView.player.height > 0 &&
//                        playerView.player.width > 0) {
//                        height2Width = playerView.player.height * 1.0f / playerView.player.width;
//                        fixRect.size.height = fixRect.size.width * height2Width;
//                        fixRect.size.height = MIN(fixRect.size.height, playerView.bounds.size.height);
//                        fixRect.origin.y = (playerView.bounds.size.height - fixRect.size.height)/2;
//                    }
//
//                    if (!CGRectEqualToRect(CGRectZero, fixRect) &&
//                        playerView &&
//                        [playerView playerStatus] != AVPStatusError) {
//                        //取sourceView中fixRect范围内的子视图
//                        //注意⚠️：snapshotViewAfterScreenUpdates方法返回的是 _UIReplicantView 类型的视图，此视图无法再写入位图生成UIImage对象
//                        //因视频渲染是OpenGL ES绘制此时即已存在GPUImage，而renderInContext和opengl es不能同时工作，所以按常规的UIView生成UIImage对象的方法会失效
//                        //@see: https://www.jianshu.com/p/5220f9688682?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
//                        //经过各种尝试，最终只能选择以播放器本身提供的截屏方法来实现，但注意播放器的截屏方法为异步回调
//                        //修正fromRect的值
//                        fromRect = [self.popFromSourceView convertRect:fixRect toView:containerView];
//                        //重新设置修正后的sourceView
//                        UIImageView *imgView = [[UIImageView alloc] initWithFrame:fromRect];
//                        imgView.clipsToBounds = YES;
//                        imgView.contentMode = UIViewContentModeScaleAspectFill;
//                        sourceView = imgView;
//                        //视频播放器的截屏是异步回调
//                        @weakify(playerView, imgView);
//                        [playerView setSnapshotResultBlock:^(UIImage * _Nonnull snapshotImage) {
//                            imgView.image = snapshotImage;
//                            @strongify(playerView, imgView);
//                            playerView.snapshotResultBlock = nil;
//                            if (imgView && !imgView.image) {
//                                imgView.image = playerView.coverImgView.image;
//                            }
//                        }];
//                        [playerView.player snapShot];
//                    }
//                }
//            }
            
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

@end
