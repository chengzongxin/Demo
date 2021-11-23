//
//  THKSelectMaterialHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialHeaderView.h"

@interface THKSelectMaterialHeaderView ()

@property (nonatomic, strong) THKSelectMaterialHeaderViewModel *viewModel;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIView *entryView;

@end

@implementation THKSelectMaterialHeaderView
@dynamic viewModel;

- (void)thk_setupViews{
    [self addSubview:self.coverImageView];
    [self addSubview:self.entryView];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarHeight + 55 + 36);
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
