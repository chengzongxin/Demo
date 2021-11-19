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
// 私有头部
@property (nonatomic, strong) UIView *headerView;
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
    [header setTitle:@"下拉刷新头部高度" forState:MJRefreshStatePulling];
    self.dynamicTabsManager.wrapperScrollView.mj_header = header;
    
    [self.dynamicTabsManager loadTabs];
}

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
        
        viewModel.layout = THKDynamicTabsLayoutType_Suspend;
        viewModel.cutOutHeight = 44;
        viewModel.sliderBarHeight = 60;
        viewModel.headerContentViewHeight = 321;
        viewModel.headerContentView = self.headerView;
        viewModel.headerContentView.backgroundColor = UIColor.tmui_randomColor;
        viewModel.parentVC = self;
        
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
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
