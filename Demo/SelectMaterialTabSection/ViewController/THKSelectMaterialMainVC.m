//
//  THKSelectMaterialMainVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialMainVC.h"
#import "THKDynamicTabsManager.h"
#import "THKSearchView.h"

@interface THKSelectMaterialMainVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) THKSelectMaterialMainVM *viewModel;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
@property (nonatomic, strong) THKSearchView *searchView;
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
    
    
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarHeight);
        make.left.right.equalTo(self.view).inset(15);
        make.height.mas_equalTo(36);
    }];
    
    [self.view addSubview:self.dynamicTabsManager.sliderBar];
    [self.dynamicTabsManager.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.dynamicTabsManager loadTabs];
    
    @weakify(self);
    [[NSNotificationCenter.defaultCenter rac_addObserverForName:@"wrapperScrollViewDidScroll" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x.object);
        UIScrollView *scrollView = x.object;
        @strongify(self);
        CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
        CGFloat top = 44 - offsetY;
        [self.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
        }];
    }];
}


#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != _dynamicTabsManager.wrapperScrollView) {
        return;
    }
    
    NSLog(@"%@",scrollView);
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
        
        viewModel.layout = THKDynamicTabsLayoutType_Custom;
        viewModel.parentVC = self;
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
        _dynamicTabsManager.wrapperScrollView.delegate = self;
    }
    return _dynamicTabsManager;
}


- (THKSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[THKSearchView alloc] init];
        _searchView.backgroundColor = UIColorHex(F9FAF9);
        _searchView.searchLabel.text = @"大家都在搜：瓷砖";
        _searchView.cornerRadius = 8;
    }
    return _searchView;
}


#pragma mark - Supperclass

#pragma mark - NSObject


@end
