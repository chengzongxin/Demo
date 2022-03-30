//
//  TDFilterViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import "TDFilterViewController.h"
#import "TMUIFilterView.h"

@interface TDFilterViewController ()

@end

@implementation TDFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    [Button.str(@"单选筛选组件").bgColor(@"random").addTo(self.view).onClick(^{
        [self filter1];
    }) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(44);
    }];
    
    [Button.str(@"多选筛选组件").bgColor(@"random").addTo(self.view).onClick(^{
        [self filter2];
    }) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.top.mas_equalTo(264);
        make.height.mas_equalTo(44);
    }];
}
- (void)filter1{
    TMUIFilterModel *filterModel1 = [[TMUIFilterModel alloc] init];
    filterModel1.title = @"装修公司所在区域";
    filterModel1.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
    filterModel1.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"];
    
    TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
    filterView.models = @[filterModel1];
    
    [filterView show];
    
    filterView.selectBlock = ^(NSArray<NSIndexPath *> *indexPaths) {
        NSLog(@"%@",indexPaths);
    };
}

- (void)filter2{
    TMUIFilterModel *filterModel1 = [[TMUIFilterModel alloc] init];
    filterModel1.title = @"装修公司所在区域";
    filterModel1.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
    filterModel1.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"];
    
    TMUIFilterModel *filterModel2 = [[TMUIFilterModel alloc] init];
    filterModel2.title = @"装修公司所在区域";
    filterModel2.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
    filterModel2.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"];
    
    
    TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
    filterView.models = @[filterModel1,filterModel2];
    
    [filterView show];
    
    filterView.selectBlock = ^(NSArray<NSIndexPath *> *indexPaths) {
        NSLog(@"%@",indexPaths);
    };
}

@end
