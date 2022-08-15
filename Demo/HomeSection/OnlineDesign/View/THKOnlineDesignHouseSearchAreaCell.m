//
//  THKOnlineDesignHouseSearchAreaCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKOnlineDesignHouseSearchAreaCell.h"

@interface THKOnlineDesignHouseSearchAreaCell ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation THKOnlineDesignHouseSearchAreaCell

- (void)setupSubviews{
    [self.contentView addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIButton *)button{
    if (!_button) {
        _button = [TMUIButton tmui_button];
        _button.backgroundColor = UIColorGreen;
        _button.tmui_titleColor = UIColorWhite;
        _button.cornerRadius = 8;
        _button.tmui_font = UIFontMedium(18);
        _button.tmui_text = @"搜索我家小区";
        @weakify(self);
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(searchAreaBtnClick:)]) {
                [self.delegate searchAreaBtnClick:x];
            }
        }];
    }
    return _button;
}

@end
