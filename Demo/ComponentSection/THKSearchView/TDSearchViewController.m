//
//  TDSearchViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/9.
//

#import "TDSearchViewController.h"
#import "THKNavigationBar.h"
#import "TMUISearchView.h"
#import "TMUISearchBar.h"


#define invoke(method) \
SEL selector = NSSelectorFromString(method); \
IMP imp = [self methodForSelector:selector]; \
void (*func)(id, SEL) = (void *)imp; \
func(self, selector);

@interface TDSearchViewController ()

@end

@implementation TDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    NSString *method = [NSString stringWithFormat:@"style%zd",_style];
    
    invoke(method)
}


/// 滚动搜索
- (void)style0{
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    [self.view addSubview:navBar];
    
    TMUISearchView *search = [[TMUISearchView alloc] init];
    [search setHotwords:@[@"123",@"456"]];
    
    navBar.titleView = search;
}


/// 常用搜索
- (void)style1{
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    [self.view addSubview:navBar];
    
    TMUISearchBar *search = [[TMUISearchBar alloc] init];
    
    navBar.titleView = search;
}


/// 城市搜索
- (void)style2{
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    [self.view addSubview:navBar];
    
    TMUISearchBar *search = [[TMUISearchBar alloc] initWithStyle:TMUISearchBarStyle_City];
    
    navBar.titleView = search;
    
}

@end
