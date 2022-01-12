//
//  DynamicTabVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/17.
//

#import "DynamicTabVC.h"
#import "THKDynamicTabsManager.h"
#import "THKDiaryBookDetailTopNaviBarView.h"
#import <MJRefresh.h>
@interface DynamicTabVC ()
@property (nonatomic, strong, readwrite) DynamicTabVM *viewModel;
@property (nonatomic, strong) THKDiaryBookDetailTopNaviBarView *topBar;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
@end

@implementation DynamicTabVC
@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarHidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    if (self.viewModel.isSuspend == DynamicTabStyle_Immersion) {
        self.navigationController.navigationBar.hidden = YES;
        
        [self.view addSubview:self.dynamicTabsManager.view];
        [self.dynamicTabsManager.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, tmui_safeAreaBottomInset()));
        }];
        
        [self.dynamicTabsManager loadTabs];
        return;
    }
    
    [self.view addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(NavigationContentTop);
    }];
    
    
    [self.view addSubview:self.dynamicTabsManager.view];
    [self.dynamicTabsManager.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NavigationContentTop, 0, 0, 0));
    }];
    
    if (self.viewModel.isSuspend == DynamicTabStyle_Suspend) {
        @weakify(self);
    //    self.tableView.tmui_isAddRefreshControl = YES;
        self.dynamicTabsManager.wrapperScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.dynamicTabsManager.wrapperScrollView.mj_header endRefreshing];
                CGFloat oldH = self.dynamicTabsManager.viewModel.headerContentViewHeight;
                self.dynamicTabsManager.viewModel.headerContentViewHeight = arc4random()%200 + 100;
                CGFloat newH = self.dynamicTabsManager.viewModel.headerContentViewHeight;
                self.dynamicTabsManager.wrapperScrollView.mj_header.ignoredScrollViewContentInsetTop = self.dynamicTabsManager.viewModel.headerContentViewHeight + 44;
                if (newH > oldH) {
                    // 头部变高，需要置顶
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.dynamicTabsManager.wrapperScrollView tmui_scrollToTopAnimated:YES];
                    });
                }
            });
        }];
        self.dynamicTabsManager.wrapperScrollView.mj_header.ignoredScrollViewContentInsetTop = self.dynamicTabsManager.viewModel.headerContentViewHeight + 44;
    }
    
    [self.dynamicTabsManager loadTabs];
}

- (THKDynamicTabsManager *)dynamicTabsManager {
    if (!_dynamicTabsManager) {
        THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] initWithWholeCode:nil
                                                                                    defualtTabs:self.viewModel.segmentTitles];
        viewModel.configDynamicTabButtonModelBlock = ^(THKDynamicTabDisplayModel * _Nonnull configButtonModel, NSInteger tabId, NSString * _Nonnull title) {
            //这里可以根据tabId或title来设值每一个按钮的属性
            configButtonModel.badgeImageColor = THKColor_RedPointColor;
            configButtonModel.normalColor = THKColor_999999;
            configButtonModel.selectedColor = THKColor_333333;
            configButtonModel.scale = 0.9;
            configButtonModel.normalFont  = [UIFont fontWithName:@"PingFangSC-Regular" size:15.6];
            configButtonModel.selectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16.7];
        };
        
        viewModel.layout = self.viewModel.isSuspend == DynamicTabStyle_Suspend ? THKDynamicTabsLayoutType_Suspend : THKDynamicTabsLayoutType_Normal;
        viewModel.parentVC = self;
        viewModel.headerContentViewHeight = 321;
        
        if (self.viewModel.isSuspend == DynamicTabStyle_Immersion) {
            viewModel.layout = THKDynamicTabsLayoutType_Suspend;
            viewModel.lockArea = NavigationContentTop;
        }
        viewModel.headerContentView = [UIView new];
        viewModel.headerContentView.backgroundColor = UIColor.tmui_randomColor;
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
    }
    return _dynamicTabsManager;
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


@end
