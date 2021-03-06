//
//  THKMaterialHotRankHeader.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKMaterialHotRankHeader.h"

@interface THKMaterialHotRankHeader ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) TMUIButton *moreButton;


@end

@implementation THKMaterialHotRankHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitalize];
    }
    return self;
}

- (void)didInitalize{
    [self addSubview:self.titleLabel];
    [self addSubview:self.moreButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(25);
        make.right.equalTo(self.moreButton.mas_left).inset(20);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(66, 20));
    }];
}

- (void)moreButtonClick:(UIButton *)sender{
    !self.tapMoreBlock ?: self.tapMoreBlock();
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorHex(#1A1C1A);
        _titleLabel.font = UIFontSemibold(18);
    }
    return _titleLabel;
}

- (TMUIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[TMUIButton alloc] init];
        _moreButton.imagePosition = TMUIButtonImagePositionRight;
        _moreButton.tmui_image = UIImageMake(@"icon_material_arrow");
        _moreButton.spacingBetweenImageAndTitle = 5;
        _moreButton.tmui_text = @"全部品牌";
        _moreButton.tmui_font = [UIFont systemFontOfSize:12];
        _moreButton.tmui_titleColor = UIColorHex(#1A1C1A);
        [_moreButton tmui_addTarget:self action:@selector(moreButtonClick:)];
    }
    return _moreButton;
}

@end
