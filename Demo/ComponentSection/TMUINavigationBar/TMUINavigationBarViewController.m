//
//  TMUINavigationBarViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/5/16.
//

#import "TMUINavigationBarViewController.h"
#import "TMUINavigationBar.h"
#import "THKDynamicTabsManager.h"
#import "THKNavigationAvatarTitleView.h"
#import "THKNavigationBarAvatarViewModel.h"
#import "THKNavigationBarSearchViewModel.h"


#define invoke(method) \
SEL selector = NSSelectorFromString(method); \
IMP imp = [self methodForSelector:selector]; \
void (*func)(id, SEL) = (void *)imp; \
func(self, selector);


@interface TMUINavigationBarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TMUINavigationBar *navBar;

@property (nonatomic, strong) THKDynamicTabsManager *manager;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TMUINavigationBarViewController

- (void)demoaction{
    UIEdgeInsets paddings = UIEdgeInsetsMake(24 + NavigationContentTop, 24 + self.view.tmui_safeAreaInsets.left, 24 +  self.view.tmui_safeAreaInsets.bottom, 24 + self.view.tmui_safeAreaInsets.right);
    
    TMUIFloatLayoutView *layoutView = [[TMUIFloatLayoutView alloc] tmui_initWithSize:TMUIFloatLayoutViewAutomaticalMaximumItemSize];
    layoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 8);
    
    NSArray *btns = @[@"显示/隐藏 返回按钮",@"显示/隐藏 分享按钮",@"白色/黑色"];
    
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
    }else if (btn.tag == 2) {
        _navBar.barStyle = !_navBar.barStyle;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demoaction];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navBarHidden = YES;
    self.navBar = [[TMUINavigationBar alloc] init];
    [self.view addSubview:self.navBar];
//    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(88);
//    }];
    NSString *method = [NSString stringWithFormat:@"customNavbar%zd",_type];
    invoke(method)
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
    [self.view addSubview:lbl];
    
//    NSLog(@"avatarTitleView = %@",self.navBar.avatarTitleView);
//    NSLog(@"searchBar = %@",self.navBar.searchBar);
}


- (void)customNavbar1{
    self.navBar.title = @"标题😆";
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tmui_image = [UIImage imageNamed:@"nav_back_black"];
    [btn1 tmui_addTarget:self action:@selector(back)];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tmui_image = [UIImage imageNamed:@"nav_back_black"];
    [btn2 tmui_addTarget:self action:@selector(back)];
    
    UIImageView *img1 = ImageView.img(UIImageMake(@"nav_share_black"));
    UIImageView *img2 = ImageView.img(UIImageMake(@"home_nav_search"));
    
    
//    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(40);
//    }];
//    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(40);
//    }];
    
    
    [self.navBar setLeftViews:btn1,img1,nil];
//    [self.navBar setRightViews:UISwitch.new,img2,UISwitch.new,nil];
    self.navBar.rightView = img2;
//    [self.navBar setRightView:img2 size:CGSizeMake(60, 30)];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customNavbar2{
    self.navBar.title = @"标题😆";
    self.navBar.barStyle = TMUINavigationBarStyle_Dark;
    self.navBar.rightViewType = TMUINavigationBarRightViewType_Share;
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
    self.navBar.backgroundImage = UIImageMake(@"diary_nav_back");
    self.navBar.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
//    [self.navBar bindViewModel:avatarVM];
    THKNavigationAvatarTitleView *avatarTitleView = [[THKNavigationAvatarTitleView alloc] initWithViewModel:avatarVM];
    self.navBar.titleView = avatarTitleView;
}

- (void)customNavbar5{
    TMUISearchBar *search = [[TMUISearchBar alloc] initWithStyle:0];
    search.showsCancelButton = YES;
    self.navBar.titleViewEdgeInsetWhenHiddenEdgeButton = UIEdgeInsetsMake(0, 20, 0, 0);
    self.navBar.titleViewInset = UIEdgeInsetsMake(4, 0, 4, 0);
    self.navBar.titleView = search;
}

- (void)customNavbar6{
    TMUISearchBar *search = [[TMUISearchBar alloc] initWithStyle:1];
    search.showsCancelButton = YES;
    self.navBar.titleViewEdgeInsetWhenHiddenEdgeButton = UIEdgeInsetsMake(0, 20, 0, 0);
    self.navBar.titleViewInset = UIEdgeInsetsMake(4, 0, 4, 0);
    self.navBar.titleView = search;
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