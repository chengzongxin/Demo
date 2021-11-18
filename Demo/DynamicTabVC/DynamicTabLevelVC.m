//
//  DynamicTabLevelVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import "DynamicTabLevelVC.h"
#import "THKDynamicTabsManager.h"
#import "THKDiaryBookDetailTopNaviBarView.h"
#import <MJRefresh.h>
@interface DynamicTabLevelVC ()
@property (nonatomic, strong, readwrite) DynamicTabLevelVM *viewModel;
@property (nonatomic, strong) THKDiaryBookDetailTopNaviBarView *topBar;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
@end

@implementation DynamicTabLevelVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.dynamicTabsManager.wrapperScrollView];
    [self.dynamicTabsManager.wrapperScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    @weakify(self);
//    self.tableView.tmui_isAddRefreshControl = YES;
    self.dynamicTabsManager.wrapperScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.dynamicTabsManager.wrapperScrollView.mj_header endRefreshing];
            self.dynamicTabsManager.viewModel.headerContentViewHeight = 188;
            self.dynamicTabsManager.wrapperScrollView.mj_header.ignoredScrollViewContentInsetTop = self.dynamicTabsManager.viewModel.headerContentViewHeight + 44;
        });
    }];
    self.dynamicTabsManager.wrapperScrollView.mj_header.ignoredScrollViewContentInsetTop = self.dynamicTabsManager.viewModel.headerContentViewHeight + 44;
    
    [self.dynamicTabsManager loadTabs];
    
//    [RACObserve(self, contentScrollView) subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
}

//- (UIScrollView *)contentScrollView{
//    return _dynamicTabsManager.wrapperScrollView;
//}
//
//- (void)tabbarDidRepeatSelect{
//    [self.dynamicTabsManager.wrapperScrollView setContentOffset:self.dynamicTabsManager.wrapperScrollView.tmui_topPoint animated:YES];
//}


- (THKDynamicTabsManager *)dynamicTabsManager {
    if (!_dynamicTabsManager) {
        THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] initWithWholeCode:kDynamicTabsWholeCodeHomePage
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
        
        viewModel.isSuspendStyle = YES;
        viewModel.cutOutHeight = 44;
        viewModel.headerContentViewHeight = 321;
        viewModel.headerContentView = [UIView new];
        viewModel.headerContentView.backgroundColor = UIColor.tmui_randomColor;
        viewModel.parentVC = self;
        
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
    }
    return _dynamicTabsManager;
}


+ (BOOL)canHandleRouter:(TRouter *)router{
    if ([router routerMatch:THKRouterPage_CommunityFollowList]) {
        return YES;
    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router{
    DynamicTabLevelVM *vm = [[DynamicTabLevelVM alloc] init];
    return [[self alloc] initWithViewModel:vm];
}

@end
