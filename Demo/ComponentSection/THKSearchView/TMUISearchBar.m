//
//  TMUISearchBar.m
//  Demo
//
//  Created by 程宗鑫 on 2022/3/15.
//

#import "TMUISearchBar.h"

#define kImgName(imgName) [UIImage tmui_imageInBundleWithName:imgName]

@interface TMUISearchBar () <TMUITextFieldDelegate>

@property (nonatomic, assign) TMUISearchBarStyle style;

@property (nonatomic, strong) TMUIButton *cityBtn;

@property (nonatomic, strong) UIView *seperator;

@property (nonatomic, strong) UIImageView *searchIcon;

@property (nonatomic, strong) TMUITextField *textField;

@end

@implementation TMUISearchBar

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithStyle:TMUISearchBarStyle_Normal frame:frame];
}

- (instancetype)initWithStyle:(TMUISearchBarStyle)style {
    return [self initWithStyle:style frame:CGRectZero];
}

- (instancetype)initWithStyle:(TMUISearchBarStyle)style frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.isCanInput = YES;
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.clipsToBounds = YES;
    self.backgroundColor = UIColorHex(F9FAF9);
    self.layer.borderColor = UIColorHex(ECEEEC).CGColor;
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = .5;
    
    // normal style
    if (self.style == TMUISearchBarStyle_Normal) {
        [self addSubview:self.searchIcon];
        [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(12);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [self addSubview:self.textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.mas_equalTo(36);
            make.left.equalTo(_searchIcon.mas_right).with.offset(8);
            make.right.equalTo(self).with.offset(-8);
        }];
    }else if (self.style == TMUISearchBarStyle_City) {
        // city style, left city ,right search
        [self addSubview:self.cityBtn];
        [_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.height.equalTo(self);
            make.width.mas_equalTo(80);
        }];
        
        [self addSubview:self.seperator];
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_cityBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(1, 14));
        }];
        
        [self addSubview:self.searchIcon];
        [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cityBtn.mas_right).offset(15);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [self addSubview:self.textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.mas_equalTo(36);
            make.left.equalTo(_searchIcon.mas_right).with.offset(8);
            make.right.equalTo(self).with.offset(-8);
        }];
    }
}

#pragma mark - Public
- (void)setCurrentCity:(NSString *)cityName{
    _cityBtn.tmui_text = cityName;
}

- (void)setMaxTextLength:(NSInteger)maxTextLength{
    _textField.maximumTextLength = maxTextLength;
}

#pragma mark - Action
/// 城市按钮点击
- (void)cityBtnClick:(UIButton *)btn{
    !_cityClick?:_cityClick(btn);
}

/// 文字发生改变
- (void)textDidChange:(UITextField *)textField{
    !_textChange?:_textChange(textField,textField.text);
}

/// 文本框被点击
- (void)textFieldDidClick:(UITapGestureRecognizer *)tap{
    !_textClick?:_textClick(_textField);
}

#pragma mark - Delegate
/// 输入框是否可点击
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return self.isCanInput;
}

- (void)textField:(TMUITextField *)textField didPreventTextChangeInRange:(NSRange)range replacementString:(NSString *)replacementString{
    !_maxLength?:_maxLength(textField,range,replacementString);
}

- (void)setIsCanInput:(BOOL)isCanInput{
    _isCanInput = isCanInput;
    
    if (isCanInput == NO) {
        [_textField addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldDidClick:)]];
    }
}

#pragma mark - Getter & Setter
- (UIButton *)cityBtn{
    if (!_cityBtn) {
        _cityBtn = [TMUIButton tmui_button];
        _cityBtn.spacingBetweenImageAndTitle = 9;
        _cityBtn.imagePosition = TMUIButtonImagePositionRight;
        _cityBtn.tmui_text = @"深圳";
        _cityBtn.tmui_image = kImgName(@"tmui_searchBar_arrow");
        _cityBtn.tmui_titleColor = UIColorHex(1A1C1A);
        _cityBtn.tmui_font = UIFont(14);
        [_cityBtn tmui_addTarget:self action:@selector(cityBtnClick:)];
    }
    return _cityBtn;
}

- (UIView *)seperator{
    if (!_seperator) {
        _seperator = [[UIView alloc] init];
        _seperator.backgroundColor = UIColorHex(E2E4E2);
    }
    return _seperator;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] init];
        _searchIcon.backgroundColor = [UIColor clearColor];
        _searchIcon.image = kImgName(@"tmui_searchBar_magnifier");
    }
    return _searchIcon;
}

- (TMUITextField *)textField{
    if (!_textField) {
        _textField = [[TMUITextField alloc] init];
        _textField.tintColor = kTo8toGreen;
        _textField.textColor = UIColorHex(1A1C1A);
        _textField.placeholderColor = UIColorHex(7E807E);
        _textField.placeholder = @"请输入";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.clipsToBounds = YES;
        _textField.font = UIFont(14);
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventAllEditingEvents];
    }
    return _textField;
}


@end
