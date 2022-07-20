//
//  THKDecorationToDoSectionHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoSectionHeaderView.h"

@interface THKDecorationToDoSectionHeaderView ()


@end

@implementation THKDecorationToDoSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.subtitleLbl];
    [self.contentView addSubview:self.arrowBtn];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
    }];
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
    }];
    
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.centerY.equalTo(self);
    }];
}

- (void)arrowBtnClick:(UIButton *)btn{
    !_tapSection?:_tapSection(btn);
}

- (void)setModel:(THKDecorationUpcomingListModel *)model{
    _model = model;
    
    if (model.isOpen) {
        self.arrowBtn.tmui_image = UIImageMake(@"dec_todo_open");
    }else{
        self.arrowBtn.tmui_image = UIImageMake(@"dec_todo_close");
    }
    _titleLbl.text = model.mainName;
    _subtitleLbl.text = model.mainDesc;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
    }
    return _titleLbl;
}

- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        
    }
    return _subtitleLbl;
}

- (UIButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [[UIButton alloc] init];
        [_arrowBtn tmui_addTarget:self action:@selector(arrowBtnClick:)];
    }
    return _arrowBtn;
}

@end
