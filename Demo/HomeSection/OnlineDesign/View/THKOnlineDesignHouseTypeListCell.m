//
//  THKOnlineDesignHouseTypeListCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/15.
//

#import "THKOnlineDesignHouseTypeListCell.h"

@interface THKOnlineDesignHouseTypeListCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation THKOnlineDesignHouseTypeListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.imgV];
    [self.contentView addSubview:self.titleLbl];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(self.mas_width);
    }];
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(8);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)setModel:(THKOnlineDesignHouseListItemModel *)model{
    _model = model;
    
    [self.imgV loadImageWithUrlStr:model.image];
    self.titleLbl.text = [NSString stringWithFormat:@"%.0f㎡·%@",model.building_area.floatValue,model.structure];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = UIColorBackgroundLight;
        _bgView.cornerRadius = 8;
    }
    return _bgView;
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [UIImageView new];
    }
    return _imgV;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFont(14);
        _titleLbl.text = @"52㎡·2室1厅";
    }
    return _titleLbl;
}

@end
