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
@interface ViewController ()
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self push];
}


- (void)push{
    [self.navigationController pushViewController:FLDefaultRadarChartViewController.new animated:YES];
}

#pragma mark - 弹窗



@end
