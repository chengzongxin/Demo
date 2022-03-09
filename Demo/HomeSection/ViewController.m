//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "TMUIFilterMenu.h"
#import "TMUIFilterView.h"
#import "THKCustomNavigationViewController.h"
#import "TDSearchViewController.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self homelist];
}


- (void)homelist{
    id b1 =
        [self createBtn]
        .str(@"系统导航栏")
        .onClick(^{
            THKCustomNavigationViewController *vc = [THKCustomNavigationViewController new];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b2 =
        [self createBtn]
        .str(@"自定义导航栏-常规样式")
        .onClick(^{
            THKCustomNavigationViewController *vc = [THKCustomNavigationViewController new];
            vc.type = 2;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b3 =
        [self createBtn]
        .str(@"自定义导航栏-特殊样式")
        .onClick(^{
            THKCustomNavigationViewController *vc = [THKCustomNavigationViewController new];
            vc.type = 3;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    VerStack(b1,b2,b3)
    .gap(10)
    .embedIn(UIScrollView.new.embedIn(self.view), 0, 20, 80);
}



- (UIButton *)createBtn{
    return
    Button
    .color(@"white")
    .bgColor(@"random")
    .borderRadius(4)
    .fixWH(TMUI_SCREEN_WIDTH - 40,44);
}


- (void)addMenu{
    TMUIFilterMenu *menu = [[TMUIFilterMenu alloc] init];
    [self.view addSubview:menu];
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationContentTop);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    
}

@end
