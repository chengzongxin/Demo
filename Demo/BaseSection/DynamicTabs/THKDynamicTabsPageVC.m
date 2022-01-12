//
//  THKPageViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import "THKDynamicTabsPageVC.h"

#define kLESS_THAN_iOS11 ([[UIDevice currentDevice].systemVersion floatValue] < 11.0 ? YES : NO)

@interface THKDynamicTabsPageVC ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) THKDynamicTabsPageVM *viewModel;
/// 页面ScrollView
@property (nonatomic, strong) THKDynamicTabsScrollView *pageScrollView;
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

///切换多个tab时，需要先锁定,(修复：先定位到前一个，然后才定位到选中那一个，比如1->4，会先到3，才会到4)
@property (nonatomic, assign) BOOL lockChangeMoreTab;

///禁止动画执行，重新初始化切换到指定tab时，不需要动画
@property (nonatomic, assign) BOOL disAnimation;

@end

@implementation THKDynamicTabsPageVC
@dynamic viewModel;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.geDisableAutoTrack = YES;
}

- (void)bindViewModel{
    [self initData];
    
    // 吸顶后禁止滚动
    RAC(self.pageScrollView,isEnableInfiniteScroll) = RACObserve(self.viewModel, isEnableInfiniteScroll);
    RAC(self.pageScrollView,scrollEnabled) = RACObserve(self.viewModel, pageScrollEnabled);
    
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
    
    if (kLESS_THAN_iOS11) {
        [self.view addSubview:[UIView new]];
    }
    [self.view addSubview:self.pageScrollView];
}


#pragma mark - 初始化子控制器
- (void)initViewControllerWithIndex:(NSInteger)index {
    UIViewController *vc = [self.controllersM safeObjectAtIndex:index];
    if (!vc) {
        NSAssert(!vc, @"controllersM is invalid");
        return;
    }
    self.currentViewController = vc;

    self.pageIndex = index;
    NSString *title = [self titleWithIndex:index];
    if ([self.displayDictM objectForKey:[self getKeyWithTitle:title]]) return;
    
    UIViewController *cacheViewController = [self.cacheDictM objectForKey:[self getKeyWithTitle:title]];
    [self addViewControllerToParent:cacheViewController ?: self.controllersM[index] index:index];
}

/// 添加到父类控制器中
- (void)addViewControllerToParent:(UIViewController *)viewController index:(NSInteger)index {
    UIViewController *vc = [self.controllersM safeObjectAtIndex:index];
    if (!vc) {
        return;
    }
    
    [self addChildViewController:self.controllersM[index]];
    viewController.view.frame = CGRectMake(TMUI_SCREEN_WIDTH * index, 0, self.pageScrollView.width, self.pageScrollView.height);
    
    [self.pageScrollView addSubview:viewController.view];
    
    NSString *title = [self titleWithIndex:index];
    
    [self.displayDictM setObject:viewController forKey:[self getKeyWithTitle:title]];
    
    UIScrollView *scrollView = self.currentScrollView;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageViewController:heightForScrollViewAtIndex:)]) {
        CGFloat scrollViewHeight = [self.dataSource pageViewController:self heightForScrollViewAtIndex:index];
        if (scrollView != viewController.view) {
            // 除开根视图就是ScrollView的情况
            scrollView.frame = CGRectMake(0, 0, viewController.view.width, scrollViewHeight);
        }
    } else {
        if (scrollView != viewController.view) {
            // 除开根视图就是ScrollView的情况
            scrollView.frame = viewController.view.bounds;
        }
    }
    
    [viewController didMoveToParentViewController:self];
    
    /// 缓存控制器
    if (![self.cacheDictM objectForKey:[self getKeyWithTitle:title]]) {
        [self.cacheDictM setObject:viewController forKey:[self getKeyWithTitle:title]];
    }
}

#pragma mark - UIScrollViewDelegate

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if (gestureRecognizer.view == self.pageScrollView) {
//        UIViewController <THKDynamicTabsPageVCDelegate> *vc = [self.controllersM safeObjectAtIndex:self.pageIndex];
//        if ([vc respondsToSelector:@selector(pageViewControllerSholdScroll:)]) {
//            return [vc pageViewControllerSholdScroll:self];
//        }
//        return YES;
//    }
//    return YES;
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!self.lockChangeMoreTab && self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didEndDecelerating:)]) {
        [self.delegate pageViewController:self didEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

/// scrollView滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self removeViewController];
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didEndDecelerating:)]) {
//        [self.delegate pageViewController:self didEndDecelerating:scrollView];
//    }
    if (!self.lockChangeMoreTab && self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didEndDecelerating:)]) {
        [self.delegate pageViewController:self didEndDecelerating:scrollView];
    }
}
// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.lockChangeMoreTab && self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didEndDecelerating:)]) {
        [self.delegate pageViewController:self didEndDecelerating:scrollView];
    }
}

