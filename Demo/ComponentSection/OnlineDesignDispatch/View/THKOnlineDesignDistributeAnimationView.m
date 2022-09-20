//
//  THKOnlineDesignDistributeAnimationView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/18.
//

#import "THKOnlineDesignDistributeAnimationView.h"
#import <Lottie/Lottie.h>

@interface THKOnlineDesignDistributeAnimationView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) LOTAnimationView *loadingAnimationView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;


@end


@implementation THKOnlineDesignDistributeAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = [UIColorBlack colorWithAlphaComponent:0.6];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.loadingAnimationView];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.subtitleLbl];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    [self.loadingAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(160, 160));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadingAnimationView.mas_bottom).offset(18);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
    }];
}

- (void)playInView:(UIView *)view{
    self.frame = view.bounds;
    [view addSubview:self];
    [self.loadingAnimationView play];
}

- (void)stop{
    [self.loadingAnimationView stop];
    [self removeFromSuperview];
}


- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColorWhite;
        _contentView.cornerRadius = 16;
    }
    return _contentView;
}

- (LOTAnimationView *)loadingAnimationView{
    if (!_loadingAnimationView) {
        _loadingAnimationView = [LOTAnimationView animationNamed:@"lot_online_design_distribute"];
        _loadingAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        _loadingAnimationView.clipsToBounds = YES;
        _loadingAnimationView.loopAnimation = YES;
    }
    return _loadingAnimationView;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFontSemibold(18);
        _titleLbl.text = @"正在为你分派设计师";
    }
    return _titleLbl;
}


- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        _subtitleLbl.textColor = UIColorPlaceholder;
        _subtitleLbl.font = UIFont(14);
        _subtitleLbl.text = @"请稍等片刻";
    }
    return _subtitleLbl;
}


@end
