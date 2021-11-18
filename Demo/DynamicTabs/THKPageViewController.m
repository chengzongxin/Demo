//
//  THKPageViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import "THKPageViewController.h"
#import "THKPageScrollView.h"

#define kLESS_THAN_iOS11 ([[UIDevice currentDevice].systemVersion floatValue] < 11.0 ? YES : NO)

@interface THKPageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) THKPageViewModel *viewModel;
/// 页面ScrollView
@property (nonatomic, strong) THKPageScrollView *pageScrollView;
/// 展示控制器的字典
@property (nonatomic, strong) NSMutableDictionary *displayDictM;
/// 原始InsetBottom
@property (nonatomic, strong) NSMutableDictionary *originInsetBottomDictM;
/// 字典控制器的缓存
@property (nonatomic, strong) NSMutableDictionary *cacheDictM;
/// 字典ScrollView的缓存
@property (nonatomic, strong) NSMutableDictionary *scrollViewCacheDictionryM;
/// 当前显示的页面
@property (nonatomic, strong) UIScrollView *currentScrollView;
/// 当前控制器
@property (nonatomic, strong) UIViewController *currentViewController;
/// 上次偏移的位置
@property (nonatomic, assign) CGFloat lastPositionX;
/// TableView距离顶部的偏移量
@property (nonatomic, assign) CGFloat insetTop;

@end

@implementation THKPageViewController
@dynamic viewModel;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)bindViewModel{
    [self initData];
    
    if (self.controllersM.count == 0) {
        return;
    }
    
    [self checkParams];
    [self setupSubViews];
    [self setSelectedPageIndex:self.pageIndex];
}

- (void)initData {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.displayDictM = @{}.mutableCopy;
    self.cacheDictM = @{}.mutableCopy;
    self.originInsetBottomDictM = @{}.mutableCopy;
    self.scrollViewCacheDictionryM = @{}.mutableCopy;
}

/// 初始化子View
- (void)setupSubViews {
    [self setupPageScrollView];
}

/// 初始化PageScrollView
- (void)setupPageScrollView {
    CGFloat cutOutHeight = self.viewModel.cutOutHeight > 0 ? self.viewModel.cutOutHeight : 0;
    CGFloat contentHeight = TMUI_SCREEN_HEIGHT - cutOutHeight;
    
    self.pageScrollView.frame = CGRectMake(0, 0, TMUI_SCREEN_WIDTH, contentHeight);
    
    self.pageScrollView.contentSize = CGSizeMake(TMUI_SCREEN_WIDTH * self.controllersM.count, contentHeight);
    
    self.viewModel.contentHeight = self.pageScrollView.height - self.viewModel.menuHeight;
    if (kLESS_THAN_iOS11) {
        [self.view addSubview:[UIView new]];
    }
    [self.view addSubview:self.pageScrollView];
}


#pragma mark - 初始化子控制器
- (void)initViewControllerWithIndex:(NSInteger)index {
    self.currentViewController = self.controllersM[index];

    self.pageIndex = index;
    NSString *title = [self titleWithIndex:index];
    if ([self.displayDictM objectForKey:[self getKeyWithTitle:title]]) return;
    
    UIViewController *cacheViewController = [self.cacheDictM objectForKey:[self getKeyWithTitle:title]];
    [self addViewControllerToParent:cacheViewController ?: self.controllersM[index] index:index];
}

/// 添加到父类控制器中
- (void)addViewControllerToParent:(UIViewController *)viewController index:(NSInteger)index {
    [self addChildViewController:self.controllersM[index]];
    
    viewController.view.frame = CGRectMake(TMUI_SCREEN_WIDTH * index, 0, self.pageScrollView.width, self.pageScrollView.height);
    
    [self.pageScrollView addSubview:viewController.view];
    
    NSString *title = [self titleWithIndex:index];
    
    [self.displayDictM setObject:viewController forKey:[self getKeyWithTitle:title]];
    
    UIScrollView *scrollView = self.currentScrollView;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageViewController:heightForScrollViewAtIndex:)]) {
        CGFloat scrollViewHeight = [self.dataSource pageViewController:self heightForScrollViewAtIndex:index];
        scrollView.frame = CGRectMake(0, 0, viewController.view.width, scrollViewHeight);
    } else {
        scrollView.frame = viewController.view.bounds;
    }
    
    [viewController didMoveToParentViewController:self];
    
    /// 缓存控制器
    if (![self.cacheDictM objectForKey:[self getKeyWithTitle:title]]) {
        [self.cacheDictM setObject:viewController forKey:[self getKeyWithTitle:title]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

/// scrollView滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self removeViewController];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didEndDecelerating:)]) {
        [self.delegate pageViewController:self didEndDecelerating:scrollView];
    }
}

