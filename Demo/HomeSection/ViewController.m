//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKOnlineDesignVC.h"
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
    THKOnlineDesignVM *vm = [[THKOnlineDesignVM alloc] init];
    vm.status = THKOnlineDesignOperateType_Edit;
    THKOnlineDesignVC *vc = [[THKOnlineDesignVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
