//
//  THKHomeDynamicTabsManager.m
//  HouseKeeper
//
//  Created by collen.zhang on 2021/10/15.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKDynamicTabsManager.h"
#import "THKViewController.h"

@interface THKDynamicTabsManager ()<THKDynamicTabsPageVCDelegate,THKDynamicTabsPageVCDataSource>

@property (nonatomic, strong)   THKDynamicTabsViewModel         *viewModel;
@property (nonatomic, strong)   TMUIPageWrapperScrollView       *wrapperScrollView;
@property (nonatomic, strong)   UIView                          *wrapperView;
@property (nonatomic, strong)   UIView                          *headerWrapperView;
@property (nonatomic, strong)   THKImageTabSegmentControl       *sliderBar;
@property (nonatomic, strong)   THKDynamicTabsPageVC            *pageContainerVC;


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
        }
    }];
}


- (void)setupSubviews{
    
    CGFloat headerH = 0;
    CGFloat topH = 0;
    
    
    if (self.viewModel.layout == THKDynamicTabsLayoutType_Suspend) {
        headerH = self.viewModel.headerContentViewHeight;
        topH = headerH + self.viewModel.sliderBarHeight;
        
        [self.wrapperView addSubview:self.wrapperScrollView];
        [self.wrapperScrollView addSubview:self.headerWrapperView];
        [self.wrapperScrollView addSubview:self.sliderBar];
        [self.wrapperScrollView addSubview:self.pageContainerVC.view];
        
        [self.wrapperScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.wrapperView);
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
        
        [self.wrapperView addSubview:self.sliderBar];
        [self.wrapperView addSubview:self.pageContainerVC.view];
        
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
            make.height.equalTo(self.wrapperView).offset(-self.viewModel.sliderBarHeight);
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

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(THKDynamicTabsPageVC *)pageViewController pageForIndex:(NSInteger)index {
    NSArray *vcs = self.viewModel.arrayChildVC;
    UIViewController *controller = [vcs safeObjectAtIndex:index];
    UIScrollView *scrollView = nil;
    if ([controller conformsToProtocol:@protocol(THKTabBarRepeatSelectProtocol)] && [controller respondsToSelector:@selector(contentScrollView)]) {
        scrollView = [(UIViewController<THKTabBarRepeatSelectProtocol> *)controller contentScrollView];
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
}

- (NSString *)pageViewController:(THKDynamicTabsPageVC *)pageViewController customCacheKeyForIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%zd-%@",index,[pageViewController.titlesM safeObjectAtIndex:index]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.wrapperScrollView && self.delegate && [self.delegate respondsToSelector:@selector(wrapperScrollViewDidScroll:)]) {
        [self.delegate wrapperScrollViewDidScroll:self.wrapperScrollView];
    }
}

#pragma mark - getter and setter

- (UIView *)wrapperView{
    if (!_wrapperView) {
        _wrapperView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _wrapperView;
}

- (TMUIPageWrapperScrollView *)wrapperScrollView{
    if (!_wrapperScrollView) {
        _wrapperScrollView = [[TMUIPageWrapperScrollView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _wrapperScrollView.showsHorizontalScrollIndicator = NO;
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
        }else{
            vm.cutOutHeight = self.viewModel.cutOutHeight + self.viewModel.sliderBarHeight + NavigationContentTop;
        }
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
