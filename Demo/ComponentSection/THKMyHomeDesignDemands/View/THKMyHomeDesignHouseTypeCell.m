//
//  THKMyHomeDesignHouseTypeCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/16.
//

#import "THKMyHomeDesignHouseTypeCell.h"

@interface THKMyHomeDesignHouseTypeCell ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *communityLbl;

@property (nonatomic, strong) UILabel *houseTypeLbl;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIView *line;

@end

@implementation THKMyHomeDesignHouseTypeCell


- (void)setupSubviews{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.communityLbl];
    [self.contentView addSubview:self.houseTypeLbl];
    [self.contentView addSubview:self.arrowImageView];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
    }];
    
    [self.communityLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_right).offset(24);
        make.centerY.equalTo(self.titleLbl);
    }];
    
    [self.houseTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.communityLbl);
        make.top.equalTo(self.communityLbl.mas_bottom).offset(8);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.right.mas_equalTo(-16);
        make.centerY.equalTo(self.titleLbl);
    }];
    
    self.tmui_borderPosition = TMUIViewBorderPositionBottom;
    self.tmui_borderColor = UIColorBackgroundGray;
    self.tmui_dashPhase = 2;
    self.tmui_borderWidth = 1;
    self.tmui_dashPattern = @[@2,@2];
    
    @weakify(self);
    [self.contentView tmui_addSingerTapWithBlock:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(editCell:type:model:data:)]) {
            [self.delegate editCell:self type:self.model.type model:self.model data:nil];
        }
    }];
}


- (void)bindWithModel:(THKMyHomeDesignDemandsModel *)model{
    self.model = model;
    
    self.titleLbl.text = model.title;
    self.communityLbl.text = model.content;
    self.houseTypeLbl.text = model.contentDesc;
}

+ (CGFloat)cellHeightWithModel:(THKMyHomeDesignDemandsModel *)model{
    return 84;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFont(16);
    }
    return _titleLbl;
}

- (UILabel *)communityLbl{
    if (!_communityLbl) {
        _communityLbl = [UILabel new];
        _communityLbl.font = UIFontSemibold(16);
        _communityLbl.textColor = UIColorDark;
    }
    return _communityLbl;
}

- (UILabel *)houseTypeLbl{
    if (!_houseTypeLbl) {
        _houseTypeLbl = [UILabel new];
        _houseTypeLbl.font = UIFont(14);
        _houseTypeLbl.textColor = UIColorPlaceholder;
    }
    return _houseTypeLbl;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"icon_myInfo_arrow"];
    }
    return _arrowImageView;
}

@end
