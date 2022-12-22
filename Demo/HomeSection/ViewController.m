//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKValuePointIntroductionVC.h"
#import "THKOpenWXProgramAlertView.h"
#import "THKCalculateQuotationView.h"
#import "IrregularViewController.h"
#import "FLDefaultRadarChartViewController.h"
#import "THKDecPKView.h"
@interface ViewController ()
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    THKDecPKView *view = [[THKDecPKView alloc] init];
    [view bindViewModel:[THKDecPKViewModel new]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(584);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self push];
}


- (void)push{
    [self.navigationController pushViewController:FLDefaultRadarChartViewController.new animated:YES];
}

#pragma mark - 弹窗



@end
