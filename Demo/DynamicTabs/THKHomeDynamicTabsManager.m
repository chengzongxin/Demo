//
//  THKHomeDynamicTabsManager.m
//  HouseKeeper
//
//  Created by collen.zhang on 2021/10/15.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKHomeDynamicTabsManager.h"
#import "THKViewController.h"
@interface THKHomeDynamicTabsManager ()<YNPageViewControllerDelegate,YNPageViewControllerDataSource>

@property (nonatomic, strong)   THKDynamicTabsViewModel         *viewModel;
@property (nonatomic, strong)   YNPageViewController     *pageContainerVC;
@property (nonatomic, strong)   THKImageTabSegmentControl       *sliderBar;
@property (nonatomic, assign)   BOOL isFirst;

@end

@implementation THKHomeDynamicTabsManager

- (instancetype)initWithViewModel:(THKDynamicTabsViewModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
        [self bindViewModel];
    }
    return self;
}

- (void)bindViewModel {
    @weakify(self);
    [self.viewModel.tabsResultSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
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
        
        self.isFirst = YES;
        [self.viewModel.segmentValueChangedSubject sendNext:@(selectedIndex)];
        [self.viewModel.tabsLoadFinishSignal sendNext:self.viewModel.segmentTabs];
    }];
}

- (void)loadTabs {
    //先赋值信号回调,再调用相关接口,以上相关接口调用后立马返回时，信号回调还没被赋值(断网情况下小概率可能发生)
    [self.viewModel requestConfigTabs];
}

-(BOOL)pageViewControllerBreakLayoutSubviewsAction{
    return self.breakLayout;
}
- (UIViewController *)getViewControllerWithIndex:(NSInteger)index {
    return [self.viewModel.arrayChildVC safeObjectAtIndex:index];
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *controller = [self.viewModel.arrayChildVC safeObjectAtIndex:index];
    UIScrollView *scrollView = nil;
    if ([controller conformsToProtocol:@protocol(THKTabBarRepeatSelectProtocol)] && [controller respondsToSelector:@selector(contentScrollView)]) {
        scrollView = [(UIViewController<THKTabBarRepeatSelectProtocol> *)controller contentScrollView];
    }
    return scrollView;
}

- (void)pageViewController:(YNPageViewController *)pageViewController
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

#pragma mark - getter and setter
- (THKDynamicTabsViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[THKDynamicTabsViewModel alloc] init];
    }
    return _viewModel;
}

- (YNPageViewController *)pageContainerVC {
    if (!_pageContainerVC) {
        YNPageConfigration *configration = [YNPageConfigration defaultConfig];
        configration.pageStyle = YNPageStyleNavigation;
        configration.headerViewCouldScale = NO;
        configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
        configration.showTabbar = YES;
        configration.showNavigation = NO;
        configration.scrollMenu = NO;
        configration.aligmentModeCenter = NO;
        configration.lineWidthEqualFontWidth = NO;
        configration.showBottomLine = YES;
        /// 设置菜单栏宽度
//        configration.menuWidth = 150;
        configration.cutOutHeight = self.cutOutHeight;
        
        _pageContainerVC = [YNPageViewController pageViewControllerWithControllers:self.viewModel.arrayChildVC
                                                                  titles:self.viewModel.segmentTitles
                                                                  config:configration];
        _pageContainerVC.delegate = self;
        _pageContainerVC.dataSource = self;
    }
    return _pageContainerVC;
}

- (THKImageTabSegmentControl *)sliderBar {
    
    if (!_sliderBar) {
        
        CGRect frame = CGRectMake(0, 0, kScreenWidth, 52.0-6);
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
