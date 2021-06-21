//
//  THKMaterialClassificationVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationVC.h"
#import "Table1ViewController.h"
#import "Table2ViewController.h"
#import "Table3ViewController.h"
#import "NormalViewController.h"

@interface THKMaterialClassificationVC ()

@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation THKMaterialClassificationVC

#pragma mark - Lifecycle 

// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"家电";
    self.vcs = [[@[Table1ViewController.class,
                   Table2ViewController.class,
                   NormalViewController.class].rac_sequence map:^id _Nullable(Class cls) {
        return [[cls alloc] init];
    }] array];
    self.titles = @[@"推荐榜单",@"好物种草",@"知识百科"];
//
//    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadData];
}


- (NSArray<__kindof UIViewController *> *)viewControllersForChildViewControllers{
    return self.vcs;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    return self.titles;
}

- (void)segmentControlConfig:(THKSegmentControl *)control{
    control.indicatorView.layer.cornerRadius = 0.0;
    control.indicatorView.backgroundColor = UIColorHex(29D181);
    control.indicatorView.height = 5;
    control.indicatorView.width = 14;
    [control setTitleFont:[UIFont systemFontOfSize:16] forState:UIControlStateNormal];
    [control setTitleFont:[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold] forState:UIControlStateSelected];
    [control setTitleColor:UIColorHex(#666666) forState:UIControlStateNormal];
    [control setTitleColor:UIColorHex(#333333) forState:UIControlStateSelected];
    control.height = 54;
}

- (CGFloat)heightForHeader{
    return 113;
}

- (UIView *)viewForHeader{
    UIView *view = View.bgColor(@"random");
    return view;
}


#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters

#pragma mark - Supperclass

#pragma mark - NSObject

@end
