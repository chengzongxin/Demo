//
//  TDSearchViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/9.
//

#import "TDSearchViewController.h"
#import "THKNavigationBar.h"
#import "TMUISearchView.h"
@interface TDSearchViewController ()

@end

@implementation TDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navBarHidden = YES;
    
    
    
    
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    [self.view addSubview:navBar];
    
    
    TMUISearchView *search = [[TMUISearchView alloc] init];
    [search setHotwords:@[@"123",@"456"]];
    [search startScroll];
    
    
    navBar.titleView = search;
}

@end
