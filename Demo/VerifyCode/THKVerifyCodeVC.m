//
//  THKVerifyCodeVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKVerifyCodeVC.h"

static UIEdgeInsets const kContentInset = {50,50,0,50};

@interface THKVerifyCodeVC ()

@property (nonatomic, strong) THKVerifyCodeVM *viewModel;

@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *refreshButton;


@end

@implementation THKVerifyCodeVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title = @"图片验证";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithTitle:@"提交" target:self action:@selector(commitCode)];
}

- (void)thk_addSubviews{
    [self.view addSubview:self.codeImgView];
    [self.view addSubview:self.inputTextField];
    [self.view addSubview:self.refreshButton];
    
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tmui_navigationBarHeight() + kContentInset.top);
        make.left.mas_equalTo(kContentInset.left);
        make.right.mas_equalTo(-kContentInset.right);
        make.height.mas_equalTo(200);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeImgView.mas_bottom).offset(20);
        make.left.mas_equalTo(kContentInset.left);
        make.right.mas_equalTo(-kContentInset.right);
        make.height.mas_equalTo(44);
    }];
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(20);
        make.right.mas_equalTo(-kContentInset.right);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(44);
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
        [TMToast toast:x.data.result];
        if (x.data.status == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
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
        _inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        _inputTextField.placeholder = @"请填写图片内的验证码";
    }
    return _inputTextField;
}

- (UIButton *)refreshButton{
    if (!_refreshButton) {
        _refreshButton = [[UIButton alloc] init];
        _refreshButton.tmui_text = @"刷新验证码";
        [_refreshButton setTmui_titleColor:UIColor.blueColor];
        [_refreshButton tmui_addTarget:self action:@selector(refreshCode)];
    }
    return _refreshButton;
}


@end