/// scrollView滚动ing
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentPostion = scrollView.contentOffset.x;
    
    int screenW = (int)TMUI_SCREEN_WIDTH;
    
    CGFloat offsetX = currentPostion / screenW;
    
    BOOL scrollMore = currentPostion > self.lastPositionX;

    CGFloat offX = scrollMore ? ceilf(offsetX) : offsetX;
 
    NSInteger oldPageIndex = self.pageIndex;
    // 添加VC
    [self initViewControllerWithIndex:offX];
    
    CGFloat lastOffsetX = currentPostion - self.lastPositionX;
    
    self.lastPositionX = currentPostion;
    
    NSInteger from = scrollMore ? floor(offsetX) : ceilf(offsetX);
    NSInteger to = scrollMore ? ceilf(offsetX) : floor(offsetX);
    CGFloat mod = (offsetX - (NSInteger)offsetX);
    CGFloat progress;
    if (mod == 0) {
        // 翻了整页，点击tab的时候会出现
        progress = 1;
        // 此时from和to相等，需要处理上次的值
        int pageNum = MAX(1, abs((int)(lastOffsetX / screenW)));
        if (lastOffsetX > 0) {
            pageNum *= -1;
        }
        from = to + pageNum;
        
    }else{
        progress = scrollMore ? mod : (1 - mod);
    }
    
    // 如果相等，说明是点击tab直接移动过来，而不是滑动切换过来的
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didScroll:progress:formIndex:toIndex:)]) {
        [self.delegate pageViewController:self didScroll:scrollView progress:progress formIndex:from toIndex:to];
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
        NSInteger oldPageIndex = self.pageIndex;
        [self.pageScrollView scrollRectToVisible:frame animated:NO];
        
        //tbt Code
//        if (self.disAnimation) {
//            [self.pageScrollView scrollRectToVisible:frame animated:NO];
//        }else{
//            if (labs(pageIndex - self.pageIndex) > 1) {
//                NSInteger prePage = pageIndex -1;
//                if (pageIndex < self.pageIndex) {
//                    prePage = pageIndex + 1;
//                }
//                if (prePage > 0 && prePage < self.controllersM.count - 1) {
//                    CGRect frame1 = CGRectMake(self.pageScrollView.width * (prePage), 0, self.pageScrollView.width, self.pageScrollView.height);
//                    self.lockChangeMoreTab = YES;
//                    [self.pageScrollView scrollRectToVisible:frame1 animated:NO];
//                }
//            }
//            [self.pageScrollView scrollRectToVisible:frame animated:self.pageIndex!=pageIndex];
//        }
//        // 直接点击切换,需要先切换，否则会改变
//        if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didScroll:progress:formIndex:toIndex:)]) {
//            [self.delegate pageViewController:self didScroll:self.pageScrollView progress:0 formIndex:oldPageIndex toIndex:pageIndex];
//        }

    }
    
    [self scrollViewDidEndDecelerating:self.pageScrollView];
    self.lockChangeMoreTab = NO;
}

- (void)reloadData {
    [self checkParams];
    
//    self.pageIndex = self.pageIndex < 0 ? 0 : self.pageIndex;
//    self.pageIndex = self.pageIndex >= self.controllersM.count ? self.controllersM.count - 1 : self.pageIndex;
//    self.pageIndex = self.pageIndex < 0 ? 0 : self.pageIndex;
    
    self.pageIndex = self.pageIndex < 0 ? 0 : self.pageIndex;
    self.pageIndex = self.pageIndex >= self.controllersM.count ? self.controllersM.count - 1 : self.pageIndex;
//    self.pageIndex = self.pageIndex < 0 ? 0 : self.pageIndex;
    NSInteger pageIndex = self.pageIndex;
    
    for (UIViewController *vc in self.displayDictM.allValues) {
        [self removeViewControllerWithChildVC:vc];
    }
    [self.displayDictM removeAllObjects];
    
    [self.originInsetBottomDictM removeAllObjects];
    [self.cacheDictM removeAllObjects];
    [self.scrollViewCacheDictionryM removeAllObjects];
    [self.pageScrollView removeFromSuperview];
    
    [self setupSubViews];
    //从9个tab变成8个tab，会有问题，所以要个用reloading字段判断，滑动到初始tab时不用动画
    //使用pageIndex的原因是self.pageIndex会被动态改变
    self.disAnimation = YES;
    [self setSelectedPageIndex:pageIndex];
    //self.disAnimation = NO;

//    [self setSelectedPageIndex:self.pageIndex];
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
    
    UIViewController *vc = [self.controllersM safeObjectAtIndex:pageIndex];
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
        //NSAssert(isHasNotEqualTitle, @"TitleArray Not allow equal title.");
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

- (THKDynamicTabsScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[THKDynamicTabsScrollView alloc] init];
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.scrollEnabled = self.viewModel.pageScrollEnabled;
        _pageScrollView.isEnableInfiniteScroll = self.viewModel.isEnableInfiniteScroll;
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.bounces = NO;
        _pageScrollView.delegate = self;
        _pageScrollView.backgroundColor = [UIColor whiteColor];
        _pageScrollView.thk_isWarpperNotScroll = YES;
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
    
    if (scrollView) {
        [self.scrollViewCacheDictionryM setObject:scrollView forKey:key];
    }
    
//#if DEBUG
//    NSAssert(scrollView != nil, @"请设置pageViewController 的数据源！");
//#endif
//    [self.scrollViewCacheDictionryM setObject:scrollView forKey:key];
    return scrollView;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"----%@----dealloc", [self class]);
#endif
}
@end
