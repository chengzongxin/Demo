//
//  THKNavigationBarViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/5/12.
//

#import "THKNavigationBarViewController.h"
#import "THKNavigationBar.h"
#import "THKDynamicTabsManager.h"
#import "THKNavigationBarAvatarViewModel.h"
#import "THKNavigationBarSearchViewModel.h"

#define invoke(method) \
SEL selector = NSSelectorFromString(method); \
IMP imp = [self methodForSelector:selector]; \
void (*func)(id, SEL) = (void *)imp; \
func(self, selector);

@interface THKNavigationBarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) THKNavigationBar *navBar;

@property (nonatomic, strong) THKDynamicTabsManager *manager;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THKNavigationBarViewController

- (void)demoaction{
    UIEdgeInsets paddings = UIEdgeInsetsMake(24 + NavigationContentTop, 24 + self.view.tmui_safeAreaInsets.left, 24 +  self.view.tmui_safeAreaInsets.bottom, 24 + self.view.tmui_safeAreaInsets.right);
    
    TMUIFloatLayoutView *layoutView = [[TMUIFloatLayoutView alloc] tmui_initWithSize:TMUIFloatLayoutViewAutomaticalMaximumItemSize];
    layoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 8);
    
    NSArray *btns = @[@"显示/隐藏 返回按钮",@"显示/隐藏 分享按钮"];
    
    [btns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TMUIButton *btn = [TMUIButton tmui_button];
        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        btn.cornerRadius = 8;
        btn.tmui_text = obj;
        btn.tmui_titleColor = UIColorWhite;
        btn.backgroundColor = UIColor.tmui_randomColor;
        btn.tag = idx;
        [btn tmui_addTarget:self action:@selector(btnClick:)];
        [layoutView addSubview:btn];
    }];
    
    layoutView.frame = CGRectMake(paddings.left, paddings.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), TMUIViewSelfSizingHeight);
    
    [self.view addSubview:layoutView];
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 0) {
//        _navBar.isBackButtonHidden = !_navBar.isBackButtonHidden;
        [_navBar setIsBackButtonHidden:!_navBar.isBackButtonHidden animate:YES];
    }else if (btn.tag == 1) {
//        _navBar.isRightButtonHidden = !_navBar.isRightButtonHidden;
        [_navBar setIsRightButtonHidden:!_navBar.isRightButtonHidden animate:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demoaction];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navBarHidden = YES;
    self.navBar = [[THKNavigationBar alloc] init];
    [self.view addSubview:self.navBar];
//    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(88);
//    }];
    NSString *method = [NSString stringWithFormat:@"customNavbar%zd",_type];
    invoke(method)
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
    [self.view addSubview:lbl];
    
    NSLog(@"avatarTitleView = %@",self.navBar.avatarTitleView);
    NSLog(@"searchBar = %@",self.navBar.searchBar);
}


- (void)customNavbar1{
    self.navBar.title = @"标题😆";
}

- (void)customNavbar2{
    self.navBar.title = @"标题😆";
    self.navBar.barStyle = THKNavigationBarStyle_Dark;
}

- (void)customNavbar3{
    self.navBar.titleView = [self tabsSliderBar];
}

- (void)customNavbar4{
    THKNavigationBarAvatarViewModel *avatarVM = [[THKNavigationBarAvatarViewModel alloc] init];
    avatarVM.avatarUrl = @"https://pic.to8to.com/user/45/headphoto_172172845.jpg!330.jpg?1646703299";
    avatarVM.nickname = @"43432";
    avatarVM.identificationType = 12;
    avatarVM.subCategory = 0;
    avatarVM.uid = 172172845;
    [self.navBar bindViewModel:avatarVM];
}

- (void)customNavbar5{
    THKNavigationBarSearchViewModel *searchVM = [[THKNavigationBarSearchViewModel alloc] init];
    self.navBar.titleViewEdgeInsetWhenHiddenEdgeButton = UIEdgeInsetsMake(0, 20, 0, 0);
    self.navBar.titleViewInset = UIEdgeInsetsMake(4, 0, 4, 0);
    [self.navBar bindViewModel:searchVM];
}

- (void)customNavbar6{
    THKNavigationBarSearchViewModel *searchVM = [[THKNavigationBarSearchViewModel alloc] init];
    searchVM.barStyle = TMUISearchBarStyle_City;
    self.navBar.titleViewEdgeInsetWhenHiddenEdgeButton = UIEdgeInsetsMake(0, 20, 0, 0);
    self.navBar.titleViewInset = UIEdgeInsetsMake(4, 0, 4, 0);
    [self.navBar bindViewModel:searchVM];
}

- (void)customNavbar7{
    [self.view addSubview:self.tableView];
    
    [self.view bringSubviewToFront:self.navBar];
    self.navBar.title = @"标题😆";
    self.navBar.isRightButtonHidden = NO;
}


/// Tab 组件
- (UIView *)tabsSliderBar{
    UIViewController *vc1 = UIViewController.new;
    vc1.view.backgroundColor = UIColor.tmui_randomColor;
    UIViewController *vc2 = UIViewController.new;
    vc2.view.backgroundColor = UIColor.tmui_randomColor;
    
    THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] initWithVCs:@[vc1,vc2] titles:@[@"推荐",@"关注"]];
    viewModel.layout = THKDynamicTabsLayoutType_Custom;
    viewModel.parentVC = self;
    THKDynamicTabsManager *manager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
    [self.view addSubview:manager.view];
    [manager.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(tmui_navigationBarHeight(), 0, 0, 0));
    }];
    [manager loadTabs];
    manager.sliderBar.minItemWidth = (TMUI_SCREEN_WIDTH - 54 * 2)/2;
    _manager = manager;
    return manager.sliderBar;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f",offsetY);
    
    float percent = offsetY / 200.0;
    if (percent < 0) {
        percent = 0;
    }
    if (percent > 1) {
        percent = 1;
    }
    
    [self.navBar setNavigationBarColor:UIColor.whiteColor originTintColor:UIColor.whiteColor toTintColor:UIColor.blackColor gradientPercent:percent];
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    cell.backgroundColor = [UIColor.tmui_randomColor colorWithAlphaComponent:0.3];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.grayColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.navBar.preferredStatusBarStyle;
}

@end
