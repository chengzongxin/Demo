//
//  THKDecPKSrcollCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/23.
//

#import "THKDecPKSrcollCell.h"


@implementation THKDecPKSrcollCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.iconImgV1];
    [self.contentView addSubview:self.titleLbl1];
    [self.contentView addSubview:self.iconImgV2];
    [self.contentView addSubview:self.titleLbl2];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.iconImgV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(42);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.titleLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgV1.mas_bottom).offset(5);
        make.centerX.equalTo(self.iconImgV1);
    }];
    
    [self.iconImgV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.mas_equalTo(-32);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.titleLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgV2.mas_bottom).offset(5);
        make.centerX.equalTo(self.iconImgV2);
    }];
}

- (void)setModel1:(THKDecPKCompanyModel *)model1 model2:(THKDecPKCompanyModel *)model2 {
    
    [self.iconImgV1 setImageWithURL:[NSURL URLWithString:model1.authorAvatar] options:0];
    self.titleLbl1.text = model1.authorName;
    
    [self.iconImgV2 setImageWithURL:[NSURL URLWithString:model2.authorAvatar] options:0];
    self.titleLbl2.text = model2.authorName;
}

- (void)setModel:(NSArray<THKDecPKCompanyModel *> *)model{
    _model = model;
    [self setModel1:model.firstObject model2:model.lastObject];
}
//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//
//    if (selected) {
//        self.containerView.backgroundColor = UIColorGreen;
//        self.titleLbl.textColor = UIColorWhite;
//        self.titleLbl.font = UIFontMedium(14);
//        self.numImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"dec_todo_%02ld",(long)self.indexPath.item + 1]];
//    }else{
//        self.containerView.backgroundColor = UIColorWhite;
//        self.titleLbl.textColor = UIColorPlaceholder;
//        self.titleLbl.font = UIFont(14);
//        self.numImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"dec_todo_%02ld_black",(long)self.indexPath.item + 1]];
//    }
//}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"dec_pk_cell_bg"];
        _bgImageView.layer.cornerRadius = 8;
        _bgImageView.layer.masksToBounds = YES;
    }
    return _bgImageView;
}

- (UIImageView *)iconImgV1{
    if (!_iconImgV1) {
        _iconImgV1 = [[UIImageView alloc] init];
        _iconImgV1.layer.cornerRadius = 24;
        _iconImgV1.layer.masksToBounds = YES;
    }
    return _iconImgV1;
}

- (UILabel *)titleLbl1{
    if (!_titleLbl1) {
        _titleLbl1 = [[UILabel alloc] init];
        _titleLbl1.textAlignment = NSTextAlignmentCenter;
        _titleLbl1.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _titleLbl1.textColor = UIColorHexString(@"333533");
    }
    return _titleLbl1;
}

- (UIImageView *)iconImgV2{
    if (!_iconImgV2) {
        _iconImgV2 = [[UIImageView alloc] init];
        _iconImgV2.layer.cornerRadius = 24;
        _iconImgV2.layer.masksToBounds = YES;
    }
    return _iconImgV2;
}

- (UILabel *)titleLbl2{
    if (!_titleLbl2) {
        _titleLbl2 = [[UILabel alloc] init];
        _titleLbl2.textAlignment = NSTextAlignmentCenter;
        _titleLbl2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _titleLbl2.textColor = UIColorHexString(@"333533");
    }
    return _titleLbl2;
}
@end
