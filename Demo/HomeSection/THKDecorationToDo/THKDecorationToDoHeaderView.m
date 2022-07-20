//
//  THKDecorationToDoHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoHeaderView.h"
#import "THKDecorationToDoStageView.h"


@interface THKDecorationToDoHeaderView ()

@property (nonatomic, strong) THKDecorationToDoHeaderViewModel *viewModel;

@property (nonatomic, strong) UIImageView *bgImgV;

@property (nonatomic, strong) UIImageView *titleImgV;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;

@property (nonatomic, strong) THKDecorationToDoStageView *stageView;

@end

@implementation THKDecorationToDoHeaderView
@dynamic viewModel;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)bindViewModel{
    [super bindViewModel];
    
//    [self.stageView bindWithModel:self.viewModel.model];
    self.stageView.model = self.viewModel.model;
}


- (void)setupSubviews{
    self.backgroundColor = UIColorHex(F6F8F6);
    [self addSubview:self.bgImgV];
    [self addSubview:self.titleImgV];
    [self addSubview:self.subtitleLbl];
    [self addSubview:self.stageView];
    
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    
    [self.titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(106);
        make.left.mas_equalTo(30);
    }];
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImgV.mas_bottom).offset(10);
        make.left.mas_equalTo(30);
    }];
    
    [self.stageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(62);
        make.bottom.mas_equalTo(-15);
    }];
}


- (void)setTapItem:(void (^)(NSInteger))tapItem{
    _tapItem = tapItem;
    self.stageView.tapItem = tapItem;
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    self.stageView.selectIndex = selectIndex;
}

- (UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"dec_todo_headbg")];
    }
    return _bgImgV;
}

- (UIImageView *)titleImgV{
    if (!_titleImgV) {
        _titleImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"dec_todo_title")];
    }
    return _titleImgV;
}

//- (UILabel *)titleLbl{
//    if (!_titleLbl) {
//        _titleLbl = [[UILabel alloc] init];
//    }
//    return _titleLbl;
//}

- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        _subtitleLbl.text = @"帮你快速了解装修全流程～";
        _subtitleLbl.textColor = UIColorPlaceholder;
        _subtitleLbl.font = UIFont(14);
        
    }
    return _subtitleLbl;
}


- (THKDecorationToDoStageView *)stageView{
    if (!_stageView) {
        _stageView = [[THKDecorationToDoStageView alloc] init];
    }
    return _stageView;
}


@end
