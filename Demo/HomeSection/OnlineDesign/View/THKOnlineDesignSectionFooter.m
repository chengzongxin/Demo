//
//  THKOnlineDesignSectionFooter.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/15.
//

#import "THKOnlineDesignSectionFooter.h"

@interface THKOnlineDesignSectionFooter ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation THKOnlineDesignSectionFooter


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.right.equalTo(self).inset(20);
        make.height.mas_equalTo(50);
    }];
}

- (UIButton *)button{
    if (!_button) {
        _button = [TMUIButton tmui_button];
        _button.backgroundColor = UIColorGreen;
        _button.tmui_titleColor = UIColorWhite;
        _button.cornerRadius = 8;
        _button.tmui_font = UIFontMedium(18);
        _button.tmui_text = @"提交获取我家方案";
        @weakify(self);
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.commitClickBlock) {
                self.commitClickBlock(x);
            }
        }];
    }
    return _button;
}

@end
