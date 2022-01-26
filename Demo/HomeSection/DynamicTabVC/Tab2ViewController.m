//
//  Tab2ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/1/24.
//

#import "Tab2ViewController.h"
#import "THKDynamicTabsManager.h"
#import "DynamicTabChildVC.h"
#import "THKDiaryBookDetailTopNaviBarView.h"
#import <MJRefresh.h>
@interface Tab2ViewController ()<THKDynamicTabsManagerDelegate>

@property (nonatomic, strong) THKDiaryBookDetailTopNaviBarView *topBar;
@property (nonatomic, strong) THKDynamicTabsManager *dynamicTabsManager;
// 私有头部
@property (nonatomic, strong) UIView *headerView;
@end

@implementation Tab2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.dynamicTabsManager.view];
    [self.dynamicTabsManager.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
//    [self.view addSubview:self.headerView];
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(NavigationContentTop+44);
//    }];
//
//    [self.view addSubview:self.topBar];
//    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(NavigationContentTop);
//    }];
//
//    [self.headerView addSubview:self.dynamicTabsManager.sliderBar];
//    [self.dynamicTabsManager.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(0);
//        make.left.mas_offset(0);
//        make.height.mas_equalTo(44);
//        make.width.mas_equalTo(TMUI_SCREEN_WIDTH);
//    }];
    
    NSArray *vcs = @[DynamicTabChildVC.new,DynamicTabChildVC.new,DynamicTabChildVC.new];
    NSArray *titles = @[@"12",@"12",@"12"];
    
    [self.dynamicTabsManager.viewModel setVCs:vcs titles:titles];
    [self.dynamicTabsManager loadTabs];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (THKDynamicTabsManager *)dynamicTabsManager {
    if (!_dynamicTabsManager) {
        THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] init];
        viewModel.configDynamicTabButtonModelBlock = ^(THKDynamicTabDisplayModel * _Nonnull configButtonModel, NSInteger tabId, NSString * _Nonnull title) {
            //这里可以根据tabId或title来设值每一个按钮的属性
            configButtonModel.badgeImageColor = THKColor_RedPointColor;
            configButtonModel.normalColor = THKColor_999999;
            configButtonModel.selectedColor = THKColor_333333;
            configButtonModel.normalFont  = [UIFont fontWithName:@"PingFangSC-Regular" size:15.6];
            configButtonModel.selectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16.7];
        };
        
        viewModel.layout = THKDynamicTabsLayoutType_Interaction;
        viewModel.headerContentView = self.topBar;
        viewModel.headerContentViewHeight = NavigationContentTop;
        viewModel.headerContentView.backgroundColor = UIColor.tmui_randomColor;
        viewModel.parentVC = self;
        
        _dynamicTabsManager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
        _dynamicTabsManager.delegate = self;
    }
    return _dynamicTabsManager;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, NavigationContentTop+44)];
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

- (THKDiaryBookDetailTopNaviBarView *)topBar{
    if (!_topBar) {
        _topBar = [[THKDiaryBookDetailTopNaviBarView alloc] init];
        _topBar.backgroundColor = UIColor.whiteColor;
        _topBar.backBtn.tmui_image = UIImageMake(@"nav_back_black");
        _topBar.nickNameLbl.textColor = UIColorHex(1A1C1A);
        @weakify(self);
        [[_topBar.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _topBar;
}

@end
