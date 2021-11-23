//
//  THKTabBarController.m
//  HouseKeeper
//
//  Created by kevin.huang on 14-7-5.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "THKTabBarController.h"
#import "THKNavigationController.h"
#import "ViewController.h"
//#import "THKSelectMaterialVC.h"
#import "THKSelectMaterialMainVC.h"

#pragma mark - THKTabBarController

@interface THKTabBarItem : UITabBarItem

@end

@implementation THKTabBarItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitleTextAttributes:@{NSFontAttributeName:UIFont(30)} forState:UIControlStateNormal];
        [self setTitleTextAttributes:@{NSFontAttributeName:UIFontMedium(30)} forState:UIControlStateHighlighted];
        [self setTitleTextAttributes:@{NSFontAttributeName:UIFontMedium(30)} forState:UIControlStateSelected];
    }
    return self;
}

@end

@interface THKTabBarController ()
@end

@implementation THKTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self setTabBarItem];
        [self didInitalize];
    }
    return self;
}

- (void)didInitalize{
    NSMutableArray <UIViewController *> *arrViewControllers = [NSMutableArray array];
    // tab 0 首页
    [arrViewControllers safeAddObject:[[THKNavigationController alloc] initWithRootViewController:[[ViewController alloc] init]]];
    // tab 1 选材
    THKSelectMaterialMainVM *selectMaterialVM = [[THKSelectMaterialMainVM alloc] init];
    [arrViewControllers safeAddObject:[[THKNavigationController alloc]initWithRootViewController:[[THKSelectMaterialMainVC alloc] initWithViewModel:selectMaterialVM]]];
    
    arrViewControllers[0].tabBarItem.title = @"首页";
    arrViewControllers[1].tabBarItem.title = @"选材";
    
    self.viewControllers = arrViewControllers;
    self.tabBar.translucent = NO;// 不透明
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    UIColor *nColor =  _THKColorWithHexString(@"7E807E");
    UIColor *sColor = _THKColorWithHexString(@"1A1C1A");
    NSArray *imgs = @[UIImageMake(@"diary_collect_icon"),UIImageMake(@"diary_direction_icon")];
    
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        [item setTitlePositionAdjustment:UIOffsetMake(0.33, -4.0)];// 此时文字距离底部5个单位距离
        UIColor *normalColor =  nColor;
        UIColor *selectedColor = sColor;
        item.image = imgs[i];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor,
                                       NSFontAttributeName:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular]}
                            forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:selectedColor,
                                       NSFontAttributeName:[UIFont systemFontOfSize:10 weight:UIFontWeightMedium]}
                            forState:UIControlStateSelected];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.delegate = self;
}

// 是否支持屏幕旋转
- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

// 屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}


@end
