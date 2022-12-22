//
//  THKDecPKSmallView.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/22.
//

#import "THKDecPKSmallView.h"

@interface THKDecPKSmallView ()

@property (nonatomic, strong) UIImageView *bkImgV;

@property (nonatomic, strong) UILabel *label1;

@property (nonatomic, strong) UILabel *label2;

@property (nonatomic, strong) UILabel *label3;

@end

@implementation THKDecPKSmallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.bkImgV];
    [self addSubview:self.label1];
    [self addSubview:self.label2];
    [self addSubview:self.label3];
    
    [self.bkImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
    }];
}

- (void)setTexts:(NSArray<NSString *> *)texts{
    _texts = texts;
    
    self.label1.text = [texts safeObjectAtIndex:0];
    self.label2.text = [texts safeObjectAtIndex:1];
    self.label3.text = [texts safeObjectAtIndex:2];
}


- (UIImageView *)bkImgV{
    if (!_bkImgV) {
        _bkImgV = [[UIImageView alloc] init];
        _bkImgV.image = [UIImage imageNamed:@"dec_pk_small_bg"];
    }
    return _bkImgV;
}

- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.textColor = UIColorHexString(@"333533");
        _label1.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    }
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.textColor = UIColorHexString(@"333533");
        _label2.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    }
    return _label2;
}

- (UILabel *)label3 {
    if (!_label3) {
        _label3 = [[UILabel alloc] init];
        _label3.textColor = UIColorHexString(@"333533");
        _label3.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    }
    return _label3;
}

@end
