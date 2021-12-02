//
//  THKSelectMaterialVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialTabVC.h"
#import "THKDynamicTabsManager.h"
#import "THKSelectMaterialHeaderView.h"
#import "THKMaterialTabEntranceModel.h"
#import "THKSelectMaterialConst.h"

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
    
    [self.view addSubview:self.dynamicTabsManager.wrapperView];
    [self.dynamicTabsManager.wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.dynamicTabsManager.headerWrapperView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

- (void)bindViewModel{
    @weakify(self);
//    [self.dynamicTabsManager.viewModel.tabsLoadFinishSignal subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//
//        THKSelectMaterialHeaderViewModel *headerViewModel = [[THKSelectMaterialHeaderViewModel alloc] init];
//        [self.headerView bindViewModel:headerViewModel];
//        self.dynamicTabsManager.viewModel.headerContentViewHeight = 510;
//    }];
//
    [self.headerView.tapCoverSubject subscribeNext:^(MaterialTabBannerModel *x) {
        NSLog(@"%@",x);
    }];
    
    [self.headerView.tapEntrySubject subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSNumber *num,NSIndexPath *indexPath,MaterialTabMajorEntrancesModel *model) = x;
        NSLog(@"%@-%@-%@",num,indexPath,model);
        TRouter *router = [TRouter routerFromUrl:model.targetUrl];
        [[TRouterManager sharedManager] performRouter:router];
    }];
    
    [self.viewModel.requestTab.nextSignal subscribeNext:^(THKMaterialV3IndexEntranceResponse *x) {
        @strongify(self);
        NSLog(@"%@",x);
        THKSelectMaterialHeaderViewModel *headerViewModel = [[THKSelectMaterialHeaderViewModel alloc] initWithModel:x.data];
        [self.headerView bindViewModel:headerViewModel];
        CGSize size = [self.headerView sizeThatFits:CGSizeMax];
        self.dynamicTabsManager.viewModel.headerContentViewHeight = size.height;
        
//        [self.dynamicTabsManager.viewModel setTabs:x.data.tabs];
        [self.dynamicTabsManager loadTabs];
    }];
    
    [self.viewModel.requestTab execute:nil];
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
        viewModel.isEnableInfiniteScroll = YES;
        viewModel.parentVC = self;
        viewModel.headerContentViewHeight = 800;
        NSLog(@"%f,%f,%f,%f",StatusBarHeight,kMaterialHomeSearchHeight,kMaterialHomeTabHeight,viewModel.sliderBarHeight);
        CGFloat lockArea = StatusBarHeight + kMaterialHomeSearchHeight + kMaterialHomeTabHeight + viewModel.sliderBarHeight;
        viewModel.lockArea = lockArea;
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
    selectMaterialVM.categoryId = [[router.param safeObjectForKey:@"categoryId"] integerValue];
    return [[self alloc] initWithViewModel:selectMaterialVM];
}

@end
