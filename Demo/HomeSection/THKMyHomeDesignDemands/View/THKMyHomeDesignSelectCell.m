//
//  THKMyHomeDesignSelectCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKMyHomeDesignSelectCell.h"

@interface THKMyHomeDesignSelectCell ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UITextField *textField;



@end

@implementation THKMyHomeDesignSelectCell
@synthesize delegate = _delegate;
@synthesize model = _model;


- (void)setupSubviews{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.textField];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_right).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
}


- (void)bindWithModel:(THKMyHomeDesignDemandsModel *)model{
    self.model = model;
    
    self.titleLbl.text = model.title;
    self.textField.text = model.content;
}

+ (CGFloat)cellHeightWithModel:(THKMyHomeDesignDemandsModel *)model{
    return 60;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFont(16);
        _titleLbl.text = @"小区名称";
    }
    return _titleLbl;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = UIColorDark;
        _textField.font = UIFontMedium(16);
        _textField.placeholder = @"请输入";
        [_textField tmui_setPlaceholderColor:UIColorPlaceholder];
    }
    return _textField;
}


@end
