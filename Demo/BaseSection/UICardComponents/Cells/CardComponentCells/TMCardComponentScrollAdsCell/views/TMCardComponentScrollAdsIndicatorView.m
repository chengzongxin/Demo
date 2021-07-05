//
//  TMCardComponentScrollAdsIndicatorView.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/10/30.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentScrollAdsIndicatorView.h"

@interface TMCardComponentScrollAdsIndicatorView ()

@property (nonatomic, strong)UIView *indicatorView;
@property (nonatomic, assign)CGFloat progress;
@end

@implementation TMCardComponentScrollAdsIndicatorView

- (void)setIndicatorWidth:(CGFloat)indicatorWidth {
    _indicatorWidth = indicatorWidth;
    [self updateIndicatorViewFrame];
}

#pragma mark - THKViewProtocol

// 绑定View和ViewModel
- (void)bindViewModel {}

// View布局操作
- (void)thk_setupViews {
    [super thk_setupViews];
    self.clipsToBounds = YES;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.layer.cornerRadius = 1.5;
    _indicatorWidth = 15;
    _progress = 0;
    
    [self addSubview:self.indicatorView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateIndicatorViewFrame];
}

- (void)updateIndicatorViewFrame {
    if (!_indicatorView) {return;}
    
    CGRect rt = self.bounds;
    rt.origin.x = self.progress * (rt.size.width - self.indicatorWidth);
    rt.size.width = self.indicatorWidth;
    self.indicatorView.frame = rt;
}

#pragma mark - Public

- (void)updateIndicatorProgress:(CGFloat)progress animate:(BOOL)animate {
    if (progress < 0) {progress = 0;}
    if (progress > 1) {progress = 1;}
    self.progress = progress;
    
    if (animate) {
        [UIView animateWithDuration:0.15 animations:^{
            [self updateIndicatorViewFrame];
        }];
    }else {
        [self updateIndicatorViewFrame];
    }
}

#pragma mark - lazy

- (UIView *)indicatorView {
    if (!_indicatorView) {
        CGRect rt = self.bounds;
        rt.size.width = self.indicatorWidth;
        _indicatorView = [[UIView alloc] initWithFrame:rt];
        _indicatorView.clipsToBounds = YES;
        _indicatorView.backgroundColor = [UIColor whiteColor];
        _indicatorView.layer.cornerRadius = 1.5;
    }    
    return _indicatorView;
}

@end
