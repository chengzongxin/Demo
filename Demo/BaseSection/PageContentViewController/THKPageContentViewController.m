//
//  ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKPageContentViewController.h"
#import "TDCCaseDetailContentView.h"
#import "THKSegmentControl.h"
#import "THKColorsDefine.h"
#import "THKCommonDefine.h"


static const CGFloat kSliderBarHeight = 50;


@interface THKPageContentViewController () <UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>

// component
//@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) TDCCaseDetailContentView *contentView;
@property (nonatomic, strong) THKSegmentControl *slideBar;

// delegate
@property (nonatomic, strong) NSArray <UIViewController *>*childVCs;
@property (nonatomic, strong) NSArray <NSString *>*titles;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, weak) UIView *headerView;

// private
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIViewController *preVC;
@property (nonatomic, strong) UIViewController *toVC;

@end

@implementation THKPageContentViewController

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initial];
}

- (void)initial{
    self.currentIndex = 0;
    self.dataSource = self;
    self.delegate = self;
}

- (void)reloadData{
    [self fetchDataSource];
    
    [self addSubviews];
    
    [self makeConstraints];
}

- (void)fetchDataSource{
    self.childVCs = [self childViewControllers];
    self.titles = [self titlesForChildViewControllers];
    
    if ([self respondsToSelector:@selector(viewForHeader)]) {
        self.headerView = [self viewForHeader];
    }
    
    if ([self respondsToSelector:@selector(heightForHeader)]) {
        self.headerHeight = [self heightForHeader];
    }
    
//    [self.pageViewController setViewControllers:@[self.childVCs[self.currentIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.contentScrollView addSubview:self.childVCs[self.currentIndex].view];
    self.contentScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * self.childVCs.count, 0);
}

// 子视图布局
- (void)addSubviews {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.slideBar];
    [self.contentView addSubview:self.contentScrollView];
//    [self.contentView addSubview:self.pageViewController.view];
//    [self addChildViewController:self.pageViewController];
}

// 设置约束
- (void)makeConstraints{
    self.contentView.contentInset = UIEdgeInsetsMake(self.headerHeight+kSliderBarHeight, 0, 0, 0);
    self.contentView.contentSize = self.view.bounds.size;
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.mas_equalTo(-self.headerHeight-kSliderBarHeight);
        make.height.mas_equalTo(self.headerHeight);
        make.width.mas_equalTo(self.view.bounds.size.width);
    }];
    
    [self.slideBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(kSliderBarHeight);
        make.width.mas_equalTo(self.view.bounds.size.width);
    }];
    
//    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.slideBar.mas_bottom);
//        make.left.bottom.right.equalTo(self.view);
//    }];
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slideBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
}

#pragma mark - Public

#pragma mark - Event Respone
- (void)btnClick:(THKSegmentControl *)control{
    NSUInteger index = control.selectedIndex;
    UIPageViewControllerNavigationDirection direction;
    if (index > self.currentIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    self.currentIndex = index;
    
    CGFloat x = index * [UIScreen mainScreen].bounds.size.width;
    
    [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
//    [self.pageViewController setViewControllers:@[self.childVCs[index]] direction:direction animated:YES completion:nil];
    UIViewController *vc = self.childVCs[index];
    if (vc.view.superview) {
        [vc viewWillAppear:YES];
        return;
    }
    
    vc.view.frame = CGRectMake(x, 0, [UIScreen mainScreen].bounds.size.width  , self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:vc.view];
    
//    CGFloat x = index * [UIScreen mainScreen].bounds.size.width;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    // 显示VC
}


#pragma mark - Delegate
#pragma mark ==========外部代理方法 给子类实现==========
- (NSArray<__kindof UIViewController *> *)childViewControllers{
    NSAssert(0, @"childViewControllers 方法未实现");
    return nil;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    NSAssert(0, @"titlesForChildViewControllers 方法未实现");
    return nil;
}

- (CGFloat)heightForHeader{
    self.contentView.bounces = NO;
    return 0;
}

- (UIView *)viewForHeader{
    return UIView.new;
}

- (void)pageContentViewControllerDidScrolFrom:(NSInteger)fromVC to:(NSInteger)toVC {}

- (void)pageContentViewControllerDidScroll:(UIScrollView *)scrollView {}


#pragma mark ==========内部代理方法 PageVCDelegate==========
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
    self.toVC = pendingViewControllers.firstObject;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    self.preVC = previousViewControllers.firstObject;
    
    if (!completed || !self.preVC || !self.toVC || self.preVC == self.toVC) return;
    
    NSInteger preIndex = [self indexOfViewController:self.preVC];
    NSInteger toIndex = [self indexOfViewController:self.toVC];
    
    if ([self respondsToSelector:@selector(pageContentViewControllerDidScrolFrom:to:)]) {
        [self pageContentViewControllerDidScrolFrom:preIndex to:toIndex];
    }
    
    self.slideBar.selectedIndex = toIndex;
    self.currentIndex = toIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self pageContentViewControllerDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        // 获取当前角标
        NSInteger i = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
        
        self.slideBar.selectedIndex = i;
    }
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
        _contentView.lockArea = kTNavigationBarHeight()+kSliderBarHeight;
        //        _contentView.otherDelegate = self;
        _contentView.t_delegate = self;
    }
    return _contentView;
}

//- (UIPageViewController *)pageViewController {
//
//    if (!_pageViewController) {
//        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(10)};
//        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
//                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
//                                                                            options:options];
//        _pageViewController.dataSource = self;
//        _pageViewController.delegate = self;
//    }
//
//    return _pageViewController;
//}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        // 创建contentScrollView
        _contentScrollView = [[UIScrollView alloc] init];
//        CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
//        CGFloat height = self.view.bounds.size.height - y;
//        if (self.header) {
//            height = ScreenH - (kStatusH + kNavbarH + _titleScrollView.height);
//        }
//        contentScrollView.frame = CGRectMake(0, y, self.view.bounds.size.width, height);
//        [self.containerView addSubview:contentScrollView];
//        _contentScrollView = contentScrollView;
        
        // 设置contentScrollView的属性
        // 分页
        _contentScrollView.pagingEnabled = YES;
        // 弹簧
        _contentScrollView.bounces = YES;
        // 指示器
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        
        // 设置代理.目的:监听内容滚动视图 什么时候滚动完成
        _contentScrollView.delegate = self;
        _contentScrollView.tag = 888;
    }
    return _contentScrollView;
}

- (THKSegmentControl *)slideBar {
    if (!_slideBar) {
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, kSliderBarHeight);
        _slideBar = [[THKSegmentControl alloc] initWithFrame:frame titles:self.titles];
        _slideBar.backgroundColor = [UIColor whiteColor];
        _slideBar.indicatorView.backgroundColor = THKColor_TextImportantColor;
        _slideBar.indicatorView.layer.cornerRadius = 0.0;
        [_slideBar setTitleFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium] forState:UIControlStateNormal];
        [_slideBar setTitleFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium] forState:UIControlStateSelected];
        [_slideBar setTitleColor:THKColor_TextWeakColor forState:UIControlStateNormal];
        [_slideBar setTitleColor:THKColor_TextImportantColor forState:UIControlStateSelected];
        [_slideBar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _slideBar;
}


#pragma mark - Supperclass

#pragma mark - NSObject

@end
