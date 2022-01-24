//
//  THKHomeDynamicTabsManager.m
//  HouseKeeper
//
//  Created by collen.zhang on 2021/10/15.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKDynamicTabsManager.h"
#import "THKViewController.h"

@interface THKDynamicTabsManager ()<THKDynamicTabsPageVCDelegate,THKDynamicTabsPageVCDataSource,THKDynamicTabsWrapperScrollViewDelegate>

@property (nonatomic, strong)   THKDynamicTabsViewModel         *viewModel;
@property (nonatomic, strong)   UIView                          *view;
@property (nonatomic, strong)   THKDynamicTabsWrapperScrollView *wrapperScrollView;
@property (nonatomic, strong)   UIView                          *headerWrapperView;
@property (nonatomic, strong)   THKImageTabSegmentControl       *sliderBar;
@property (nonatomic, strong)   THKDynamicTabsPageVC            *pageContainerVC;

///上一次头部的高度
@property (nonatomic, assign)   CGFloat lastHeaderContentViewHeight;

@end

@implementation THKDynamicTabsManager

- (instancetype)initWithViewModel:(THKDynamicTabsViewModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
        [self bindViewModel];
    }
    return self;
}

- (void)bindViewModel {
    [self setupSubviews];
    
    @weakify(self);
    [self.viewModel.tabsResultSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self reloadUI];
    }];
    
    [[RACObserve(self.viewModel, headerContentViewHeight) delay:0] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ( self.viewModel.layout == THKDynamicTabsLayoutType_Suspend && self.headerWrapperView.superview) {
            CGFloat headerH = self.viewModel.headerContentViewHeight;
            CGFloat topH = headerH + self.viewModel.sliderBarHeight;
            
            [self.headerWrapperView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-topH);
                make.height.mas_equalTo(headerH);
            }];
            
            self.wrapperScrollView.contentInset = UIEdgeInsetsMake(topH, 0, 0, 0);
            self.wrapperScrollView.lockArea = self.viewModel.lockArea ?: self.viewModel.sliderBarHeight;
            self.wrapperScrollView.contentSize = CGSizeMake(0, TMUI_SCREEN_HEIGHT + topH);
            // 更新刷新组件位置
            if (self.viewModel.isEnableRefresh) {
                [self setRefreshHeader:self.viewModel.refreshHeaderInset];
            }
            if(self.lastHeaderContentViewHeight < self.viewModel.headerContentViewHeight){
                dispatch_async(dispatch_get_main_queue(), ^{
//                    THKDebugLog(@"self.wrapperScrollView.resetHeaderScrollAnimated = %d",self.wrapperScrollView.resetHeaderScrollAnimated);
                    [self.wrapperScrollView tmui_scrollToTopAnimated:self.wrapperScrollView.resetHeaderScrollAnimated];
                });
            }
            self.lastHeaderContentViewHeight = self.viewModel.headerContentViewHeight;
        }
    }];
}


