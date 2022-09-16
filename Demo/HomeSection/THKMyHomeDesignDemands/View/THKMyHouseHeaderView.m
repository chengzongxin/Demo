//
//  THKMyHouseHeaderView.m
//  HouseKeeper
//
//  Created by collen.zhang on 2020/4/8.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKMyHouseHeaderView.h"
//#import "THKUtilityView.h"
@interface THKMyHouseHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *radiusLineView;
@end
@implementation THKMyHouseHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)thk_setupViews{
//    CGFloat top = kTNavigationBarHeight();
    [self addSubview:self.mainView];
    [self addSubview:self.radiusLineView];
    [self.mainView addSubview:self.titleLabel];
    [self.mainView addSubview:self.detailLabel];
    [self.mainView addSubview:self.logoImageView];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(88);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(84, 82));
        make.top.mas_equalTo(6);
        make.right.mas_equalTo(-26);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(8);
        make.height.mas_equalTo(30);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).mas_equalTo(4);
        make.left.mas_equalTo(8);
//        make.height.mas_equalTo(20);
    }];
    
    [self.radiusLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    self.backgroundColor = [UIColor clearColor];
}

+(CGFloat)viewHeight{
    return 108;
}

-(void)setViewTopRadius{
    [self.radiusLineView layoutIfNeeded];
    self.radiusLineView.backgroundColor = THKColor_FFFFFF;
    [self.radiusLineView tmui_cornerDirect:UIRectCornerTopLeft|UIRectCornerTopRight radius:8];
}


- (UIView *)radiusLineView{
    if (!_radiusLineView) {
        _radiusLineView = [[UIView alloc] init];
    }
    return _radiusLineView;
}
- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
    }
    return _mainView;
}
-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"im_mycollection_icon"];
    }
    return _logoImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我家设计需求卡";
        _titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
        _titleLabel.textColor = THKColor_TextImportantColor;
        
    }
    return _titleLabel;
}

-(UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.text = @"有效提高与设计师沟通效率\n可随时修改信息";
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _detailLabel.textColor = THKColor_TextWeakColor;
        [_detailLabel tmui_setAttributeslineSpacing:5];
    }
    return _detailLabel;
}
@end
