//
//  ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/27.
//

#import "ViewController.h"
#import "Table1ViewController.h"
#import "Table2ViewController.h"
#import "Table3ViewController.h"
#import "NormalViewController.h"
#import "THKUserCenterHeaderView.h"
@interface ViewController ()

@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

- (void)back{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"123";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.vcs = [[@[Table1ViewController.class,
                       Table2ViewController.class,
                       Table3ViewController.class,
                       NormalViewController.class].rac_sequence map:^id _Nullable(Class cls) {
                            return [[cls alloc] init];
                       }] array];
        self.titles = @[@"热门",@"最新",@"涉及",@"案例"];
        
        [self reloadData];
    });
}

-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (NSArray<__kindof UIViewController *> *)childViewControllers{
    return self.vcs;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    return self.titles;
}

- (CGFloat)heightForHeader{
    THKUserCenterHeaderViewModel *viewModel = [[THKUserCenterHeaderViewModel alloc] init];
    return viewModel.viewHeight;
}

- (UIView *)viewForHeader{
    THKUserCenterHeaderViewModel *viewModel = [[THKUserCenterHeaderViewModel alloc] init];
    THKUserCenterHeaderView *view = [[THKUserCenterHeaderView alloc] initWithViewModel:viewModel];
    return view;
}

@end
