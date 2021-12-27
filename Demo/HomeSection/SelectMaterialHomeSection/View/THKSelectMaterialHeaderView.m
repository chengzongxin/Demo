//
//  THKSelectMaterialHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialHeaderView.h"
#import "THKEntranceView.h"
#import "THKSelectMaterialConst.h"
@interface THKSelectMaterialHeaderView ()

@property (nonatomic, strong) THKSelectMaterialHeaderViewModel *viewModel;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) TMUILabel *tipsLabel;

@property (nonatomic, strong) UIView *entryView;

@property (nonatomic, strong) THKEntranceView *firstLevelEntranceView;

@property (nonatomic, strong) UIView *entryLineView;

@property (nonatomic, strong) THKEntranceView *secondLevelEntranceView;


@property (nonatomic, strong) RACSubject *tapCoverSubject;

@property (nonatomic, strong) RACSubject *tapEntrySubject;

@property (nonatomic, assign) CGFloat viewHeight;

@end

@implementation THKSelectMaterialHeaderView
@dynamic viewModel;

- (void)thk_setupViews{
    [self addSubview:self.coverImageView];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.entryView];
    [self.entryView addSubview:self.firstLevelEntranceView];
    [self.entryView addSubview:self.entryLineView];
    [self.entryView addSubview:self.secondLevelEntranceView];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarHeight + kMaterialHomeSearchHeight + kMaterialHomeTabHeight);
        make.left.right.equalTo(self).inset(15);
        make.height.mas_equalTo(180);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.coverImageView).inset(8);
        make.height.mas_equalTo(27);
    }];
    
    [self.entryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(10);
        make.left.right.equalTo(self).inset(15);
        make.height.mas_equalTo(176);
    }];
    
    [self.firstLevelEntranceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(103);
    }];
    
    [self.entryLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(103);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.secondLevelEntranceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(73);
    }];
}

- (void)bindViewModel{
    [self.coverImageView loadImageWithUrlStr:self.viewModel.model.banner.imgUrl];
    
    THKEntranceViewModel *firstViewModel = [[THKEntranceViewModel alloc] init];
    firstViewModel.isFirstLevelEntrance = YES;
//    [firstViewModel bindWithModel:@[@"瓷砖百科",@"参数对比",@"土巴兔实测",@"口碑评价"]];
    [firstViewModel bindWithModel:self.viewModel.model.majorEntrances];
    [self.firstLevelEntranceView bindViewModel:firstViewModel];
    
    THKEntranceViewModel *secondViewModel = [[THKEntranceViewModel alloc] init];
//    [secondViewModel bindWithModel:@[@"品牌排行",@"实拍效果",@"选购技巧",@"价格计算",@"常见问题"]];
    [secondViewModel bindWithModel:self.viewModel.model.minorEntrances];
    [self.secondLevelEntranceView bindViewModel:secondViewModel];
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize resultSize = CGSizeMake(size.width, 0);
    
    CGFloat height = 0;
    
    height += StatusBarHeight + kMaterialHomeSearchHeight + kMaterialHomeTabHeight;
    
    if (self.viewModel.model.banner.imgUrl.length) {
        height += 180;
    }
    
    if (self.viewModel.model.majorEntrances.count) {
        height += 103;
    }
    
    if (self.viewModel.model.minorEntrances.count) {
        height += 73;
    }
    
    if (self.viewModel.model.majorEntrances.count || self.viewModel.model.minorEntrances.count) {
        height += 10; // top 边距
        
        height += 9.5; // bottom 边距
    }
    
    
    resultSize.height = height;
    
    return resultSize;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.entryView.height * self.entryView.width) {
        self.entryView.layer.cornerRadius = 8;
        [self.entryView.layer tmui_setLayerShadow:UIColor.blackColor offset:CGSizeMake(0, 2) alpha:0.05 radius:10 spread:0];
    }
}


- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.cornerRadius = 8;
        _coverImageView.image = UIImageMake(@"dec_banner_def");
        @weakify(self);
        [_coverImageView tmui_addSingerTapWithBlock:^{
            @strongify(self);
            [self.tapCoverSubject sendNext:self.viewModel.model.banner];
        }];
    }
    return _coverImageView;
}

- (TMUILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[TMUILabel alloc] init];
        _tipsLabel.backgroundColor = [UIColorHex(1A1C1A) colorWithAlphaComponent:0.2];
        _tipsLabel.cornerRadius = 13.5;
        _tipsLabel.textColor = UIColor.whiteColor;
        _tipsLabel.text = @"56个品牌   6574张实拍";
        _tipsLabel.font = UIFont(12);
        _tipsLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return _tipsLabel;
}

- (UIView *)entryView{
    if (!_entryView) {
        _entryView = [[UIView alloc] init];
        _entryView.backgroundColor = UIColor.whiteColor;
    }
    return _entryView;
}

- (THKEntranceView *)firstLevelEntranceView{
    if (!_firstLevelEntranceView) {
        _firstLevelEntranceView = [[THKEntranceView alloc] init];
        @weakify(self);
        _firstLevelEntranceView.tapItem = ^(NSIndexPath * _Nonnull indexPath, MaterialTabMajorEntrancesModel * _Nonnull entrance) {
            @strongify(self);
            [self.tapEntrySubject sendNext:RACTuplePack(@(1),indexPath,entrance)];
        };
    }
    return _firstLevelEntranceView;
}


- (THKEntranceView *)secondLevelEntranceView{
    if (!_secondLevelEntranceView) {
        _secondLevelEntranceView = [[THKEntranceView alloc] init];
        @weakify(self);
        _secondLevelEntranceView.tapItem = ^(NSIndexPath * _Nonnull indexPath, MaterialTabMajorEntrancesModel * _Nonnull entrance) {
            @strongify(self);
            [self.tapEntrySubject sendNext:RACTuplePack(@(2),indexPath,entrance)];
        };
    }
    return _secondLevelEntranceView;
}

- (UIView *)entryLineView{
    if (!_entryLineView) {
        _entryLineView = [[UIView alloc] init];
        _entryLineView.backgroundColor = UIColorHex(ECEEEC);
    }
    return _entryLineView;
}

TMUI_PropertyLazyLoad(RACSubject, tapCoverSubject);
TMUI_PropertyLazyLoad(RACSubject, tapEntrySubject);


@end
