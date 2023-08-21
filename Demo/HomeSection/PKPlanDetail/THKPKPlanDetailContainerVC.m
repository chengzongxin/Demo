//
//  THKPKPlanDetailContainerVC.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2023/8/18.
//  Copyright © 2023 binxun. All rights reserved.
//

#import "THKPKPlanDetailContainerVC.h"
#import "THKDynamicTabsManager.h"

@interface THKPKPlanDetailContainerVC ()

@property (nonatomic, strong) THKPKPlanDetailContainerVM *viewModel;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
@end

@implementation THKPKPlanDetailContainerVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navBarHidden = YES;
    
    // 添加Tab组件视图
    [self.view addSubview:self.dynamicTabsManager.view];
    [self.dynamicTabsManager.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thk_navBar.mas_bottom).offset(8);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.dynamicTabsManager loadTabs];
}


- (void)bindViewModel{

}

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate
- (void)pageViewController:(THKDynamicTabsPageVC *)pageViewController didScroll:(UIScrollView *)scrollView progress:(CGFloat)progress formIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    [self updateTopBarLayoutWithWrapperScrollView:@(0)];
}

- (void)updateTopBarLayoutWithWrapperScrollView:(NSNumber *)topNum{
    CGFloat top = topNum.floatValue;
    [self.dynamicTabsManager.sliderBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thk_navBar.mas_bottom).offset(top);
    }];
}

#pragma mark - Private
- (void)showEmptyWithType:(TMEmptyContentType)emptyType{
    @weakify(self);
    [TMEmptyView showEmptyInView:self.view safeMargin:UIEdgeInsetsZero contentType:emptyType clickBlock:^{
        @strongify(self);
//        [self.viewModel.requestTab execute:nil];
    }];
}

/// 埋点 appPageCycle
- (void)appPageCycleReport{
    self.gePageLevelPath = @"如何选材|如何选材首页|";
    self.gePageName = @"如何选材首页";
    self.gePageNotDisplay = YES;
}


#pragma mark - Getters and Setters

- (THKDynamicTabsManager *)dynamicTabsManager{
    if (!_dynamicTabsManager) {
        // 配置ViewModel
        THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] initWithTabs:self.viewModel.segmentTitles];
//        viewModel.sliderBarHeight = 40.0;
        viewModel.layout = THKDynamicTabsLayoutType_Normal;
        viewModel.parentVC = self;
        // 创建DynamicTabs
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
//        _dynamicTabsManager.sliderBar.contentLeftMargin = 10;
//        _dynamicTabsManager.sliderBar.bottomSeparatorLine.hidden = NO;
        @weakify(self);
        // 配置曝光埋点
        _dynamicTabsManager.tabButtonExposeBlock = ^(UIButton *button, NSInteger index) {
            NSLog(@"%@-%zd",button,index);
            @strongify(self);
            if (button) {
                
            }
        };
        
        // 配置点击埋点
        _dynamicTabsManager.tabButtonScrollBlock = ^(UIButton *button, NSInteger index) {
            @strongify(self);
            NSLog(@"%@-%zd",button,index);
            // 点击，滑动埋点
            GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:nil];
            THKDynamicTabsModel *tabModel = [self.dynamicTabsManager.viewModel.segmentTabs safeObjectAtIndex:index];
            [resource addObject:tabModel.title forKey:@"widget_type"];
            [resource addObject:@(index) forKey:@"widget_index"];
            
        };
    }
    return _dynamicTabsManager;
}


#pragma mark - Supperclass

#pragma mark - NSObject
+ (BOOL)canHandleRouter:(TRouter *)router {
//    if ([router routerMatch:THKRouterPage_PKPlanDetail]) {
//        return YES;
//    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router {
    THKPKPlanDetailContainerVM *viewModel = [[THKPKPlanDetailContainerVM alloc] init];
    return  [[self alloc] initWithViewModel:viewModel];
}

@end
