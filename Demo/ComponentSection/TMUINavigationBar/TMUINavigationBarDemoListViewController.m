//
//  TMUINavigationBarDemoListViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/5/16.
//

#import "TMUINavigationBarDemoListViewController.h"
#import "TMUIFilterView.h"
#import "THKCustomNavigationViewController.h"
#import "TMUINavigationBarViewController.h"

@interface TMUINavigationBarDemoListViewController ()

@property (nonatomic, strong) TMUINavigationBar *navBar;

@end

@implementation TMUINavigationBarDemoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self homelist];
    
    [self addNavgationBar];
    self.navBar.title = @"自定义导航栏";
    
}


- (void)homelist{
    id b1 =
        [self createBtn]
        .str(@"自定义导航栏-常规样式（白色）")
        .onClick(^{
            TMUINavigationBarViewController *vc = [TMUINavigationBarViewController new];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b2 =
        [self createBtn]
        .str(@"自定义导航栏-常规样式（黑色）")
        .onClick(^{
            TMUINavigationBarViewController *vc = [TMUINavigationBarViewController new];
            vc.type = 2;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b3 =
        [self createBtn]
        .str(@"自定义导航栏-特殊样式（tab组件）")
        .onClick(^{
            TMUINavigationBarViewController *vc = [TMUINavigationBarViewController new];
            vc.type = 3;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b4 =
        [self createBtn]
        .str(@"自定义导航栏-特殊样式（用户信息）")
        .onClick(^{
            TMUINavigationBarViewController *vc = [TMUINavigationBarViewController new];
            vc.type = 4;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b5 =
        [self createBtn]
        .str(@"自定义导航栏-特殊样式（搜索）🔍")
        .onClick(^{
            TMUINavigationBarViewController *vc = [TMUINavigationBarViewController new];
            vc.type = 5;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b6 =
        [self createBtn]
        .str(@"自定义导航栏-特殊样式（城市搜索）🔍")
        .onClick(^{
            TMUINavigationBarViewController *vc = [TMUINavigationBarViewController new];
            vc.type = 6;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b7 =
        [self createBtn]
        .str(@"自定义导航栏-导航栏渐变")
        .onClick(^{
            TMUINavigationBarViewController *vc = [TMUINavigationBarViewController new];
            vc.type = 7;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    VerStack(b1,b2,b3,b4,b5,b6,b7)
    .gap(10)
    .embedIn(UIScrollView.new.embedIn(self.view), tmui_navigationBarHeight() + 20, 20, 80);
}

- (UIButton *)createBtn{
    return
    Button
    .color(@"white")
    .bgColor(@"random")
    .borderRadius(4)
    .fixWH(TMUI_SCREEN_WIDTH - 40,44);
}

@end
