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
    [self addSubview:self.titleLbl];
    [self addSubview:self.subtitleLbl];
    [self addSubview:self.stageView];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
    }];
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(20);
        make.left.mas_equalTo(10);
    }];
    
    [self.stageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.subtitleLbl.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
        make.bottom.mas_equalTo(0);
    }];
}


- (void)setTapItem:(void (^)(NSInteger))tapItem{
    _tapItem = tapItem;
    self.stageView.tapItem = tapItem;
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    self.stageView.selectIndex = selectIndex;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"Section一级标题";
    }
    return _titleLbl;
}

- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        _subtitleLbl.text = @"Section二级标题";
        
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
