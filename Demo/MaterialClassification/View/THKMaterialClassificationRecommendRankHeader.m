//
//  THKMaterialClassificationViewRankHeader.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKMaterialClassificationRecommendRankHeader.h"
#import "THKMaterialTitleRankView.h"

@interface THKMaterialClassificationRecommendRankHeader ()

@property (nonatomic, strong) THKMaterialTitleRankView *rankView;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation THKMaterialClassificationRecommendRankHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitalize];
    }
    return self;
}

- (void)didInitalize{
    [self addSubview:self.rankView];
    [self addSubview:self.moreButton];
    
    [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);
        make.left.mas_equalTo(25);
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


- (void)setTitle:(NSString *)title{
    [self.rankView setText:title];
}

- (THKMaterialTitleRankView *)rankView{
    if (!_rankView) {
        _rankView = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleBlue titleFont:UIFont(19)];
    }
    return _rankView;
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