/// scrollView滚动ing
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentPostion = scrollView.contentOffset.x;

    CGFloat offsetX = currentPostion / TMUI_SCREEN_WIDTH;

    CGFloat offX = currentPostion > self.lastPositionX ? ceilf(offsetX) : offsetX;

    [self initViewControllerWithIndex:offX];

    CGFloat progress = offsetX - (NSInteger)offsetX;

    self.lastPositionX = currentPostion;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didScroll:progress:formIndex:toIndex:)]) {
        [self.delegate pageViewController:self didScroll:scrollView progress:progress formIndex:floor(offsetX) toIndex:ceilf(offsetX)];
    }
}

#pragma mark - yn_pageScrollViewDidScrollView
- (void)yn_pageScrollViewDidScrollView:(UIScrollView *)scrollView {
    [self invokeDelegateForScrollWithOffsetY:scrollView.contentOffset.y];
}

#pragma mark - Public Method
- (void)setSelectedPageIndex:(NSInteger)pageIndex {
    if (self.cacheDictM.count > 0 && pageIndex == self.pageIndex) return;
    
    if (pageIndex > self.controllersM.count - 1) return;
    
    CGRect frame = CGRectMake(self.pageScrollView.width * pageIndex, 0, self.pageScrollView.width, self.pageScrollView.height);
    if (frame.origin.x == self.pageScrollView.contentOffset.x) {
        [self scrollViewDidScroll:self.pageScrollView];
    } else {
        [self.pageScrollView scrollRectToVisible:frame animated:NO];
    }
    
    [self scrollViewDidEndDecelerating:self.pageScrollView];
}

- (void)reloadData {
    [self checkParams];
    
    self.pageIndex = self.pageIndex < 0 ? 0 : self.pageIndex;
    self.pageIndex = self.pageIndex >= self.controllersM.count ? self.controllersM.count - 1 : self.pageIndex;
    
    for (UIViewController *vc in self.displayDictM.allValues) {
        [self removeViewControllerWithChildVC:vc];
    }
    [self.displayDictM removeAllObjects];
    
    [self.originInsetBottomDictM removeAllObjects];
    [self.cacheDictM removeAllObjects];
    [self.scrollViewCacheDictionryM removeAllObjects];
    [self.pageScrollView removeFromSuperview];
    
    [self setupSubViews];
    
    [self setSelectedPageIndex:self.pageIndex];
}

- (void)insertPageChildControllersWithTitles:(NSArray *)titles
                                 controllers:(NSArray *)controllers
                                       index:(NSInteger)index {
    index = index < 0 ? 0 : index;
    index = index > self.controllersM.count ? self.controllersM.count : index;
    NSInteger tarIndex = index;
    BOOL insertSuccess = NO;
    if (titles.count == controllers.count && controllers.count > 0) {
        for (int i = 0; i < titles.count; i++) {
            NSString *title = titles[i];
            if (title.length == 0 || ([self.titlesM containsObject:title] && ![self respondsToCustomCachekey])) {
                continue;
            }
            insertSuccess = YES;
            [self.titlesM insertObject:title atIndex:tarIndex];
            [self.controllersM insertObject:controllers[i] atIndex:tarIndex];
            tarIndex ++;
        }
    }
    if (!insertSuccess) return;
    NSInteger pageIndex = index > self.pageIndex ? self.pageIndex : self.pageIndex + controllers.count;
    
    [self updateViewWithIndex:pageIndex];
}

- (void)updateViewWithIndex:(NSInteger)pageIndex {
    self.pageScrollView.contentSize = CGSizeMake(TMUI_SCREEN_WIDTH * self.controllersM.count, self.pageScrollView.height);
    
    UIViewController *vc = self.controllersM[pageIndex];
    
    vc.view.x = TMUI_SCREEN_WIDTH * pageIndex;
    
    CGRect frame = CGRectMake(self.pageScrollView.width * pageIndex, 0, self.pageScrollView.width, self.pageScrollView.height);
    
    [self.pageScrollView scrollRectToVisible:frame animated:NO];
    
    [self scrollViewDidEndDecelerating:self.pageScrollView];
    
    self.pageIndex = pageIndex;
}

