//
//  THKHomeDynamicTabsManager.m
//  HouseKeeper
//
//  Created by collen.zhang on 2021/10/15.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKDynamicTabsManager.h"
#import "THKViewController.h"
#import "DynamicTabChildVC.h"
#import "THKPageBGScrollView.h"
static CGFloat const kSliderH = 44;

@interface THKDynamicTabsManager ()<YNPageViewControllerDelegate,YNPageViewControllerDataSource,THKPageViewControllerDelegate,THKPageViewControllerDataSource>{
    NSArray *_childVCs;
    NSArray *_childTitles;
}

@property (nonatomic, strong)   THKDynamicTabsViewModel         *viewModel;
@property (nonatomic, strong)   TMUIPageWrapperScrollView       *wrapperScrollView;
@property (nonatomic, strong)   UIView                          *wrapperView;
@property (nonatomic, strong)   UIView                          *headerView;
@property (nonatomic, strong)   THKImageTabSegmentControl       *sliderBar;
@property (nonatomic, strong)   THKPageViewController           *pageContainerVC;
@property (nonatomic, assign)   BOOL isFirst;


@end

@implementation THKDynamicTabsManager

- (instancetype)initWithViewModel:(THKDynamicTabsViewModel *)viewModel {
    if (self = [super init]) {
        
        _childVCs = @[DynamicTabChildVC.new];
        _childTitles = @[@"1"];
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
    
    [[RACObserve(self.viewModel, headerContentViewHeight) delay:1] subscribeNext:^(id  _Nullable x) {
        if (self.headerView.superview) {
            CGFloat headerH = self.viewModel.headerContentViewHeight;
            CGFloat topH = headerH + kSliderH;
            
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-topH);
                make.height.mas_equalTo(headerH);
            }];
            
            self.wrapperScrollView.contentInset = UIEdgeInsetsMake(topH, 0, 0, 0);
            self.wrapperScrollView.lockArea = kSliderH;
            self.wrapperScrollView.contentSize = CGSizeMake(0, TMUI_SCREEN_HEIGHT + topH);
        }
    }];
}


- (void)setupSubviews{
    
    CGFloat headerH = 0;
    CGFloat topH = 0;
    
    
    if (self.viewModel.isSuspendStyle) {
        
        headerH = self.viewModel.headerContentViewHeight;
        topH = headerH + kSliderH;
        
        [self.wrapperScrollView addSubview:self.headerView];
        [self.wrapperScrollView addSubview:self.sliderBar];
        [self.wrapperScrollView addSubview:self.pageContainerVC.view];
        
        if (self.viewModel.headerContentView) {
            [self.headerView addSubview:self.viewModel.headerContentView];
            [self.viewModel.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.headerView);
            }];
        }
        
        
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-topH);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
            make.left.mas_offset(0);
            make.height.mas_equalTo(headerH);
        }];
        
        [self.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-kSliderH);
            make.left.mas_offset(0);
            make.height.mas_equalTo(kSliderH);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
        }];
        
        [self.pageContainerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
            make.height.equalTo(self.wrapperScrollView).offset(-kSliderH);
        }];
        
        
        self.wrapperScrollView.contentInset = UIEdgeInsetsMake(topH, 0, 0, 0);
        self.wrapperScrollView.lockArea = kSliderH;
        self.wrapperScrollView.contentSize = CGSizeMake(0, TMUI_SCREEN_HEIGHT + topH);
    }else{
        topH = kSliderH;
        
        [self.wrapperView addSubview:self.sliderBar];
        [self.wrapperView addSubview:self.pageContainerVC.view];
        
        [self.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_offset(0);
            make.height.mas_equalTo(kSliderH);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
        }];
        
        [self.pageContainerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sliderBar.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
            make.height.equalTo(self.wrapperView).offset(-kSliderH);
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
    
    self.isFirst = YES;
    [self.viewModel.segmentValueChangedSubject sendNext:@(selectedIndex)];
    [self.viewModel.tabsLoadFinishSignal sendNext:self.viewModel.segmentTabs];
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
    NSArray *vcs = self.viewModel.arrayChildVC?:_childVCs;
    UIViewController *controller = [vcs safeObjectAtIndex:index];
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


- (TMUIPageWrapperScrollView *)wrapperScrollView{
    if (!_wrapperScrollView) {
        _wrapperScrollView = [[TMUIPageWrapperScrollView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _wrapperScrollView.showsHorizontalScrollIndicator = NO;
        //_contentView.directionalLockEnabled = YES;
//        _contentView.t_delegate = self;
//        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _wrapperScrollView;
}

- (UIView *)wrapperView{
    if (!_wrapperView) {
        _wrapperView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _wrapperView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
    }
    return _headerView;
}

- (THKPageViewController *)pageContainerVC {
    if (!_pageContainerVC) {
        THKPageViewModel *configration = [THKPageViewModel defaultConfig];
        configration.cutOutHeight = self.viewModel.cutOutHeight + kSliderH + NavigationContentTop;
        _pageContainerVC = [THKPageViewController pageViewControllerWithControllers:_childVCs
                                                                  titles:_childTitles
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
