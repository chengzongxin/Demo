//
//  ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "ViewController.h"
#import "THKCompanyDetailBannerView.h"
#import "TDecDetailFirstModel.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    THKCompanyDetailBannerViewModel *bannerVM = [[THKCompanyDetailBannerViewModel alloc] init];
    THKCompanyDetailBannerView *banner = [[THKCompanyDetailBannerView alloc] init];
    [banner bindViewModel:bannerVM];
    [self.view addSubview:banner];
    
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 300));
    }];
    
    
    
    [bannerVM.tapRemindLiveSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"bannerVM.tapRemindLiveSubject = %@",x);
    }];
    
    [bannerVM.tapItemSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"bannerVM.tapItemSubject = %@",x);
    }];
    
    [bannerVM.tapVideoImageTagSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"bannerVM.tapVideoImageTagSubject = %@",x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self presentViewController:TestViewController.new animated:YES completion:nil];
}


@end
