//
//  SectionViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "SectionViewController.h"
#import "Table1ViewController.h"
#import "Table2ViewController.h"
#import "Table3ViewController.h"
#import "NormalViewController.h"

@interface SectionViewController ()

@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation SectionViewController

#pragma mark - Lifecycle 

// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"23";
    self.edgesForExtendedLayout = UIRectEdgeAll;
//    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.vcs = [[@[Table1ViewController.class,
                   Table2ViewController.class,
                   Table3ViewController.class,
                   NormalViewController.class].rac_sequence map:^id _Nullable(Class cls) {
        return [[cls alloc] init];
    }] array];
    self.titles = @[@"热门",@"最新",@"涉及",@"案例"];
    
    [self reloadData];
}


- (NSArray<__kindof UIViewController *> *)viewControllersForChildViewControllers{
    return self.vcs;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    return self.titles;
}

//- (CGFloat)heightForNavBar{
//    return 44;
//}

- (void)segmentControlConfig:(THKSegmentControl *)control{
    control.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    control.autoAlignmentCenter = YES;
    control.backgroundColor = [UIColor orangeColor];
    control.indicatorView.backgroundColor = UIColor.blueColor;
    control.indicatorView.layer.cornerRadius = 0.0;
    [control setTitleFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] forState:UIControlStateNormal];
    [control setTitleFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] forState:UIControlStateSelected];
    [control setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [control setTitleColor:UIColor.greenColor forState:UIControlStateSelected];
    control.height = 40;
}

- (CGFloat)heightForHeader{
    return 300;
}

- (UIView *)viewForHeader{
    UIView *view = View.bgColor(@"random");
    return view;
}


@end
