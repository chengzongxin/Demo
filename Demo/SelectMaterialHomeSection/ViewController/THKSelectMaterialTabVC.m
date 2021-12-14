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
    
    [self.dynamicTabsManager.wrapperScrollView bringSubviewToFront:self.dynamicTabsManager.sliderBar];
    
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
    
//    @weakify(self);
    [[NSNotificationCenter.defaultCenter rac_addObserverForName:@"TMUIPageWrapperScrollViewContentOffsetRealChange" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self wrapperScrollViewDidScroll:x.object];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _offsetY = 0;
}


#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

CGFloat _offsetY = 0.0;
CGFloat _offsetTabY = 0.0;
- (void)wrapperScrollViewDidScroll:(TMUIPageWrapperScrollView *)wrapperScrollView{
    if (wrapperScrollView.tmui_isAtTop) {
        return;
    }
    CGFloat lockArea = self.dynamicTabsManager.viewModel.lockArea;
    CGFloat inset = wrapperScrollView.contentOffset.y + lockArea + kMaterialHomeTabHeight;
    
    //  往上滑，diff减少，往下滑，diff增加
    CGFloat diff = [wrapperScrollView tmui_getBoundDoubleForKey:@"diff"];
    _offsetY += diff;
    if (_offsetY < -kMaterialHomeTabHeight) {
        _offsetY = -kMaterialHomeTabHeight;
    }
    if (_offsetY > 0) {
        _offsetY = 0;
    }
    // 往下滚动越多，偏移越多，缩进越多，最多为55，但是吸顶后，会保持55不变
    NSLog(@"%f,%f,%f,%f",_offsetY,diff,inset,wrapperScrollView.contentOffset.y);
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"wrapperScrollViewDidScroll" object:@(_offsetY)];
    
    if (wrapperScrollView.pin) {
        
        _offsetTabY += diff;
        if (_offsetTabY < -44) {
            _offsetTabY = -44;
        }
        if (_offsetTabY > 0) {
            _offsetTabY = 0;
        }
        
//        CGFloat tabTop = _offsetY
        [self.dynamicTabsManager.sliderBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_offsetTabY);
        }];
    }else{
        [self.dynamicTabsManager.sliderBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-44);
        }];
    }
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
        CGFloat lockArea = StatusBarHeight + kMaterialHomeSearchHeight + viewModel.sliderBarHeight;
        viewModel.lockArea = lockArea;
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
        _dynamicTabsManager.sliderBar.indicatorView.backgroundColor = UIColorHex(22C787);
//        _dynamicTabsManager.delegate = self;
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
