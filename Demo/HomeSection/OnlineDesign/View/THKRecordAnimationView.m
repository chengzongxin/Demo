//
//  THKRecordAnimationView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/17.
//

#import "THKRecordAnimationView.h"
#import <Lottie/Lottie.h>

@interface THKRecordAnimationView ()



@property (nonatomic, strong) UILabel *titleLbl;


@property (nonatomic, strong) LOTAnimationView *recordAnimationView;

@end

@implementation THKRecordAnimationView


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
    [self addSubview:self.titleLbl];
    [self addSubview:self.recordAnimationView];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(477);
        make.centerX.equalTo(self);
    }];
    
    [self.recordAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(578);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(187, 48));
    }];
}

- (void)playInView:(UIView *)view{
    self.frame = view.bounds;
    [view addSubview:self];
    [self.recordAnimationView play];
}

- (void)stop{
    [self.recordAnimationView stop];
    [self removeFromSuperview];
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorWhite;
        _titleLbl.font = UIFont(14);
        _titleLbl.text = @"松手发送，上划取消";
    }
    return _titleLbl;
}

- (LOTAnimationView *)recordAnimationView{
    if (!_recordAnimationView) {
        _recordAnimationView = [LOTAnimationView animationNamed:@"lot_online_design_record"];
        _recordAnimationView.backgroundColor = UIColorGreen;
        _recordAnimationView.cornerRadius = 24;
        _recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        _recordAnimationView.clipsToBounds = YES;
        _recordAnimationView.loopAnimation = YES;
    }
    return _recordAnimationView;
}

@end