- (void)removePageControllerWithTitle:(NSString *)title {
    if ([self respondsToCustomCachekey]) return;
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.titlesM.count; i++) {
        if ([self.titlesM[i] isEqualToString:title]) {
            index = i;
            break;
        }
    }
    if (index == -1) return;
    [self removePageControllerWithIndex:index];
}

- (void)removePageControllerWithIndex:(NSInteger)index {
    if (index < 0 || index >= self.titlesM.count || self.titlesM.count == 1) return;
    NSInteger pageIndex = 0;
    if (self.pageIndex >= index) {
        pageIndex = self.pageIndex - 1;
        if (pageIndex < 0) {
            pageIndex = 0;
        }
    }
    /// 等于 0 先选中 + 1个才能移除
    if (pageIndex == 0) {
        [self setSelectedPageIndex:1];
    }
    
    NSString *title = self.titlesM[index];
    [self.titlesM removeObject:self.titlesM[index]];
    [self.controllersM removeObject:self.controllersM[index]];
    
    NSString *key = [self getKeyWithTitle:title];
    
    [self.originInsetBottomDictM removeObjectForKey:key];
    [self.scrollViewCacheDictionryM removeObjectForKey:key];
    [self.cacheDictM removeObjectForKey:key];
    
    [self updateViewWithIndex:pageIndex];
}

- (void)replaceTitlesArrayForSort:(NSArray *)titleArray {
    
    BOOL condition = YES;
    for (NSString *str in titleArray) {
        if (![self.titlesM containsObject:str]) {
            condition = NO;
            break;
        }
    }
    if (!condition || titleArray.count != self.titlesM.count) return;
    
    NSMutableArray *resultArrayM = @[].mutableCopy;
    NSInteger currentPage = self.pageIndex;
    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = titleArray[i];
        NSInteger oldIndex = [self.titlesM indexOfObject:title];
        /// 等于上次选择的页面 更换之后的页面
        if (currentPage == oldIndex) {
            self.pageIndex = i;
        }
        [resultArrayM addObject:self.controllersM[oldIndex]];
    }
    
    [self.titlesM removeAllObjects];
    [self.titlesM addObjectsFromArray:titleArray];
    
    [self.controllersM removeAllObjects];
    [self.controllersM addObjectsFromArray:resultArrayM];
    
    [self updateViewWithIndex:self.pageIndex];
}


- (void)scrollToTop:(BOOL)animated {
    [self.currentScrollView setContentOffset:CGPointMake(0, 0) animated:animated];
}

- (void)scrollToContentOffset:(CGPoint)point animated:(BOOL)animated {
    [self.currentScrollView setContentOffset:point animated:animated];
}

#pragma mark - Private Method
/// 检查参数
- (void)checkParams {
#if DEBUG
    NSAssert(self.controllersM.count != 0 || self.controllersM, @"ViewControllers`count is 0 or nil");
    
    NSAssert(self.titlesM.count != 0 || self.titlesM, @"TitleArray`count is 0 or nil,");
    
    NSAssert(self.controllersM.count == self.titlesM.count, @"ViewControllers`count is not equal titleArray!");
#endif
    if (![self respondsToCustomCachekey]) {
        BOOL isHasNotEqualTitle = YES;
        for (int i = 0; i < self.titlesM.count; i++) {
            for (int j = i + 1; j < self.titlesM.count; j++) {
                if (i != j && [self.titlesM[i] isEqualToString:self.titlesM[j]]) {
                    isHasNotEqualTitle = NO;
                    break;
                }
            }
        }
#if DEBUG
        NSAssert(isHasNotEqualTitle, @"TitleArray Not allow equal title.");
#endif
    }
}

/// 移除缓存控制器
- (void)removeViewController {
    NSString *title = [self titleWithIndex:self.pageIndex];
    NSString *displayKey = [self getKeyWithTitle:title];
    for (NSString *key in self.displayDictM.allKeys) {
        if (![key isEqualToString:displayKey]) {
            [self removeViewControllerWithChildVC:self.displayDictM[key] key:key];
        }
    }
}

