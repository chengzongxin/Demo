//
//  DemoViewController.m
//  Demo
//
//  Created by Joe.cheng on 2023/2/22.
//

#import "DemoViewController.h"
#import <Masonry/Masonry.h>
@interface DemoViewController ()

@property (nonatomic, strong) TMUITextField *textField;

@property (nonatomic, strong) UILabel *tipsLabl;

@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.tipsLabl];
    [self.view addSubview:self.saveBtn];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(207);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
    
    [self.tipsLabl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabl.mas_bottom).offset(117);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(48);
    }];
    
}

- (void)saveBtnClick:(UIButton *)btn{
    
}


- (TMUITextField *)textField{
    if (!_textField) {
        _textField = [[TMUITextField alloc] init];
        _textField.tintColor = UIColorGreen;
        _textField.textColor = UIColorDark;
        _textField.placeholderColor = UIColorWeak;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.clipsToBounds = YES;
        _textField.font = UIFontMedium(20);
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.tmui_borderPosition = TMUIViewBorderPositionBottom;
        _textField.tmui_borderWidth = 1;
        _textField.tmui_borderColor = UIColorBorder;
        _textField.maximumTextLength = 20;
    }
    return _textField;
}

- (UILabel *)tipsLabl{
    if (!_tipsLabl) {
        _tipsLabl = [[UILabel alloc] init];
        _tipsLabl.textColor = UIColorPlaceholder;
        _tipsLabl.font = UIFont(14);
        _tipsLabl.text = @"昵称可输入1-15个字，一个月只能改一次";
        _tipsLabl.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabl;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] init];
        _saveBtn.backgroundColor = UIColorGreen;
        _saveBtn.cornerRadius = 6;
        _saveBtn.tmui_text = @"保存修改";
        _saveBtn.tmui_font = UIFontMedium(16);
        _saveBtn.tmui_titleColor = UIColor.whiteColor;
        [_saveBtn tmui_addTarget:self action:@selector(saveBtnClick:)];
    }
    return _saveBtn;
}

@end
