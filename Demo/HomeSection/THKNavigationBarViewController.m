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

@interface THKNavigationBarViewController ()

@property (nonatomic, strong) THKNavigationBar *navBar;

@property (nonatomic, strong) THKDynamicTabsManager *manager;

@end

@implementation THKNavigationBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navBarHidden = YES;
    self.navBar = [[THKNavigationBar alloc] init];
    [self.view addSubview:self.navBar];
//    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(88);
//    }];
    
    switch (self.type) {
        case 1:
        {
            [self customNavbar1];
        }
            break;
        case 2:
        {
            [self customNavbar2];
        }
            break;
        case 3:
        {
            [self customNavbar3];
        }
            break;
        case 4:
        {
            [self customNavbar4];
        }
            break;
        case 5:
        {
            [self customNavbar5];
        }
            break;
        case 6:
        {
            [self customNavbar6];
        }
            break;
        default:
            break;
    }
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
    [self.view addSubview:lbl];
    
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
    [self.navBar bindViewModel:searchVM];
}

- (void)customNavbar6{
    THKNavigationBarSearchViewModel *searchVM = [[THKNavigationBarSearchViewModel alloc] init];
    searchVM.barStyle = TMUISearchBarStyle_City;
    [self.navBar bindViewModel:searchVM];
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

@end
