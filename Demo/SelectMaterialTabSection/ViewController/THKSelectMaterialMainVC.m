//
//  THKSelectMaterialMainVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialMainVC.h"
#import "THKDynamicTabsManager.h"
@interface THKSelectMaterialMainVC ()

@property (nonatomic, strong) THKSelectMaterialMainVM *viewModel;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
@end

@implementation THKSelectMaterialMainVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.hidden = YES;
    
    [self.view addSubview:self.dynamicTabsManager.pageContainerVC.view];
    [self.dynamicTabsManager.pageContainerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    [self.view addSubview:self.dynamicTabsManager.wrapperView];
//    [self.dynamicTabsManager.wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, tmui_safeAreaBottomInset()));
//    }];
    
    [self.dynamicTabsManager loadTabs];
}


#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

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
        
        viewModel.layout = THKDynamicTabsLayoutType_Custom;
        viewModel.parentVC = self;
//        viewModel.headerContentViewHeight = 800;
//        viewModel.lockArea = NavigationContentTop;
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
    }
    return _dynamicTabsManager;
}

#pragma mark - Supperclass

#pragma mark - NSObject


@end
