//
//  THKViewController+THKLoadingAnimationView.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKViewController+THKLoadingAnimationView.h"
#import "THKCaseDetailLoadingAnimationView.h"
#import "THKDiaryDetailLoadingAnimationView.h"
#import "THKUGCGraphicDetailLoadingAnimationView.h"

@implementation THKViewController (THKLoadingAnimationView)

- (THKLoadingAnimationView *)loadingAnimationView {
    return objc_getAssociatedObject(self, @selector(loadingAnimationView));
}

- (void)setLoadingAnimationView:(THKLoadingAnimationView *)loadingAnimationView {
    objc_setAssociatedObject(self, @selector(loadingAnimationView), loadingAnimationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)addLoadingAnimationView:(THKLoadingAnimationViewStyle)style insets:(UIEdgeInsets)insets {
    
    THKLoadingAnimationView *loadingView = [[THKLoadingAnimationView alloc] init];

    switch (style) {
        case THKLoadingAnimationViewStyleNone:
            return;
            break;
        case THKLoadingAnimationViewStyleCaseDetail:
            loadingView = [[THKCaseDetailLoadingAnimationView alloc] init];
            break;
        case THKLoadingAnimationViewStyleDiaryDetail:
            loadingView = [[THKDiaryDetailLoadingAnimationView alloc] init];
            break;
        case THKLoadingAnimationViewStyleUGCGraphicDetail:
            loadingView = [[THKUGCGraphicDetailLoadingAnimationView alloc] init];
            break;
        default:
            break;
    }
    
    
    [self.view addSubview:loadingView];
    
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(insets);
    }];
    
    [self.view bringSubviewToFront:loadingView];
    self.loadingAnimationView = loadingView;
}

- (void)removeLoadingAnimationView {
//    if (self.loadingAnimationView) {
//        [self.loadingAnimationView removeFromSuperview];
//    }
    [self removeLoadingAnimationView:YES];
}

- (void)removeLoadingAnimationView:(BOOL)animation {
    if (!self.loadingAnimationView) {
        return;
    }
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.loadingAnimationView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.loadingAnimationView removeFromSuperview];
        }];
    } else {
        [self.loadingAnimationView removeFromSuperview];
    }
}

@end
