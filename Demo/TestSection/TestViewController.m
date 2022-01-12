//
//  TestViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/16.
//

#import "TestViewController.h"

@interface TestViewController (){
    RACSubject *_subject1;
    RACSubject *_subject2;
}

@property (nonatomic, strong) UITextField *acTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation TestViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"随你怎么玩";
    NSLog(@"===========%s=============",__FUNCTION__);
    
    _acTF = TextField.hint(@"account").fixWH(200,44);
    _pwdTF = TextField.hint(@"password").fixWH(200,44);
    _loginBtn = Button.fixWH(200,44).str(@"Login").bgColor(@"random").onClick(^{
        Log(@"1111");
    });
    [_loginBtn setTitleColor:UIColor.redColor forState:UIControlStateDisabled];
    VerStack(_acTF,_pwdTF,_loginBtn).embedIn(self.view, UIEdgeInsetsMake(150, 20, 200, 20));
    
    RAC(_loginBtn,enabled) = [RACSignal combineLatest:@[_acTF.rac_textSignal,_pwdTF.rac_textSignal] reduce:^id _Nullable(NSString *ac,NSString *pwd){
//        NSLog(@"account:%@ pw:%@",ac,pwd);
        return @(ac.length && pwd.length);
    }];
    
//    [self combine1];
    [self combine2];
}


- (void)combine2{
    @weakify(self);
    RACSignal *sign1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        RACDisposable *dispose = [self.acTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            Log(@"combine2 subject1 send %@",x);
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            [dispose dispose];
        }];
    }];
    
    RACSignal *sign2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        RACDisposable *dispose = [self.pwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            Log(@"combine2 subject2 send %@",x);
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            [dispose dispose];
        }];
    }];
    
    RACDisposable *dispose = [[RACSignal combineLatest:@[sign1,sign2] reduce:^id(id data1,id data2){
        return [NSString stringWithFormat:@"combineLatest2 send %@,%@",data1,data2];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"combineLatest2 subscribeNext %@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"combineLatest2 error");
    } completed:^{
        NSLog(@"combineLatest2 complete");
    }];
    [dispose dispose];
    NSLog(@"%@",dispose);
    
//    [RACSignal combineLatest:@[sign1,sign2] reduce:^id(id data1,id data2){
//        return [NSString stringWithFormat:@"combineLatest2 send %@,%@",data1,data2];
//    }];
//    TMUI_weakify(sign1)
    __weak __typeof__(sign1) _tmui_weak_sign1 = sign1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        Log(sign1);
        Log(_tmui_weak_sign1);
    });
}

- (void)combine1{
    
    
    _subject1 = [RACSubject subject];
    _subject2 = [RACSubject subject];
    
    
    [[RACSignal combineLatest:@[_subject1,_subject2] reduce:^id(id data1,id data2){
        return [NSString stringWithFormat:@"combineLatest send %@,%@",data1,data2];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"combineLatest subscribeNext %@",x);
    }];
    
    
    
    @weakify(self);
    [_acTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        Log(@"subject1 send %@",x);
        [self->_subject1 sendNext:x];
        [self->_subject1 sendCompleted];
    }];
    
    [_pwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        Log(@"subject2 send %@",x);
        [self->_subject2 sendNext:x];
        [self->_subject2 sendCompleted];
    }];
}

@end
