//
//  THKSelectMaterialHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialHeaderView.h"
#import "THKEntranceView.h"

@interface THKSelectMaterialHeaderView ()

@property (nonatomic, strong) THKSelectMaterialHeaderViewModel *viewModel;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) TMUILabel *tipsLabel;

@property (nonatomic, strong) UIView *entryView;

@property (nonatomic, strong) THKEntranceView *firstLevelEntranceView;

@property (nonatomic, strong) THKEntranceView *secondLevelEntranceView;

@end

@implementation THKSelectMaterialHeaderView
@dynamic viewModel;

- (void)thk_setupViews{
    [self addSubview:self.coverImageView];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.entryView];
    [self.entryView addSubview:self.firstLevelEntranceView];
    [self.entryView addSubview:self.secondLevelEntranceView];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarHeight + 55 + 36);
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
    
    [self.secondLevelEntranceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(73);
    }];
}

- (void)bindViewModel{
    THKEntranceViewModel *firstViewModel = [[THKEntranceViewModel alloc] init];
    firstViewModel.isFirstLevelEntrance = YES;
    [firstViewModel bindWithModel:@[@"瓷砖百科",@"参数对比",@"土巴兔实测",@"口碑评价"]];
    [self.firstLevelEntranceView bindViewModel:firstViewModel];
    
    THKEntranceViewModel *secondViewModel = [[THKEntranceViewModel alloc] init];
    [secondViewModel bindWithModel:@[@"品牌排行",@"实拍效果",@"选购技巧",@"价格计算",@"常见问题"]];
    [self.secondLevelEntranceView bindViewModel:secondViewModel];
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.cornerRadius = 8;
        _coverImageView.image = UIImageMake(@"dec_banner_def");
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
    }
    return _firstLevelEntranceView;
}

- (THKEntranceView *)secondLevelEntranceView{
    if (!_secondLevelEntranceView) {
        _secondLevelEntranceView = [[THKEntranceView alloc] init];
    }
    return _secondLevelEntranceView;
}

@end
