//
//  ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKPageContentViewController.h"
#import "TDCCaseDetailContentView.h"

#define kHeaderImageViewHeight ((227.0 / 375.0) * self.view.bounds.size.width)
#define kHeaderHeight (kHeaderImageViewHeight + 56.0 + 8.0)

@interface THKPageContentViewController () <UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) TDCCaseDetailContentView *contentView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray <UIViewController *>*childVCs;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIViewController *preVC;
@property (nonatomic, strong) UIViewController *toVC;

@end

@implementation THKPageContentViewController

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thk_addSubviews];
}

// 子视图布局
- (void)thk_addSubviews {
    
    self.dataSource = self;
    self.delegate = self;
    
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
    self.childVCs = [self childViewControllers];
    self.currentIndex = 0;
    UIButton *btn = self.headerView.subviews[self.currentIndex];
    btn.selected = YES;
    [self.pageViewController setViewControllers:@[self.childVCs[self.currentIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}


#pragma mark - Public

#pragma mark - Event Respone
- (void)btnClick:(UIButton *)btn{
    NSUInteger index = btn.tag;
    
    UIButton *preBtn = _headerView.subviews[self.currentIndex];
    preBtn.selected = NO;
    btn.selected = YES;
    
    
    UIPageViewControllerNavigationDirection direction;
    if (index > self.currentIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    self.currentIndex = index;
    [self.pageViewController setViewControllers:@[self.childVCs[index]] direction:direction animated:YES completion:nil];
}


#pragma mark - Delegate
// 给子类实现
- (NSArray<__kindof UIViewController *> *)childViewControllers{
    return self.childVCs;
}

- (void)pageContentViewController:(THKPageContentViewController *)pageVC from:(NSInteger)fromVC to:(NSInteger)toVC{
    
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
    self.currentIndex = index;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.childVCs count]) {
        return nil;
    }
    self.currentIndex = index;
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
//    NSLog(@"%@",pendingViewControllers);
    self.toVC = pendingViewControllers.firstObject;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
//    NSLog(@"%@",previousViewControllers);
    self.preVC = previousViewControllers.firstObject;
    
    if (!self.preVC || !self.toVC || self.preVC == self.toVC) return;
    
    NSInteger preIndex = [self indexOfViewController:self.preVC];
    NSInteger toIndex = [self indexOfViewController:self.toVC];
    
    UIButton *preBtn = self.headerView.subviews[preIndex];
    UIButton *toBtn = self.headerView.subviews[toIndex];

    preBtn.selected = NO;
    toBtn.selected = YES;
    self.currentIndex = toIndex;
    NSLog(@"%zd-%zd",preIndex,toIndex);
}


#pragma mark - Private

#pragma mark 数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.childVCs indexOfObject:viewController];
}

#pragma mark 根据index得到对应的UIViewController
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.childVCs count] == 0) || (index >= [self.childVCs count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    return self.childVCs[index];
}




#pragma mark - Getters and Setters


- (TDCCaseDetailContentView *)contentView {
    if (_contentView == nil) {
        _contentView = [[TDCCaseDetailContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.lockArea = 88;
//        _contentView.otherDelegate = self;
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
        _pageViewController.delegate = self;
    }
    
    return _pageViewController;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, - kHeaderHeight, self.view.bounds.size.width, kHeaderHeight)];
        _headerView.backgroundColor = UIColor.orangeColor;
    
        for (int i = 0; i< 4; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.backgroundColor = UIColor.whiteColor;
            btn.frame = CGRectMake(i * (60 + 10), kHeaderHeight - 44, 60, 44);
            [btn setTitle:@(i).stringValue forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:btn];
        }    }
    return _headerView;
}


#pragma mark - Supperclass

#pragma mark - NSObject

@end
