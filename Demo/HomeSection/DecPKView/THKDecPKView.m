//
//  THKDecPKView.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import "THKDecPKView.h"
#import "THKDecPKCycleView.h"
#import "FLRadarChartView.h"
#import "FLRadarChartModel.h"
#import "THKDecPKSmallView.h"

static NSInteger const kUnfoldTag = 999;
@interface THKDecPKView ()

@property (nonatomic, strong) THKDecPKViewModel *viewModel;

@property (nonatomic, strong) UIImageView *topBgImgV;
@property (nonatomic, strong) UILabel *firstTitle;
@property (nonatomic, strong) UIButton *firstButtonTip;
@property (nonatomic, strong) UIImageView *firstContentImgV;
@property (nonatomic, strong) UILabel *secondTitle;
@property (nonatomic, strong) UIButton *secondButtonTip;
@property (nonatomic, strong) THKDecPKSmallView *pkSmallView;
@property (nonatomic, strong) THKDecPKCycleView *pkView;
@property (nonatomic, strong) FLRadarChartView *radarView;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UIButton *bottomTipBtn;

@property (nonatomic, strong) NSMutableArray <UIView *> *hiddenViews;

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
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    [self addSubview:self.topBgImgV];
    [self addSubview:self.firstTitle];
    [self addSubview:self.firstButtonTip];
    [self addSubview:self.firstContentImgV];
    [self addSubview:self.secondTitle];
    [self addSubview:self.secondButtonTip];
    [self addSubview:self.pkSmallView];
    [self addSubview:self.pkView];
    [self addSubview:self.radarView];
    [self addSubview:self.bottomButton];
    [self addSubview:self.bottomTipBtn];
    
    [self.topBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        if (self.topBgImgV.image) {
            
            make.height.mas_equalTo(self.topBgImgV.image.size.height / self.topBgImgV.image.size.width * (UIScreen.mainScreen.bounds.size.width - 40));
        }else{
            
            make.height.mas_equalTo(110 / 335 * (UIScreen.mainScreen.bounds.size.width - 40));
        }
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
        make.top.mas_equalTo(110);
        make.left.mas_equalTo(16);
    }];
    
    [self.secondButtonTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.secondTitle);
        make.right.mas_equalTo(-15);
    }];
    
    [self.pkSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondTitle.mas_bottom).offset(16);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(46);
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
    
    self.pkSmallView.hidden = YES;
    [self.hiddenViews addObjectsFromArray:@[self.topBgImgV,self.firstTitle,self.firstButtonTip,self.firstContentImgV,self.pkView,self.radarView,self.bottomButton,self.bottomTipBtn]];
}

- (void)setFold:(BOOL)fold{
    if (_fold == fold) {
        return;
    }
    
    _fold = fold;
    
    [self.hiddenViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = fold;
    }];
    
    self.pkSmallView.hidden = !fold;
    
    if (fold) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(121);
        }];
        
        [self.secondTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
        }];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(584);
        }];
        
        [self.secondTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(110);
        }];
    }
    
}

- (void)bindViewModel:(THKDecPKViewModel *)viewModel{
    self.viewModel = viewModel;
    
    self.firstTitle.text = viewModel.firstTitle;
    [self.firstButtonTip setTitle:viewModel.firstButtonTip forState:UIControlStateNormal];
    [self.firstContentImgV setImageWithURL:[NSURL URLWithString:viewModel.firstContentImgUrl] placeholder:[UIImage imageNamed:@"dec_pk_flow_img"]];
    self.secondTitle.text = viewModel.secondTitle;
    [self.secondButtonTip setTitle:viewModel.secondButtonTip forState:UIControlStateNormal];
    
    self.pkView.datas = viewModel.secondContent;
    self.pkSmallView.texts = viewModel.companyTexts;
    
    [self.bottomButton setTitle:viewModel.bigButtonTip forState:UIControlStateNormal];
    [self.bottomTipBtn setTitle:viewModel.bottomTip forState:UIControlStateNormal];
}


#pragma mark - Actions

- (void)firstButtonTipClick:(UIButton *)btn{
    [self push:self.viewModel.firstButtonTipRouter];
}

- (void)secondButtonTipClick:(UIButton *)btn{
    [self push:self.viewModel.secondButtonTipRouter];
}

