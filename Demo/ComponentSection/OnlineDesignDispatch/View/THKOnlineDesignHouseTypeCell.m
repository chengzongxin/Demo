//
//  THKOnlineDesignHouseTypeCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseTypeCell.h"
#import "THKOnlineDesignModel.h"

@interface THKOnlineDesignHouseTypeCell ()

@property (nonatomic, strong) UIImageView *picImgV;

@property (nonatomic, strong) UILabel *areaLbl;

@property (nonatomic, strong) UILabel *typeLbl;

@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation THKOnlineDesignHouseTypeCell

- (void)setupSubviews{
    self.contentView.backgroundColor = UIColorHex(F1F2F3);
    self.contentView.cornerRadius = 8;
    [self.contentView addSubview:self.picImgV];
    [self.contentView addSubview:self.areaLbl];
    [self.contentView addSubview:self.typeLbl];
    [self.contentView addSubview:self.editBtn];
    
    [self.picImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(75, 60));
    }];
    
    [self.areaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picImgV.mas_right).offset(15).priorityHigh();
        make.top.mas_equalTo(15);
    }];
    
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaLbl.mas_bottom).offset(7);
        make.left.equalTo(self.areaLbl);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
}

- (void)bindWithModel:(THKOnlineDesignItemHouseTypeModel *)model{
    [super bindWithModel:model];
    
    if (model.planImgList.firstObject.imgUrl.length) {
        
        [self.picImgV loadImageWithUrlStr:model.planImgList.firstObject.imgUrl];
        
        [self.areaLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.picImgV.mas_right).offset(15);
        }];
    }else{
        [self.areaLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
        }];
    }
    self.areaLbl.text = model.houseArea;
    self.typeLbl.text = [NSString stringWithFormat:@"%ld㎡·%@",(long)model.buildArea,model.houseType];
}

- (UIImageView *)picImgV{
    if (!_picImgV) {
        _picImgV = [[UIImageView alloc] init];
        _picImgV.cornerRadius = 6;
    }
    return _picImgV;
}

- (UILabel *)areaLbl{
    if (!_areaLbl) {
        _areaLbl = [UILabel new];
        _areaLbl.font = UIFontSemibold(18);
        _areaLbl.textColor = UIColorDark;
    }
    return _areaLbl;
}

- (UILabel *)typeLbl{
    if (!_typeLbl) {
        _typeLbl = [UILabel new];
        _typeLbl.font = UIFont(14);
        _typeLbl.textColor = UIColorPlaceholder;
    }
    return _typeLbl;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton tmui_button];
        _editBtn.tmui_image = UIImageMake(@"od_house_edit");
        @weakify(self);
        [_editBtn tmui_addActionBlock:^(NSInteger tag) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(houseTypeEditClick:indexPath:)]) {
                [self.delegate houseTypeEditClick:self.editBtn indexPath:self.indexPath];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}


@end
