//
//  THKSelectMaterialVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialVC.h"
#import "THKDynamicTabsManager.h"
#import "THKSelectMaterialHeaderView.h"
@interface THKSelectMaterialVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) THKSelectMaterialVM *viewModel;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
@property (nonatomic, strong) THKSelectMaterialHeaderView *headerView;

@end

@implementation THKSelectMaterialVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.hidden = YES;
    
    [self.view addSubview:self.dynamicTabsManager.wrapperView];
    [self.dynamicTabsManager.wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, tmui_safeAreaBottomInset()));
    }];
    
    [self.dynamicTabsManager.headerWrapperView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.dynamicTabsManager loadTabs];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    THKSelectMaterialHeaderViewModel *headerViewModel = [[THKSelectMaterialHeaderViewModel alloc] init];
    [self.headerView bindViewModel:headerViewModel];
    self.dynamicTabsManager.viewModel.headerContentViewHeight = 510;
}


#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != _dynamicTabsManager.wrapperScrollView) {
        return;
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"wrapperScrollViewDidScroll" object:scrollView];
}
#pragma mark - Private

#pragma mark - Getters and Setters

- (THKDynamicTabsManager *)dynamicTabsManager {
    if (!_dynamicTabsManager) {
        THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] initWithTabs:self.viewModel.segmentTitles];
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
        viewModel.parentVC = self;
        viewModel.headerContentViewHeight = 800;
        viewModel.lockArea = NavigationContentTop;
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
        _dynamicTabsManager.wrapperScrollView.delegate = self;
    }
    return _dynamicTabsManager;
}

- (THKSelectMaterialHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[THKSelectMaterialHeaderView alloc] init];
    }
    return _headerView;
}

#pragma mark - Supperclass

#pragma mark - NSObject
+ (BOOL)canHandleRouter:(TRouter *)router{
    if ([router routerMatch:THKRouterPage_MaterialSubVC]) {
        return YES;
    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router{
    THKSelectMaterialVM *selectMaterialVM = [[THKSelectMaterialVM alloc] init];
    return [[self alloc] initWithViewModel:selectMaterialVM];
}

@end