- (void)setupSubviews{
    
    CGFloat headerH = 0;
    CGFloat topH = 0;
    
    
    if (self.viewModel.layout == THKDynamicTabsLayoutType_Suspend) {
        headerH = self.viewModel.headerContentViewHeight;
        topH = headerH + self.viewModel.sliderBarHeight;
        
        [self.view addSubview:self.wrapperScrollView];
        [self.wrapperScrollView addSubview:self.headerWrapperView];
        [self.wrapperScrollView addSubview:self.sliderBar];
        [self.wrapperScrollView addSubview:self.pageContainerVC.view];
        
        [self.wrapperScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [self.headerWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-topH);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
            make.left.mas_offset(0);
            make.height.mas_equalTo(headerH);
        }];
        
        if (self.viewModel.headerContentView) {
            [self.headerWrapperView addSubview:self.viewModel.headerContentView];
            [self.viewModel.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.headerWrapperView);
            }];
        }
        
        [self.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-self.viewModel.sliderBarHeight);
            make.left.mas_offset(0);
            make.height.mas_equalTo(self.viewModel.sliderBarHeight);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
        }];
        
        [self.pageContainerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
            make.height.equalTo(self.wrapperScrollView).offset(-self.viewModel.sliderBarHeight);
        }];
        
        
        self.wrapperScrollView.contentInset = UIEdgeInsetsMake(topH, 0, 0, 0);
        self.wrapperScrollView.lockArea = self.viewModel.sliderBarHeight;
        self.wrapperScrollView.contentSize = CGSizeMake(0, TMUI_SCREEN_HEIGHT + topH);
    }else if (self.viewModel.layout == THKDynamicTabsLayoutType_Normal){
        topH = self.viewModel.sliderBarHeight;
        
        [self.view addSubview:self.sliderBar];
        [self.view addSubview:self.pageContainerVC.view];
        
        [self.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_offset(0);
            make.height.mas_equalTo(self.viewModel.sliderBarHeight);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
        }];
        
        [self.pageContainerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sliderBar.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
            make.height.equalTo(self.view).offset(-self.viewModel.sliderBarHeight);
        }];
    }else if (self.viewModel.layout == THKDynamicTabsLayoutType_Interaction) {
        headerH = self.viewModel.headerContentViewHeight;
        topH = headerH;
        
        [self.view addSubview:self.wrapperScrollView];
//        [self.wrapperScrollView addSubview:self.headerWrapperView];
//        [self.wrapperScrollView addSubview:self.sliderBar];
        [self.wrapperScrollView addSubview:self.pageContainerVC.view];
        
        [self.wrapperScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
//        [self.headerWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(-topH);
//            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
//            make.left.mas_offset(0);
//            make.height.mas_equalTo(headerH);
//        }];
        
//        if (self.viewModel.headerContentView) {
//            [self.headerWrapperView addSubview:self.viewModel.headerContentView];
//            [self.viewModel.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self.headerWrapperView);
//            }];
//        }
//        
//        [self.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(-self.viewModel.sliderBarHeight);
//            make.left.mas_offset(0);
//            make.height.mas_equalTo(self.viewModel.sliderBarHeight);
//            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
//        }];
        
        [self.pageContainerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
            make.height.equalTo(self.wrapperScrollView).offset(-self.viewModel.sliderBarHeight);
        }];
        
        // 针对交互吸顶的样式，pageVC必须设置高度和屏幕高度
        [self.pageContainerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
            make.height.mas_equalTo(TMUI_SCREEN_HEIGHT - self.viewModel.sliderBarHeight);
        }];
        
        self.wrapperScrollView.contentInset = UIEdgeInsetsMake(topH, 0, 0, 0);
        self.wrapperScrollView.lockArea = self.viewModel.sliderBarHeight;
        self.wrapperScrollView.contentSize = CGSizeMake(0, TMUI_SCREEN_HEIGHT + topH);
    }else{
        // 只添加pageVC
        [self.view addSubview:self.pageContainerVC.view];
        [self.pageContainerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
        }];
    }
    
    
    [self.viewModel.parentVC addChildViewController:self.pageContainerVC];
}

- (void)reloadUI{
    NSInteger selectedIndex = self.viewModel.sliderBarDefaultSelected;
    [self.sliderBar setSegmentTitles:self.viewModel.segmentTabs];
    
    [self.sliderBar setSelectedIndex:selectedIndex];
    if (self.viewModel.segmentTitles) {
        self.pageContainerVC.titlesM = [NSMutableArray arrayWithArray:self.viewModel.segmentTitles];
    }
    if (self.viewModel.arrayChildVC) {
        self.pageContainerVC.controllersM = [NSMutableArray arrayWithArray:self.viewModel.arrayChildVC];
    }
    self.pageContainerVC.pageIndex = selectedIndex;
    [self.pageContainerVC reloadData];
    
    [self.viewModel.segmentValueChangedSubject sendNext:@(selectedIndex)];
    [self.viewModel.tabsLoadFinishSignal sendNext:self.viewModel.segmentTabs];
}

