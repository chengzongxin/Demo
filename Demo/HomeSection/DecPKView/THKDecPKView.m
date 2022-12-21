//
//  THKDecPKView.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import "THKDecPKView.h"
#import "THKDecPKSrcollView.h"
#import "FLRadarChartView.h"
@interface THKDecPKView ()

@property (nonatomic, strong) THKDecPKViewModel *viewModel;

@property (nonatomic, strong) UIImageView *topBgImgV;
@property (nonatomic, strong) UILabel *firstTitle;
@property (nonatomic, strong) UIButton *firstButtonTip;
@property (nonatomic, strong) UIImageView *firstContentImgV;
@property (nonatomic, strong) UILabel *secondTitle;
@property (nonatomic, strong) UIButton *secondButtonTip;
@property (nonatomic, strong) THKDecPKSrcollView *pkView;
@property (nonatomic, strong) FLRadarChartView *radarView;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UIButton *bottomTipBtn;
//secondContent : [
//    decName
//    decIcon
//    score(text)
//    caseNum(text)
//    consultNum(text)
//]
//bigButtonTip(router)
//bottomTipIcon
//bottomTip(router)


@end

@implementation THKDecPKView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    [self addSubview:self.topBgImgV];
    [self addSubview:self.firstTitle];
    [self addSubview:self.firstButtonTip];
    [self addSubview:self.firstContentImgV];
    [self addSubview:self.secondTitle];
    [self addSubview:self.secondButtonTip];
    [self addSubview:self.pkView];
    [self addSubview:self.radarView];
    [self addSubview:self.bottomButton];
    [self addSubview:self.bottomTipBtn];
    
    [self.topBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.topBgImgV.image.size.height / self.topBgImgV.image.size.width * (UIScreen.mainScreen.bounds.size.width - 40));
    }];
    
    [self.firstTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(22);
    }];
    
    [self.firstButtonTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.firstTitle);
        make.right.mas_equalTo(-15);
    }];
    
    [self.firstContentImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTitle.mas_bottom).offset(15);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(36);
    }];
    
    [self.secondTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstContentImgV.mas_bottom).offset(18);
        make.left.mas_equalTo(16);
    }];
    
    [self.secondButtonTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.secondTitle);
        make.right.mas_equalTo(-15);
    }];
    
    [self.pkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondTitle.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    [self.radarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pkView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(241);
    }];
    
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.radarView.mas_bottom);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(50);
    }];
    
    [self.bottomTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomButton.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
}

- (void)bindViewModel:(THKDecPKViewModel *)viewModel{
    self.viewModel = viewModel;
    
    self.firstTitle.text = viewModel.firstTitle;
    [self.firstButtonTip setTitle:viewModel.firstButtonTip forState:UIControlStateNormal];
    [self.firstContentImgV setImageWithURL:[NSURL URLWithString:viewModel.firstContentImgUrl] placeholder:[UIImage imageNamed:@"dec_pk_flow_img"]];
    self.secondTitle.text = viewModel.secondTitle;
    [self.secondButtonTip setTitle:viewModel.secondButtonTip forState:UIControlStateNormal];
    
    self.pkView.model = viewModel.secondContent;
    self.radarView.dataArray = viewModel.secondContent;
    
    [self.bottomButton setTitle:viewModel.bigButtonTip forState:UIControlStateNormal];
    [self.bottomTipBtn setTitle:viewModel.bottomTip forState:UIControlStateNormal];
}


#pragma mark - Getter
- (UIImageView *)topBgImgV{
    if (!_topBgImgV) {
        _topBgImgV = [[UIImageView alloc] init];
        _topBgImgV.image = [UIImage imageNamed:@"dec_pk_card_bg"];
    }
    return _topBgImgV;
}

- (UILabel *)firstTitle{
    if (!_firstTitle) {
        _firstTitle = [[UILabel alloc] init];
        _firstTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _firstTitle.textColor = UIColorHexString(@"111111");
    }
    return _firstTitle;
}

- (UIButton *)firstButtonTip{
    if (!_firstButtonTip) {
        _firstButtonTip = [[UIButton alloc] init];
        _firstButtonTip.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [_firstButtonTip setImage:[UIImage imageNamed:@"dec_pk_arrow"] forState:UIControlStateNormal];
        _firstButtonTip.titleLabel.font = [UIFont systemFontOfSize:12];
        [_firstButtonTip setTitleColor:UIColorHexString(@"333533") forState:UIControlStateNormal];
    }
    return _firstButtonTip;
}

- (UIImageView *)firstContentImgV{
    if (!_firstContentImgV) {
        _firstContentImgV = [[UIImageView alloc] init];
        _firstContentImgV.image = [UIImage imageNamed:@"dec_pk_flow_img"];
    }
    return _firstContentImgV;
}

- (UILabel *)secondTitle{
    if (!_secondTitle) {
        _secondTitle = [[UILabel alloc] init];
        _secondTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _secondTitle.textColor = UIColorHexString(@"111111");
    }
    return _secondTitle;
}

- (UIButton *)secondButtonTip{
    if (!_secondButtonTip) {
        _secondButtonTip = [[UIButton alloc] init];
        _secondButtonTip.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [_secondButtonTip setImage:[UIImage imageNamed:@"dec_pk_arrow"] forState:UIControlStateNormal];
        _secondButtonTip.titleLabel.font = [UIFont systemFontOfSize:12];
        [_secondButtonTip setTitleColor:UIColorHexString(@"333533") forState:UIControlStateNormal];
    }
    return _secondButtonTip;
}

- (THKDecPKSrcollView *)pkView{
    if (!_pkView) {
        _pkView = [[THKDecPKSrcollView alloc] init];
    }
    return _pkView;
}

- (FLRadarChartView *)radarView{
    if (!_radarView) {
        _radarView = [[FLRadarChartView alloc] init];
    }
    return _radarView;
}

- (UIButton *)bottomButton{
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] init];
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"dec_pk_btn_bg"] forState:UIControlStateNormal];
    }
    return _bottomButton;
}

- (UIButton *)bottomTipBtn{
    if (!_bottomTipBtn) {
        _bottomTipBtn = [[UIButton alloc] init];
        _bottomTipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_bottomTipBtn setTitleColor:UIColorHexString(@"AFB2AF") forState:UIControlStateNormal];
    }
    return _bottomTipBtn;
}


@end
