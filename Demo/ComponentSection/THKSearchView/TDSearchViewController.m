//
//  TDSearchViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/9.
//

#import "TDSearchViewController.h"
#import "THKNavigationBar.h"
@interface TDSearchViewController ()

@end

@implementation TDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    [self.view addSubview:navBar];
}

@end
