//
//  THKDecorationToDoSectionHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoSectionHeaderView.h"

@interface THKDecorationToDoSectionHeaderView ()

@property (nonatomic, strong) TMUICustomCornerRadiusView *containerView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *todoCountLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;

@property (nonatomic, strong) UIButton *arrowBtn;

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
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.titleLbl];
    [self.containerView addSubview:self.todoCountLbl];
    [self.containerView addSubview:self.subtitleLbl];
    [self.containerView addSubview:self.arrowBtn];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(24);
    }];
    
    [self.todoCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.equalTo(self.titleLbl.mas_right).offset(10);
        make.height.mas_equalTo(24);
    }];
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(6);
        make.left.mas_equalTo(16);
    }];
    
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
}

- (void)arrowBtnClick:(UIButton *)btn{
    !_tapSection?:_tapSection(btn);
}

- (void)setModel:(THKDecorationUpcomingListModel *)model{
    _model = model;
    
    [self open:model.isOpen];
    _titleLbl.text = model.mainName;
    _todoCountLbl.text = [NSString stringWithFormat:@"%ld/%ld",(long)model.completedNum,(long)model.totalNum];
    _subtitleLbl.text = model.mainDesc;
}

- (void)open:(BOOL)open{
    if (open) {
        self.arrowBtn.tmui_image = UIImageMake(@"dec_todo_open");
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(12);
        }];
    }else{
        self.arrowBtn.tmui_image = UIImageMake(@"dec_todo_close");
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (TMUICustomCornerRadiusView *)containerView{
    if (!_containerView) {
        _containerView = [[TMUICustomCornerRadiusView alloc] init];
        _containerView.backgroundColor = UIColorWhite;
        _containerView.customCornerRadius = TMUICustomCornerRadiusMake(12, 12, 12, 12);
    }
    return _containerView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorTextImportant;
        _titleLbl.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    }
    return _titleLbl;
}

- (UILabel *)todoCountLbl{
    if (!_todoCountLbl) {
        _todoCountLbl = [[UILabel alloc] init];
        _todoCountLbl.textColor = UIColorTextImportant;
        _todoCountLbl.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    }
    return _todoCountLbl;
}

- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        _subtitleLbl.textColor = UIColorTextWeak;
        _subtitleLbl.font = UIFont(14);
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
