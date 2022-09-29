//
//  THKValuePointIntroductionBottomButton.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/29.
//

#import "THKValuePointIntroductionBottomButton.h"

@interface THKValuePointIntroductionBottomButton ()

@property (nonatomic, strong) TMUICustomCornerRadiusView *cornerView;

@end

@implementation THKValuePointIntroductionBottomButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self thk_setupViews];
    }
    return self;
}

- (void)thk_setupViews{
    [self addSubview:self.cornerView];
    [self addSubview:self.sendButton];

    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
}

- (TMUICustomCornerRadiusView *)cornerView{
    if (!_cornerView) {
        _cornerView = [TMUICustomCornerRadiusView new];
        _cornerView.customCornerRadius = TMUICustomCornerRadiusMake(16, 16, 0, 0);
        _cornerView.backgroundColor = UIColorWhite;
    }
    return _cornerView;
}


- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"选择户型图，开始沟通需求" forState:UIControlStateNormal];
        [_sendButton setTitleColor:THKColor_FFFFFF forState:UIControlStateNormal];
        _sendButton.backgroundColor = THKColor_MainColor;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _sendButton.cornerRadius = 10;
    }
    return _sendButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.frame.size.width * self.frame.size.height) {
        [self.layer tmui_setLayerShadow:[UIColor.blackColor colorWithAlphaComponent:0.06] offset:CGSizeMake(0, -8) alpha:1 radius:10 spread:0];
    }
}


@end
