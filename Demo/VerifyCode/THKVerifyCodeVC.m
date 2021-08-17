//
//  THKVerifyCodeVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKVerifyCodeVC.h"

static UIEdgeInsets const kContentInset = {26,30,0,30};

@interface THKVerifyCodeVC ()

@property (nonatomic, strong) THKVerifyCodeVM *viewModel;

@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation THKVerifyCodeVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"图片验证";
}

- (void)thk_addSubviews{
    [self.view addSubview:self.codeImgView];
    [self.view addSubview:self.refreshButton];
    [self.view addSubview:self.inputTextField];
    [self.view addSubview:self.commitButton];
    
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationContentTop + kContentInset.top);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.view);
    }];
    
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeImgView.mas_bottom).offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self.view);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refreshButton.mas_bottom).offset(16);
        make.left.mas_equalTo(kContentInset.left);
        make.right.mas_equalTo(-kContentInset.right);
        make.height.mas_equalTo(50);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(30);
        make.left.mas_equalTo(kContentInset.left);
        make.right.mas_equalTo(-kContentInset.right);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - Public
- (void)bindViewModel{
    // 修改viewModel参数
    RAC(self.viewModel,imgCode) = self.inputTextField.rac_textSignal;
    // 更新ImgView
    RAC(self.codeImgView,image) = self.viewModel.imageSubject;
    
    @weakify(self);
    [self.viewModel.refreshCodeCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [self.viewModel.commitCommand.nextSignal subscribeNext:^(THKVerifyCodeResponse *x) {
        NSLog(@"%@",x);
        @strongify(self);
        /// 0 短信校验发送失败! 1 短信校验发送成功! 2 先请求图片验证码! 3 短信ip发送限频! 4 短信phone发送限频! 5 图形验证码校验失败!
        
        if (x.status == THKStatusSuccess) {
            [TMToast toast:@"短信校验发送成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [TMToast toast:x.errorMsg];
            [self.viewModel.refreshCodeCommand execute:nil];
        }
    }];

    [self.viewModel.commitCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    [self.viewModel.refreshCodeCommand execute:nil];
}


#pragma mark - Action

- (void)commitCode{
    NSLog(@"commitCode");
    [self.viewModel.commitCommand execute:nil];
}

- (void)refreshCode{
    NSLog(@"refreshCode");
    [self.viewModel.refreshCodeCommand execute:nil];
}

#pragma mark - Private
- (void)refreshUI{
    
}


#pragma mark - Getter
- (UIImageView *)codeImgView{
    if (!_codeImgView) {
        _codeImgView = [[UIImageView alloc] init];
        _codeImgView.backgroundColor = kDefaultImgBgColor;
    }
    return _codeImgView;
}


- (UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.placeholder = @"请填写图片内的验证码";
        _inputTextField.tmui_borderPosition = TMUIViewBorderPositionBottom;
        _inputTextField.tmui_borderColor = UIColorHex(EBECF5);
    }
    return _inputTextField;
}

- (UIButton *)refreshButton{
    if (!_refreshButton) {
        _refreshButton = [[UIButton alloc] init];
        _refreshButton.tmui_text = @"刷新验证码";
        [_refreshButton setTmui_titleColor:UIColor.blueColor];
        _refreshButton.tmui_font = UIFont(12);
        [_refreshButton tmui_addTarget:self action:@selector(refreshCode)];
    }
    return _refreshButton;
}

- (UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [[UIButton alloc] init];
        _commitButton.backgroundColor = UIColorHex(24C77E);
        _commitButton.tmui_titleColor = UIColor.whiteColor;
        _commitButton.tmui_text = @"提交";
        [_commitButton tmui_addTarget:self action:@selector(commitCode)];
    }
    return _commitButton;
}

@end