- (void)loadTabs {
    //先赋值信号回调,再调用相关接口,以上相关接口调用后立马返回时，信号回调还没被赋值(断网情况下小概率可能发生)
    [self.viewModel loadTabs];
}

-(BOOL)pageViewControllerBreakLayoutSubviewsAction{
    return self.breakLayout;
}
- (UIViewController *)getViewControllerWithIndex:(NSInteger)index {
    return [self.viewModel.arrayChildVC safeObjectAtIndex:index];
}

- (void)updateSliderbarHeight:(CGFloat)height {
    self.sliderBar.height = height;
    self.viewModel.sliderBarHeight = height;
    [self.sliderBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(THKDynamicTabsPageVC *)pageViewController pageForIndex:(NSInteger)index {
    NSArray *vcs = self.viewModel.arrayChildVC;
    UIViewController *controller = [vcs safeObjectAtIndex:index];
    UIScrollView *scrollView = nil;
    if ([controller conformsToProtocol:@protocol(THKTabBarRepeatSelectProtocol)] && [controller respondsToSelector:@selector(contentScrollView)]) {
        scrollView = [(UIViewController<THKTabBarRepeatSelectProtocol> *)controller contentScrollView];
    }
    if ([controller conformsToProtocol:@protocol(THKDynamicTabsProtocol)] && [controller respondsToSelector:@selector(contentScrollView)]) {
        scrollView = [(UIViewController<THKDynamicTabsProtocol> *)controller contentScrollView];
        // 不启用多代理，内部有GETableView会造成代理不能分发事件
        //scrollView.tmui_multipleDelegatesEnabled = YES;
        //scrollView.delegate = self;
    }
    return scrollView;
}

- (void)pageViewController:(THKDynamicTabsPageVC *)pageViewController
        didEndDecelerating:(UIScrollView *)scrollView{
    NSInteger selectedIndex = pageViewController.pageIndex;
    if (selectedIndex == self.sliderBar.selectedIndex){
        return;
    }
    if (selectedIndex != self.sliderBar.selectedIndex) {
        [self.sliderBar setSelectedIndex:selectedIndex animated:YES];
        if (self.tabButtonScrollBlock) {
            self.tabButtonScrollBlock([self.sliderBar segmentButtonAtIndex:selectedIndex], selectedIndex);
        }
    }
    UIViewController *viewController = [self.viewModel.arrayChildVC safeObjectAtIndex:selectedIndex];
    //如果设置了每次显示都刷新的标志，则在页面被选中显示时进行刷新
    if ([viewController conformsToProtocol:@protocol(THKDynamicTabsProtocol)]) {
        UIViewController<THKDynamicTabsProtocol> *pVC = (UIViewController<THKDynamicTabsProtocol> *)viewController;
        if ([pVC respondsToSelector:@selector(alwaysFreshWhenAppear)]) {
            if ([pVC alwaysFreshWhenAppear]) {
                if ([pVC respondsToSelector:@selector(needReloadData)]) {
                    [pVC needReloadData];
                }
            }
        }
    }
    [self.viewModel.segmentValueChangedSubject sendNext:@(selectedIndex)];
}

#pragma mark - PageVC Delegate
- (void)pageViewController:(THKDynamicTabsPageVC *)pageViewController didScroll:(UIScrollView *)scrollView progress:(CGFloat)progress formIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewController:didScroll:progress:formIndex:toIndex:)]) {
        [self.delegate pageViewController:pageViewController didScroll:scrollView progress:progress formIndex:fromIndex toIndex:toIndex];
    }
    // 切换时，把子VC的scrollView内容吸顶，避免下滑时，再置顶的抖动效果，提升体验
    if (_wrapperScrollView) {
        [_wrapperScrollView childViewControllerDidChanged:[self.pageContainerVC.controllersM safeObjectAtIndex:self.pageContainerVC.pageIndex]];
    }
}

