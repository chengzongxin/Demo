//
//  THKPKPlanDetailReceivePlanView.m
//  Demo
//
//  Created by Joe.cheng on 2023/8/21.
//

#import "THKPKPlanDetailReceivePlanView.h"

@interface THKPKPlanDetailReceivePlanView ()



@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation THKPKPlanDetailReceivePlanView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self tmui_cornerDirect:UIRectCornerTopLeft | UIRectCornerTopRight radius:12];
}

- (void)btnClick:(UIButton *)btn{
    !_tapBtn?:_tapBtn(btn);
}

- (void)clickCloseBtn:(UIButton *)btn{
    !_tapCloseBtn?:_tapCloseBtn(btn);
}

- (void)setupView{
    [self addSubview:self.btn];
    [self addSubview:self.titleLbl];
    [self addSubview:self.closeBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.right.equalTo(self).inset(48);
        make.height.mas_equalTo(48);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn.mas_bottom).offset(7);
        make.centerX.equalTo(self);
    }];
    
    
}

- (UIButton *)btn {
    if(!_btn) {
        _btn = [UIButton tmui_button];
        _btn.backgroundColor = UIColorGreen;
        _btn.tmui_text = @"免费领取我家PK方案";
        _btn.tmui_titleColor = UIColorWhite;
        _btn.titleLabel.font = UIFontMedium(14);
        _btn.cornerRadius = 10;
        [_btn tmui_addTarget:self action:@selector(btnClick:)];
    }
    return _btn;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFont(12);
        _titleLbl.textColor = UIColorPlaceholder;
        _titleLbl.text =@"允许平台致电为您提供设计服务";
    }
    return _titleLbl;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton tmui_button];
        _closeBtn.tmui_image = UIImageMake(@"present_close_black");
        [_closeBtn tmui_addTarget:self action:@selector(clickCloseBtn:)];
    }
    return _closeBtn;
}

@end
