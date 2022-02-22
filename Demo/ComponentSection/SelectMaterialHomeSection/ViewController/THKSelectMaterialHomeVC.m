//
//  THKSelectMaterialMainVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialHomeVC.h"
#import "THKDynamicTabsManager.h"
#import "THKSearchView.h"
#import "THKSelectMaterialTabVC.h"
#import "THKSelectMaterialTopBar.h"
#import "THKSelectMaterialConst.h"

@interface THKSelectMaterialHomeVC ()<THKDynamicTabsManagerDelegate>

@property (nonatomic, strong) THKSelectMaterialHomeVM *viewModel;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
@property (nonatomic, strong) THKSelectMaterialTopBar *topBar;
@property (nonatomic, strong) THKSearchView *searchView;
@end

@implementation THKSelectMaterialHomeVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.hidden = YES;
    
    [self.view addSubview:self.dynamicTabsManager.pageContainerVC.view];
    [self.dynamicTabsManager.pageContainerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.view addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(StatusBarHeight+kMaterialHomeSearchHeight);
    }];
    
    [self.topBar addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarHeight);
        make.left.equalTo(self.view).inset(54);
        make.right.equalTo(self.view).inset(15);
        make.height.mas_equalTo(kMaterialHomeSearchHeight);
    }];
    
    [self.view addSubview:self.dynamicTabsManager.sliderBar];
    [self.dynamicTabsManager.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.dynamicTabsManager.viewModel.sliderBarHeight);
    }];
    
    [self.view insertSubview:self.dynamicTabsManager.sliderBar belowSubview:self.topBar];
    
    
    @weakify(self);
    [[NSNotificationCenter.defaultCenter rac_addObserverForName:@"wrapperScrollViewDidScroll" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self updateTopBarLayoutWithWrapperScrollView:x.object];
    }];
}


- (void)bindViewModel{
    
//    @weakify(self);
//    [self.viewModel.requestTab.executionSignals.switchToLatest subscribeNext:^(THKMaterialV3IndexTopTabResponse *x) {
//        @strongify(self);
//        [self.dynamicTabsManager.viewModel setTabs:x.data];
//        [self.dynamicTabsManager loadTabs];
//    }];
    
    [self.viewModel.requestTab execute:nil];
    
    [self.dynamicTabsManager loadTabs];
}

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

- (void)pageViewController:(THKDynamicTabsPageVC *)pageViewController didScroll:(UIScrollView *)scrollView progress:(CGFloat)progress formIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
//    NSLog(@"MainVC pager %@",scrollView);
//    THKSelectMaterialTabVC *childVc = [pageViewController.controllersM safeObjectAtIndex:toIndex];
//    if (childVc.isViewLoaded == NO) {
//        return;
//    }
//
//    [self updateTopBarLayoutWithWrapperScrollView:childVc.dynamicTabsManager.wrapperScrollView];
}


- (void)updateTopBarLayoutWithWrapperScrollView:(NSNumber *)topNum{
    CGFloat top = topNum.floatValue;
    [self.dynamicTabsManager.sliderBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(top);
    }];
}
//- (void)updateTopBarLayoutWithWrapperScrollView:(UIScrollView *)scrollView{
//    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
//    CGFloat top = 44 - offsetY;
//    [self.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(top);
//    }];
//}

- (void)wrapperScrollViewDidScroll:(TMUIPageWrapperScrollView *)wrapperScrollView{
    NSLog(@"MainVC wrapper %@",wrapperScrollView);
}

#pragma mark - Private

#pragma mark - Getters and Setters

- (THKDynamicTabsManager *)dynamicTabsManager {
    if (!_dynamicTabsManager) {
        THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] initWithTabs:self.viewModel.segmentTitles];
        viewModel.configDynamicTabButtonModelBlock = ^(THKDynamicTabDisplayModel * _Nonnull configButtonModel, NSInteger tabId, NSString * _Nonnull title) {
            //这里可以根据tabId或title来设值每一个按钮的属性
            configButtonModel.badgeImageColor = THKColor_RedPointColor;
            configButtonModel.normalColor = UIColorHex(4C4E4C);
            configButtonModel.selectedColor = UIColorHex(1A1C1A);
            configButtonModel.scale = 0.9;
            configButtonModel.normalFont  = UIFont(16);
            configButtonModel.selectedFont = UIFontMedium(20);
        };
        
        viewModel.layout = THKDynamicTabsLayoutType_Custom;
        viewModel.parentVC = self;
        viewModel.sliderBarHeight = kMaterialHomeTabHeight;
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
        _dynamicTabsManager.sliderBar.indicatorView.hidden = YES;
        _dynamicTabsManager.sliderBar.minItemWidth = (TMUI_SCREEN_WIDTH - 25 )/ 5;
        _dynamicTabsManager.delegate = self;
    }
    return _dynamicTabsManager;
}

- (THKSelectMaterialTopBar *)topBar{
    if (!_topBar) {
        _topBar = [[THKSelectMaterialTopBar alloc] init];
        _topBar.backgroundColor = UIColor.whiteColor;
        _topBar.backBtn.tmui_image = UIImageMake(@"nav_back_black");
    }
    return _topBar;
}


- (THKSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[THKSearchView alloc] init];
        _searchView.backgroundColor = UIColorHex(F9FAF9);
        _searchView.searchLabel.text = @"大家都在搜：瓷砖";
        _searchView.cornerRadius = 8;
    }
    return _searchView;
}


#pragma mark - Supperclass

#pragma mark - NSObject


@end
