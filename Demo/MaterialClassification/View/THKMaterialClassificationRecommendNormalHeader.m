//
//  THKMaterialClassificationViewNormalHeader.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKMaterialClassificationRecommendNormalHeader.h"
#import "THKMaterialTitleRankView.h"

@interface THKMaterialClassificationRecommendNormalHeader ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) THKMaterialTitleRankView *rankView;

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation THKMaterialClassificationRecommendNormalHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitalize];
    }
    return self;
}

- (void)didInitalize{
    [self addSubview:self.imgView];
    [self addSubview:self.rankView];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.moreButton];
    @weakify(self);
    [self tmui_addSingerTapWithBlock:^{
        @strongify(self);
        !self.tapMoreBlock ?: self.tapMoreBlock();
    }];
    
    [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(25);
        make.height.mas_equalTo(19);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(39);
        make.left.mas_equalTo(25);
        make.right.equalTo(self.moreButton.mas_left).inset(20);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(33);
        make.right.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(44, 27));
    }];
}

- (void)moreButtonClick:(UIButton *)sender{
    !self.tapMoreBlock ?: self.tapMoreBlock();
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle{
    
//    [self.rankView setText:@"冰箱推荐榜"];
    [self.rankView setText:title];
    self.subtitleLabel.text = subtitle;
}




- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20, self.height)];
        [_imgView tmui_cornerDirect:UIRectCornerTopLeft|UIRectCornerTopRight radius:8];
        _imgView.image = UIImageMake(@"bg_goods_header");
    }
    return _imgView;
}

- (THKMaterialTitleRankView *)rankView{
    if (!_rankView) {
        _rankView = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleGold_NoCrown titleFont:UIFontMedium(10)];
    }
    return _rankView;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = UIColor.whiteColor;
        _subtitleLabel.font = UIFont(18);
    }
    return _subtitleLabel;
}

- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        _moreButton.backgroundColor = [UIColorHex(#1A1C1A) colorWithAlphaComponent:0.2];
        _moreButton.tmui_image = [UIImage tmui_imageWithShape:TMUIImageShapeDisclosureIndicator size:CGSizeMake(5, 8) tintColor:UIColor.whiteColor];
        _moreButton.layer.cornerRadius = 13.5;
        _moreButton.layer.masksToBounds = YES;
        [_moreButton tmui_addTarget:self action:@selector(moreButtonClick:)];
    }
    return _moreButton;
}



@end
