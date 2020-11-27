//
//  ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "ViewController.h"
#import "THKPageViewController.h"
#import "TDCCaseDetailContentView.h"
#import "Table1ViewController.h"
#import "Table2ViewController.h"
#import "Table3ViewController.h"
#import "NormalViewController.h"

#define kHeaderImageViewHeight ((227.0 / 375.0) * self.view.bounds.size.width)
#define kHeaderHeight (kHeaderImageViewHeight + 56.0 + 8.0)

@interface ViewController () <TDCCaseDetailViewDelegate,UIScrollViewDelegate,UIPageViewControllerDataSource,THKPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) TDCCaseDetailContentView *contentView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray <UIViewController *>*childViewControllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thk_addSubviews];
}

// 子视图布局
- (void)thk_addSubviews {
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    self.contentView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    self.contentView.contentSize = self.view.bounds.size;
    
    [self setupChildViewController];
}

- (void)setupChildViewController{
    NSArray *vcClass = @[Table1ViewController.class,
                         Table2ViewController.class,
                         Table3ViewController.class,
                         NormalViewController.class];
    
    NSArray *vcArray = [[vcClass.rac_sequence map:^id _Nullable(Class cls) {
        UIViewController *vc = [[cls alloc] init];
        vc.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        return vc;
    }] array];
    
    
    self.childViewControllers = vcArray;
    [self.pageViewController setViewControllers:@[vcArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark ==========PageVCDelegate==========
//这个方法是返回前一个页面,如果返回为nil,那么UIPageViewController就会认为当前页面是第一个页面不可以向前滚动或翻页

#pragma mark 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.childViewControllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - 数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.childViewControllers indexOfObject:viewController];
}

#pragma mark - 根据index得到对应的UIViewController
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.childViewControllers count] == 0) || (index >= [self.childViewControllers count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    return self.childViewControllers[index];
}

- (TDCCaseDetailContentView *)contentView {
    if (_contentView == nil) {
        _contentView = [[TDCCaseDetailContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.lockArea = 44;
        _contentView.otherDelegate = self;
        _contentView.t_delegate = self;
    }
    return _contentView;
}

- (UIPageViewController *)pageViewController {
    
    if (!_pageViewController) {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(10)};
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                             options:options];
        _pageViewController.dataSource = self;
    }
    
    return _pageViewController;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, - kHeaderHeight, self.view.bounds.size.width, kHeaderHeight)];
        _headerView.backgroundColor = UIColor.orangeColor;
    }
    return _headerView;
}

@end
