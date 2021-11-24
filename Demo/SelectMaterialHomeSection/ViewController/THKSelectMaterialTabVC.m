//
//  THKSelectMaterialVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialTabVC.h"
#import "THKDynamicTabsManager.h"
#import "THKSelectMaterialHeaderView.h"
@interface THKSelectMaterialTabVC ()<THKDynamicTabsManagerDelegate>
@property (nonatomic, strong) THKSelectMaterialTabVM *viewModel;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
@property (nonatomic, strong) THKSelectMaterialHeaderView *headerView;

@end

@implementation THKSelectMaterialTabVC
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
    
}

- (void)bindViewModel{
    @weakify(self);
    [self.dynamicTabsManager.viewModel.tabsLoadFinishSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        THKSelectMaterialHeaderViewModel *headerViewModel = [[THKSelectMaterialHeaderViewModel alloc] init];
        [self.headerView bindViewModel:headerViewModel];
        self.dynamicTabsManager.viewModel.headerContentViewHeight = 510;
    }];
    
    [self.headerView.tapCoverSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [self.headerView.tapEntrySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    [self.dynamicTabsManager loadTabs];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

- (void)wrapperScrollViewDidScroll:(TMUIPageWrapperScrollView *)wrapperScrollView{
    [NSNotificationCenter.defaultCenter postNotificationName:@"wrapperScrollViewDidScroll" object:wrapperScrollView];
}


#pragma mark - Private

#pragma mark - Getters and Setters

- (THKDynamicTabsManager *)dynamicTabsManager {
    if (!_dynamicTabsManager) {
        THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] initWithTabs:self.viewModel.segmentTitles];
        viewModel.configDynamicTabButtonModelBlock = ^(THKDynamicTabDisplayModel * _Nonnull configButtonModel, NSInteger tabId, NSString * _Nonnull title) {
            //这里可以根据tabId或title来设值每一个按钮的属性
            configButtonModel.badgeImageColor = THKColor_RedPointColor;
            configButtonModel.normalColor = UIColorHex(7E807E);
            configButtonModel.selectedColor = UIColorHex(333533);
            configButtonModel.scale = 0.9;
            configButtonModel.normalFont  = UIFont(14);
            configButtonModel.selectedFont = UIFontMedium(15);
        };
        
        viewModel.layout = THKDynamicTabsLayoutType_Suspend;
        viewModel.parentVC = self;
        viewModel.headerContentViewHeight = 800;
        viewModel.lockArea = NavigationContentTop;
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
        _dynamicTabsManager.sliderBar.indicatorView.backgroundColor = UIColorHex(22C787);
        _dynamicTabsManager.delegate = self;
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
    if ([router routerMatch:THKRouterPage_MaterialHomeTab]) {
        return YES;
    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router{
    THKSelectMaterialTabVM *selectMaterialVM = [[THKSelectMaterialTabVM alloc] init];
    return [[self alloc] initWithViewModel:selectMaterialVM];
}

@end
