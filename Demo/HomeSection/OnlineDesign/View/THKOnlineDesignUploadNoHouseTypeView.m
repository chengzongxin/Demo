//
//  THKOnlineDesignUploadNoHouseTypeView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignUploadNoHouseTypeView.h"

@interface THKOnlineDesignUploadNoHouseTypeView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;

@end

@implementation THKOnlineDesignUploadNoHouseTypeView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = UIColorWhite;
    [self addSubview:self.bgView];
    [self addSubview:self.button];
    [self addSubview:self.titleLbl];
    [self addSubview:self.subtitleLbl];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 45));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button.mas_right).offset(28);
        make.top.mas_equalTo(19);
    }];
    
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(6);
        make.left.equalTo(self.titleLbl);
    }];
    
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.borderColor = UIColorBackgroundLight;
        _bgView.borderWidth = 3;
        _bgView.layer.cornerRadius = 8;
        @weakify(self);
        [_bgView tmui_addSingerTapWithBlock:^{
            @strongify(self);
            if (self.clickUploadBlock) {
                self.clickUploadBlock();
            }
        }];
    }
    return _bgView;
}

- (UIButton *)button{
    if (!_button) {
        _button = [TMUIButton tmui_button];
        _button.backgroundColor = UIColorBackgroundLight;
        _button.cornerRadius = 6;
        _button.tmui_image = UIImageMake(@"od_house_search_icon");
        @weakify(self);
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.clickUploadBlock) {
                self.clickUploadBlock();
            }
        }];
    }
    return _button;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.text = @"找不到我家的户型图？";
        _titleLbl.textColor = UIColorWeak;
        _titleLbl.font = UIFont(14);
    }
    return _titleLbl;
}

- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        _subtitleLbl.textColor = UIColorGreen;
        _subtitleLbl.font = UIFontMedium(14);
        _subtitleLbl.text = @"填写我家信息";
    }
    return _subtitleLbl;
}



@end
