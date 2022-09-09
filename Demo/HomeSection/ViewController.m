//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKOnlineDesignDispatchVC.h"
#import "THKAssignFinishWeChatView.h"
@interface ViewController ()

@property (nonatomic, strong) THKAssignFinishWeChatView *wechatView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWhite;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self push];
//    });
    
    
    
    THKAssignFinishWeChatView *wechatView = [[THKAssignFinishWeChatView alloc] init];
    [self.view addSubview:wechatView];
    self.wechatView = wechatView;
    [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-100);
        make.right.mas_equalTo(0);
    }];
    [self.wechatView tmui_addSingerTapWithBlock:^{
        NSLog(@"ssss");
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.wechatView tmui_shadowColor:UIColor.blackColor opacity:0.1 offsetSize:CGSizeMake(5, 5) corner:6];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self push];
    if (self.wechatView.tag == 0) {
        self.wechatView.tag = 1;
        [self.wechatView fold];
    }else{
        self.wechatView.tag = 0;
        [self.wechatView unfold];
    }
}

@end
