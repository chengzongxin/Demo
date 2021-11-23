//
//  THKSelectMaterialHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialHeaderView.h"
#import "THKSearchView.h"

@interface THKSelectMaterialHeaderView ()

@property (nonatomic, strong) THKSelectMaterialHeaderViewModel *viewModel;

@property (nonatomic, strong) THKSearchView *searchView;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIView *entryView;

@end

@implementation THKSelectMaterialHeaderView
@dynamic viewModel;

- (void)thk_setupViews{
    [self addSubview:self.searchView];
    [self addSubview:self.coverImageView];
    [self addSubview:self.entryView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarHeight);
        make.left.right.equalTo(self).inset(15);
        make.height.mas_equalTo(36);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(55);
        make.left.right.equalTo(self).inset(15);
        make.height.mas_equalTo(180);
    }];
    
    [self.entryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(10);
        make.left.right.equalTo(self).inset(15);
        make.height.mas_equalTo(176);
    }];
}

- (void)bindViewModel{
    
}



- (THKSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[THKSearchView alloc] init];
        _searchView.backgroundColor = UIColorHex(F9FAF9);
        _searchView.searchLabel.text = @"大家都在搜：瓷砖";
        _searchView.cornerRadius = 8;
    }
    return _searchView;
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.cornerRadius = 8;
        _coverImageView.image = UIImageMake(@"dec_banner_def");
    }
    return _coverImageView;
}

- (UIView *)entryView{
    if (!_entryView) {
        _entryView = [[UIView alloc] init];
        _entryView.backgroundColor = UIColor.tmui_randomColor;
    }
    return _entryView;
}

@end
