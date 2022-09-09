//
//  THKAssignFinishWeChatView.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/9.
//

#import "THKAssignFinishWeChatView.h"

static CGFloat const kOriX = 24;

@interface THKAssignFinishWeChatView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, assign) BOOL isFold;

@property (nonatomic, assign) BOOL isAnimationPlaying;

@end

@implementation THKAssignFinishWeChatView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.contentView];
    [self addSubview:self.titleLbl];
    [self addSubview:self.icon];
    
    _isFold = NO;
    _text = @"加微关注方案进度";
    _titleLbl.text = _text;
    
    CGRect frame = CGRectMakeWithSize([self contentSize]);
    frame.origin.x = kOriX;
    self.contentView.frame = frame;
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_equalTo(-50);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_equalTo(-12);
    }];
    
}

- (void)fold{
    if (self.isAnimationPlaying) {
        return;
    }
    
    if (self.isFold == YES) {
        return;
    }
    
    self.isFold = YES;
    self.isAnimationPlaying = YES;
    self.text = @"方案进度";
}

- (void)unfold{
    if (self.isAnimationPlaying) {
        return;
    }
    
    if (self.isFold == NO) {
        return;
    }
    
    self.isFold = NO;
    self.isAnimationPlaying = YES;
    self.text = @"加微关注方案进度";
}

- (void)setText:(NSString *)text{
    _text = text;
    
    CGFloat contenW = [self contentSize].width;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.titleLbl.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.titleLbl.alpha = 1;
            self.titleLbl.text = self.text;
        } completion:^(BOOL finished) {
        }];
    }];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:10 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.titleLbl.alpha = 0.2;
        self.contentView.x = self.contentView.width - contenW + kOriX;
        self.contentView.width = contenW;
    } completion:^(BOOL finished) {
        self.contentView.x = kOriX;
        [self invalidateIntrinsicContentSize];
        self.isAnimationPlaying = NO;
    }];
}

- (CGSize)intrinsicContentSize{
    return [self contentSize];
}

- (CGSize)contentSize{
    CGFloat width = [self.text tmui_sizeWithFont:self.titleLbl.font width:CGFLOAT_MAX].width;
    return CGSizeMake(width + 22 + 50 + 22, 48);
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColorWhite;
        _contentView.cornerRadius = 24;
    }
    return _contentView;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFont(14);
        _titleLbl.textColor = UIColorDark;
        _titleLbl.text = @"多位设计师免费出图";
    }
    return _titleLbl;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:UIImageMake(@"assign_finish_wechat")];
    }
    return _icon;
}

@end
