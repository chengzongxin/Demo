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
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    
    
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController pushViewController:THKCustomNavigationViewController.new animated:YES];
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