- (void)bottomButtonClick:(UIButton *)btn{
    [self push:self.viewModel.bigButtonTipRouter];
}

- (void)bottomTipBtnClick:(UIButton *)btn{
    [self push:self.viewModel.bottomTipRouter];
}

- (void)push:(NSString *)routerUrl{
    [[TRouterManager sharedManager] performRouter:[TRouter routerFromUrl:routerUrl]];
}

- (void)didScrollToDecs:(NSArray<THKDecPKCompanyModel *> *)models{
    THKDecPKCompanyModel *com1 = models.firstObject;
    THKDecPKCompanyModel *com2 = models.lastObject;
    
    NSArray *classifyDataArray = @[com1.goodRateText,com1.caseNumText,com1.consultantNumText];
    
    FLRadarChartModel *chartM1 = [[FLRadarChartModel alloc] init];
    chartM1.name = com1.authorName;
    chartM1.valueArray = @[@(com1.goodRate),@(com1.caseNum),@(com1.consultantNum)];
    chartM1.strokeColor = [UIColorHexString(@"FD6343") colorWithAlphaComponent:0.5];
    chartM1.fillColor = [UIColorHexString(@"FD6343") colorWithAlphaComponent:0.5];
    
    FLRadarChartModel *chartM2 = [[FLRadarChartModel alloc] init];
    chartM2.name = com2.authorName;
    chartM2.valueArray = @[@(com2.goodRate),@(com2.caseNum),@(com2.consultantNum)];;
    chartM2.strokeColor = [UIColorHexString(@"3A8EF0") colorWithAlphaComponent:0.5];
    chartM2.fillColor = [UIColorHexString(@"3A8EF0") colorWithAlphaComponent:0.5];
    
    self.radarView.classifyDataArray = classifyDataArray;
    self.radarView.dataArray = @[chartM1, chartM2];
    [self.radarView fl_redrawRadarChart];
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
        [_firstButtonTip addTarget:self action:@selector(firstButtonTipClick:) forControlEvents:UIControlEventTouchUpInside];
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
        _secondTitle.tag = kUnfoldTag;
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
        [_secondButtonTip addTarget:self action:@selector(secondButtonTipClick:) forControlEvents:UIControlEventTouchUpInside];
        _secondButtonTip.tag = kUnfoldTag;
    }
    return _secondButtonTip;
}

- (THKDecPKSmallView *)pkSmallView{
    if (!_pkSmallView) {
        _pkSmallView = [[THKDecPKSmallView alloc] init];
    }
    return _pkSmallView;
}

- (THKDecPKCycleView *)pkView{
    if (!_pkView) {
        _pkView = [[THKDecPKCycleView alloc] init];
        @weakify(self);
        _pkView.scrollCell = ^(THKDecPKCycleView * _Nonnull cycleView, NSInteger index) {
            @strongify(self);
            [self didScrollToDecs:[cycleView objectInDatasAtIndex:index]];
        };
//        _pkView.didScrollToDecs = ^(NSArray<THKDecPKCompanyModel *> * _Nonnull models) {
//            @strongify(self);
//            [self didScrollToDecs:models];
//        };
    }
    return _pkView;
}

- (FLRadarChartView *)radarView{
    if (!_radarView) {
        _radarView = [[FLRadarChartView alloc] init];
        _radarView.backgroundColor = [UIColor whiteColor];
        _radarView.minValue = 0.0;
        _radarView.maxValue = 100.0;
        _radarView.allowOverflow = NO;
    }
    return _radarView;
}

- (UIButton *)bottomButton{
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] init];
        [_bottomButton setBackgroundImage:[UIImage imageNamed:@"dec_pk_btn_bg"] forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

- (UIButton *)bottomTipBtn{
    if (!_bottomTipBtn) {
        _bottomTipBtn = [[UIButton alloc] init];
        _bottomTipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_bottomTipBtn setTitleColor:UIColorHexString(@"AFB2AF") forState:UIControlStateNormal];
        [_bottomTipBtn addTarget:self action:@selector(bottomTipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomTipBtn;
}

- (NSMutableArray<UIView *> *)hiddenViews {
    if (!_hiddenViews) {
        _hiddenViews = [NSMutableArray array];
    }
    return _hiddenViews;
}

@end
