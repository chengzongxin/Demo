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
#import "THKPKPlanDetailReceivePlanView.h"
@interface DemoViewController ()<THKDynamicTabsManagerDelegate>
@property (nonatomic, strong) THKDiaryBookDetailTopNaviBarView *topBar;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
@property (nonatomic, strong) THKPKPlanDetailTabView *tabView;
@property (nonatomic, strong) THKPKPlanDetailReceivePlanView *receiveView;
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
    
    [self.view addSubview:self.receiveView];
//    [self.receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(tmui_safeAreaBottomInset()+97);
//        make.bottom.mas_equalTo((tmui_safeAreaBottomInset()+97));
//    }];
    
    
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
    
    [self showReciveView];
}

- (void)showReciveView{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rt = self.receiveView.frame;
        rt.origin.y = self.view.height - rt.size.height;
        self.receiveView.frame = rt;
    }];
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

- (THKPKPlanDetailReceivePlanView *)receiveView {
    if (!_receiveView) {
        CGFloat height = tmui_safeAreaBottomInset()+97;
        _receiveView = [[THKPKPlanDetailReceivePlanView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, height)];
        _receiveView.backgroundColor = UIColorWhite;
        @weakify(self);
        _receiveView.tapBtn = ^(UIButton * _Nonnull btn) {
            @strongify(self);
            NSLog(@"%@",btn);
        };
        _receiveView.tapCloseBtn = ^(UIButton * _Nonnull btn) {
            @strongify(self);
            [self.receiveView removeFromSuperview];
        };
    }
    return _receiveView;
}

@end
