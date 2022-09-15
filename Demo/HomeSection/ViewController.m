//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKMyHomeDesignDemandsVC.h"

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
    THKMyHomeDesignDemandsVM *vm = [THKMyHomeDesignDemandsVM new];
    THKMyHomeDesignDemandsVC *vc = [[THKMyHomeDesignDemandsVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
