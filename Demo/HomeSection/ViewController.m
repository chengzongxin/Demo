//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKGraphicDetailVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWhite;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self push];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self push];
}

- (void)push{
    THKGraphicDetailVM *vm = [THKGraphicDetailVM new];
    THKGraphicDetailVC *vc = [[THKGraphicDetailVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 定时输入

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self showInputing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)dealloc{
    NSLog(@"delloc %@",self);
}

- (void)showInputing{
    self.thk_title = @"正在输入中...";
    
    [self performSelector:@selector(cancelInput) afterDelay:5];
}

- (void)cancelInput{
    
    self.thk_title = @"";
    
    [self performSelector:@selector(showInputing) afterDelay:2];
}

@end
