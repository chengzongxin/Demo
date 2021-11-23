//
//  THKSelectMaterialVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialVC.h"
#import "THKDynamicTabsManager.h"
@interface THKSelectMaterialVC ()

@property (nonatomic, strong) THKSelectMaterialVM *viewModel;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;

@end

@implementation THKSelectMaterialVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.tmui_randomColor;
    self.navigationController.navigationBar.hidden = YES;
    
    [self.view addSubview:self.dynamicTabsManager.wrapperView];
    [self.dynamicTabsManager.wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, tmui_safeAreaBottomInset()));
    }];
    
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
        viewModel.parentVC = self;
        viewModel.headerContentViewHeight = 321;
        viewModel.lockArea = NavigationContentTop;
        viewModel.headerContentView = [UIView new];
        viewModel.headerContentView.backgroundColor = UIColor.tmui_randomColor;
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
    }
    return _dynamicTabsManager;
}

#pragma mark - Supperclass

#pragma mark - NSObject


@end
