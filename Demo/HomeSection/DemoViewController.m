//
//  DemoViewController.m
//  Demo
//
//  Created by Joe.cheng on 2023/2/22.
//

#import "DemoViewController.h"
#import "THKDynamicTabsManager.h"
#import "DynamicTabChildVC.h"
#import "THKDiaryBookDetailTopNaviBarView.h"
#import <MJRefresh.h>
#import "THKPKPlanDetailTabView.h"
@interface DemoViewController ()<THKDynamicTabsManagerDelegate>
@property (nonatomic, strong) THKDiaryBookDetailTopNaviBarView *topBar;
@property (nonatomic, strong) THKPKPlanDetailTabView *tabView;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
// 私有头部
@property (nonatomic, strong) UIView *headerView;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(NavigationContentTop);
    }];
    
    [self.view addSubview:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UIEdgeInsetsMake(NavigationContentTop, 0, 0, 0));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.dynamicTabsManager.view];
    [self.dynamicTabsManager.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NavigationContentTop+50, 0, 0, 0));
    }];
    
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            // 这里必须要先设置头部刷新结束，再设置新的头部高度，否则会引起inset问题，怀疑是MJRefresh内部逻辑导致的
            [self.dynamicTabsManager.wrapperScrollView.mj_header endRefreshing];
            CGFloat oldH = self.dynamicTabsManager.viewModel.headerContentViewHeight;
            self.dynamicTabsManager.viewModel.headerContentViewHeight = arc4random()%200 + 100;
            CGFloat newH = self.dynamicTabsManager.viewModel.headerContentViewHeight;
            self.dynamicTabsManager.wrapperScrollView.mj_header.ignoredScrollViewContentInsetTop = self.dynamicTabsManager.viewModel.headerContentViewHeight + self.dynamicTabsManager.viewModel.sliderBarHeight;
            UILabel *lbl =(UILabel *)[self.headerView viewWithTag:999];
            lbl.text = [NSString stringWithFormat:@"头部高度：%f",self.dynamicTabsManager.viewModel.headerContentViewHeight];
            
            if (newH > oldH) {
                // 头部变高，需要置顶
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dynamicTabsManager.wrapperScrollView tmui_scrollToTopAnimated:YES];
                });
            }
        });
    }];
    header.ignoredScrollViewContentInsetTop = self.dynamicTabsManager.viewModel.headerContentViewHeight + self.dynamicTabsManager.viewModel.sliderBarHeight;
    self.dynamicTabsManager.wrapperScrollView.mj_header = header;
    NSArray *vcs = @[DynamicTabChildVC.new,DynamicTabChildVC.new,DynamicTabChildVC.new];
    NSArray *titles = @[@"12",@"12",@"12"];
    
    
    self.tabView.data = @[@"佳美域装饰装饰",@"佳美域装饰装饰",@"佳美域装饰装饰"];
    [self.dynamicTabsManager.viewModel setVCs:vcs titles:titles];
    [self.dynamicTabsManager loadTabs];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)pageViewController:(THKDynamicTabsPageVC *)pageViewController didScroll:(UIScrollView *)scrollView progress:(CGFloat)progress formIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (progress == 1) {
        NSLog(@"%zd,%zd,%f",fromIndex,toIndex,progress);
        [self.tabView setSelectIdx:toIndex];
    }
}

- (void)selectPageVC:(NSInteger)idx {
    [self.dynamicTabsManager.pageContainerVC setSelectedPageIndex:idx];
}

- (THKDynamicTabsManager *)dynamicTabsManager {
    if (!_dynamicTabsManager) {
        THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] init];
        viewModel.layout = THKDynamicTabsLayoutType_Custom;
        viewModel.cutOutHeight = 44;
        viewModel.sliderBarHeight = 50;
        viewModel.headerContentView.backgroundColor = UIColor.tmui_randomColor;
        viewModel.parentVC = self;
        
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
        _dynamicTabsManager.delegate = self;
    }
    return _dynamicTabsManager;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = UIColor.tmui_randomColor;
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = [NSString stringWithFormat:@"头部高度：%f",321.0];
        [_headerView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(20);
        }];
        lbl.tag = 999;
    }
    return _headerView;
}

- (THKDiaryBookDetailTopNaviBarView *)topBar{
    if (!_topBar) {
        _topBar = [[THKDiaryBookDetailTopNaviBarView alloc] init];
        _topBar.backgroundColor = UIColor.whiteColor;
        _topBar.backBtn.tmui_image = UIImageMake(@"nav_back_black");
        _topBar.nickNameLbl.textColor = UIColorHex(1A1C1A);
        @weakify(self);
        [[_topBar.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _topBar;
}

- (THKPKPlanDetailTabView *)tabView {
    if (!_tabView) {
        _tabView = [[THKPKPlanDetailTabView alloc] init];
        @weakify(self);
        _tabView.tapItem = ^(NSInteger idx) {
            @strongify(self);
            [self selectPageVC:idx];
        };
    }
    return _tabView;
}

@end