- (NSString *)pageViewController:(THKDynamicTabsPageVC *)pageViewController customCacheKeyForIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%zd-%@",index,[pageViewController.titlesM safeObjectAtIndex:index]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.wrapperScrollView && [self.delegate respondsToSelector:@selector(wrapperScrollViewDidScroll:)]) {
        [self.delegate wrapperScrollViewDidScroll:self.wrapperScrollView];
    }
}

// MARK: wrapper滚动回调
- (void)pageWrapperScrollViewRealChanged:(THKDynamicTabsWrapperScrollView *)pageWrapperScrollView diff:(CGFloat)diff{
    if ([self.delegate respondsToSelector:@selector(wrapperScrollViewDidScroll:diff:)]){
        [self.delegate wrapperScrollViewDidScroll:pageWrapperScrollView diff:diff];
    }
}

// MARK: content滚动回调
- (void)pageWrapperContentScrollViewChanged:(UIScrollView *)contentScrollView diff:(CGFloat)diff{
    if ([self.delegate respondsToSelector:@selector(contentScrollViewDidScroll:diff:)]){
        [self.delegate contentScrollViewDidScroll:contentScrollView diff:diff];
    }
}

- (void)pageWrapperScrollView:(THKDynamicTabsWrapperScrollView *)pageWrapperScrollView pin:(BOOL)pin{
    // 是否开启无限滚动功能
    if (self.viewModel.isEnableInfiniteScroll) {
        self.pageContainerVC.viewModel.isEnableInfiniteScroll = !pin;
    }
}

// 点击状态栏回调
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    UIViewController *controller = [self.pageContainerVC.controllersM safeObjectAtIndex:self.pageContainerVC.pageIndex];
    if ([controller conformsToProtocol:@protocol(THKTabBarRepeatSelectProtocol)] && [controller respondsToSelector:@selector(contentScrollView)]) {
        UIScrollView *scrollView = [(UIViewController<THKTabBarRepeatSelectProtocol> *)controller contentScrollView];
        [scrollView tmui_scrollToTop];
    }
                   
    [self.wrapperScrollView scrollToTop:YES];
    return YES;
}


#pragma mark - getter and setter

- (void)setIsPageVCScrollEnable:(BOOL)isPageVCScrollEnable{
    _isPageVCScrollEnable = isPageVCScrollEnable;
    self.pageContainerVC.viewModel.pageScrollEnabled = isPageVCScrollEnable;
}

