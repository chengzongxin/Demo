//
//  THKMyHomeDesignDemandsCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKMyHomeDesignDemandsCell.h"

@interface THKMyHomeDesignDemandsCell ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation THKMyHomeDesignDemandsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

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

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFontMedium(14);
        _titleLbl.text = @"小区名称";
    }
    return _titleLbl;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = UIFont(18);
        _textField.placeholder = @"请输入小区名称";
        [_textField tmui_setPlaceholderColor:UIColorPlaceholder];
    }
    return _textField;
}


@end
