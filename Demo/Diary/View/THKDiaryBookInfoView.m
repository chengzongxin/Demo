//
//  THKDiaryBookInfoView.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import "THKDiaryBookInfoView.h"

static UIEdgeInsets const kContentInset = {20, 20, 30, 20};

@interface THKDiaryBookInfoView ()

@property (nonatomic, strong) THKDiaryBookInfoViewModel *viewModel;
/// 日记本封面
@property (nonatomic, strong) UIImageView *coverImageView;
/// 日记本标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 房屋信息
@property (nonatomic, strong) UILabel *houseInfoLabel;
/// 装修清单
@property (nonatomic, strong) UIButton *shoppingListButton;
/// 公司信息
@property (nonatomic, strong) UILabel *companyLabel;
/// 底部线条
@property (nonatomic, strong) UIView *line;

@end

@implementation THKDiaryBookInfoView
@dynamic viewModel;
#pragma mark - Life Cycle
/// init or initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.coverImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.houseInfoLabel];
    [self addSubview:self.shoppingListButton];
    [self addSubview:self.companyLabel];
    [self addSubview:self.line];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kContentInset.top);
        make.left.mas_equalTo(kContentInset.left);
        make.size.mas_equalTo(CGSizeMake(115, 143));
        make.bottom.mas_equalTo(-kContentInset.bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView).offset(4);
        make.left.equalTo(self.coverImageView.mas_right).offset(10);
        make.right.mas_equalTo(-kContentInset.right);
    }];
    
    [self.houseInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel);
        make.right.mas_equalTo(-kContentInset.right);
    }];
    
    [self.shoppingListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.houseInfoLabel.mas_bottom).offset(5);
        make.left.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(84, 20));
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shoppingListButton.mas_bottom).offset(18);
        make.left.equalTo(self.titleLabel);
        make.right.mas_equalTo(-kContentInset.right);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}



#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{
    [self.coverImageView loadImageWithUrlStr:self.viewModel.coverImgUrl];
    self.titleLabel.attributedText = self.viewModel.titleAttr;
//    [self.titleLabel tmui_setAttributesString:self.viewModel.titleAttr.string lineSpacing:4];
    self.houseInfoLabel.attributedText = self.viewModel.houseInfoAttr;
    self.shoppingListButton.hidden = !self.viewModel.hasShoppingList;
    self.companyLabel.attributedText = self.viewModel.companyInfoAttr;
}

#pragma mark - Delegate

#pragma mark - Private



#pragma mark - Getter && Setter
- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = UIColor.tmui_randomColor;
    }
    return _coverImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 3;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)houseInfoLabel{
    if (!_houseInfoLabel) {
        _houseInfoLabel = [[UILabel alloc] init];
        _houseInfoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _houseInfoLabel;
}

- (UIButton *)shoppingListButton{
    if (!_shoppingListButton) {
        _shoppingListButton = [[UIButton alloc] init];
        _shoppingListButton.tmui_text = @" 装修清单 >";
        _shoppingListButton.tmui_image = UIImageMake(@"diary_shoppinglist_icon");
        _shoppingListButton.tmui_font = UIFont(12);
        _shoppingListButton.tmui_titleColor = UIColorHex(333533);
    }
    return _shoppingListButton;
}

- (UILabel *)companyLabel{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _companyLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = UIColorHex(F6F8F6);
    }
    return _line;
}



@end