- (UIView *)view{
    if (!_view) {
        _view = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _view;
}

- (THKDynamicTabsWrapperScrollView *)wrapperScrollView{
    if (!_wrapperScrollView) {
        _wrapperScrollView = [[THKDynamicTabsWrapperScrollView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _wrapperScrollView.showsHorizontalScrollIndicator = NO;
        _wrapperScrollView.scrollsToTop = YES;
        _wrapperScrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _wrapperScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.viewModel.parentVC.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _wrapperScrollView;
}

- (UIView *)headerWrapperView{
    if (!_headerWrapperView) {
        _headerWrapperView = [UIView new];
    }
    return _headerWrapperView;
}

- (THKDynamicTabsPageVC *)pageContainerVC {
    if (!_pageContainerVC) {
        THKDynamicTabsPageVM *vm = [[THKDynamicTabsPageVM alloc] init];
        if (self.viewModel.layout == THKDynamicTabsLayoutType_Custom) {
            vm.cutOutHeight = self.viewModel.cutOutHeight;
        }else if(self.viewModel.layout == THKDynamicTabsLayoutType_Interaction) {
            vm.cutOutHeight = 0;
        }else{
            vm.cutOutHeight = self.viewModel.cutOutHeight + self.viewModel.sliderBarHeight + NavigationContentTop;
        }
        vm.isEnableInfiniteScroll = self.viewModel.isEnableInfiniteScroll;
        _pageContainerVC = [[THKDynamicTabsPageVC alloc] initWithViewModel:vm];
        _pageContainerVC.delegate = self;
        _pageContainerVC.dataSource = self;
    }
    return _pageContainerVC;
}

- (THKImageTabSegmentControl *)sliderBar {
    
    if (!_sliderBar) {
        
        CGRect frame = CGRectMake(0, 0, kScreenWidth, self.viewModel.sliderBarHeight);
        _sliderBar = [[THKImageTabSegmentControl alloc] initWithFrame:frame];
        _sliderBar.backgroundColor = [UIColor whiteColor];
        _sliderBar.indicatorView.hidden = NO;
        _sliderBar.indicatorView.backgroundColor = THKColor_TextImportantColor;
        _sliderBar.indicatorView.layer.cornerRadius = 0.0;

        @weakify(self);
        [[_sliderBar rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            THKImageTabSegmentControl *seg = x;
            [self.pageContainerVC setSelectedPageIndex:seg.selectedIndex];
        }];
        _sliderBar.itemExposeBlock = ^(UIButton *button, NSInteger index) {
            @strongify(self);
            THKDynamicTabsModel *model = [self.viewModel.segmentTabs safeObjectAtIndex:index];
            if (model.isExpose == NO) {
                model.isExpose = YES;
                if (self.tabButtonExposeBlock) {
                    self.tabButtonExposeBlock(button, index);
                }
            }
        };
        _sliderBar.itemClickBlock = ^(UIButton *button, NSInteger index) {
            @strongify(self);
            if (self.tabButtonScrollBlock) {
                self.tabButtonScrollBlock(button, index);
            }
        };
    }
    
    return _sliderBar;
}


- (NSInteger)currentIndex{
    return self.sliderBar.selectedIndex;
}

-(UIViewController *)getCurrentViewController{
    return [self getViewControllerWithIndex:self.currentIndex];
}
@end


#pragma mark - 刷新子VC
static NSString *const kDynamicTabsManagerKey = @"kDynamicTabsManagerKey";
@implementation THKDynamicTabsManager (THKRefresh)

- (void)setRefreshHeader:(CGFloat)inset{
//    if (!self.wrapperScrollView.header) {
//        THKRefreshHeaderView *headerView = [THKRefreshHeaderView new];
//        @weakify(self);
//        [self.wrapperScrollView addRefreshHeader:headerView refreshingBlock:^{
//            @strongify(self);
//            [self refreshChildVC];
//        }];
//    }
//
//    CGFloat headerInset = self.wrapperScrollView.contentInset.top - inset;
//    self.wrapperScrollView.header.headerInset = headerInset;
//    [self.wrapperScrollView.header layoutSubviews];
}

- (void)refreshChildVC{
    [self.pageContainerVC.controllersM enumerateObjectsUsingBlock:^(__kindof UIViewController<THKDynamicTabsProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isViewLoaded] && [obj respondsToSelector:@selector(dynamicTabsBeginRefreshing)]) {
            [obj dynamicTabsBeginRefreshing];
            [obj tmui_bindObjectWeakly:self forKey:kDynamicTabsManagerKey];
        }
    }];
    if(self.delegate && [self.delegate respondsToSelector:@selector(dynamicTabsManagerMainVCBeginingRefresh)]){
        [self.delegate dynamicTabsManagerMainVCBeginingRefresh];
        
        [(NSObject*)self.delegate tmui_bindObjectWeakly:self forKey:kDynamicTabsManagerKey];
    }
}

- (void)endRefreshing{
//    [self.wrapperScrollView.header endRefreshing];
}

@end


//  协议默认实现
@implementation UIViewController (THKDynamicTabs)

- (void)dynamicTabsEndRefreshing{
    THKDynamicTabsManager *manager = [self tmui_getBoundObjectForKey:kDynamicTabsManagerKey];
    if ([manager isKindOfClass:THKDynamicTabsManager.class]) {
        [manager endRefreshing];
    }
}

@end