/// 从父类控制器移除控制器
- (void)removeViewControllerWithChildVC:(UIViewController *)childVC key:(NSString *)key {
    [self removeViewControllerWithChildVC:childVC];
    [self.displayDictM removeObjectForKey:key];
    if (![self.cacheDictM objectForKey:key]) {
        [self.cacheDictM setObject:childVC forKey:key];
    }
}

/// 添加子控制器
- (void)addChildViewControllerWithChildVC:(UIViewController *)childVC parentVC:(UIViewController *)parentVC {
    [parentVC addChildViewController:childVC];
    [parentVC didMoveToParentViewController:childVC];
    [parentVC.view addSubview:childVC.view];
}

/// 子控制器移除自己
- (void)removeViewControllerWithChildVC:(UIViewController *)childVC {
    [childVC.view removeFromSuperview];
    [childVC willMoveToParentViewController:nil];
    [childVC removeFromParentViewController];
}


- (BOOL)respondsToCustomCachekey {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageViewController:customCacheKeyForIndex:)]) {
        return YES;
    }
    return NO;
}

- (NSString *)titleWithIndex:(NSInteger)index {
    return self.titlesM[index];
}

- (NSInteger)getPageIndexWithTitle:(NSString *)title {
    return [self.titlesM indexOfObject:title];
}

- (NSString *)getKeyWithTitle:(NSString *)title {
    if ([self respondsToCustomCachekey]) {
        NSString *ID = [self.dataSource pageViewController:self customCacheKeyForIndex:self.pageIndex];
        return ID;
    }
    return title;
};


/**
 *  当前PageScrollViewVC作为子控制器
 *
 *  @param parentViewControler 父类控制器
 */
- (void)addSelfToParentViewController:(UIViewController *)parentViewControler {
    [self addChildViewControllerWithChildVC:self parentVC:parentViewControler];
}

/**
 *  从父类控制器里面移除自己（PageScrollViewVC）
 */
- (void)removeSelfViewController {
    [self removeViewControllerWithChildVC:self];
}


#pragma mark - Invoke Delegate Method
/// 回调监听列表滚动代理
- (void)invokeDelegateForScrollWithOffsetY:(CGFloat)offsetY {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:contentOffsetY:progress:)]) {
        [self.delegate pageViewController:self contentOffsetY:offsetY progress:1];
    }
}

#pragma mark - Lazy Method

- (THKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[THKPageScrollView alloc] init];
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.scrollEnabled = self.viewModel.pageScrollEnabled;
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.bounces = NO;
        _pageScrollView.delegate = self;
        _pageScrollView.backgroundColor = [UIColor whiteColor];
        _pageScrollView.tmui_isWarpperNotScroll = YES;
        if (@available(iOS 11.0, *)) {
            _pageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _pageScrollView;
}

/// 当前滚动的ScrollView
- (UIScrollView *)currentScrollView {
    return [self getScrollViewWithPageIndex:self.pageIndex];
}

/// 根据pageIndex 取 数据源 ScrollView
- (UIScrollView *)getScrollViewWithPageIndex:(NSInteger)pageIndex {
    NSString *title = [self titleWithIndex:self.pageIndex];
    NSString *key = [self getKeyWithTitle:title];
    UIScrollView *scrollView = nil;
    
    if (![self.scrollViewCacheDictionryM objectForKey:key]) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageViewController:pageForIndex:)]) {
            scrollView = [self.dataSource pageViewController:self pageForIndex:pageIndex];
//            scrollView.yn_observerDidScrollView = YES;
//            __weak typeof(self) weakSelf = self;
//            scrollView.yn_pageScrollViewDidScrollView = ^(UIScrollView *scrollView) {
//                [weakSelf yn_pageScrollViewDidScrollView:scrollView];
//            };
//            if (self.viewModel.pageStyle == THKPageStyleSuspensionTopPause) {
//                scrollView.yn_pageScrollViewBeginDragginScrollView = ^(UIScrollView *scrollView) {
//                    [weakSelf yn_pageScrollViewBeginDragginScrollView:scrollView];
//                };
//            }
            if (@available(iOS 11.0, *)) {
                if (scrollView) {
                    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                }
            }
        }
    } else {
        return [self.scrollViewCacheDictionryM objectForKey:key];
    }
#if DEBUG
    NSAssert(scrollView != nil, @"请设置pageViewController 的数据源！");
#endif
    [self.scrollViewCacheDictionryM setObject:scrollView forKey:key];
    return scrollView;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"----%@----dealloc", [self class]);
#endif
}
@end
