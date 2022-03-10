//
//  THKCustomNavigationViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import "THKCustomNavigationViewController.h"
#import "THKNavigationAvatarTitleView.h"
#import "THKNavigationBar.h"
#import "THKDynamicTabsManager.h"

@interface THKCustomNavigationViewController ()

@property (nonatomic, strong) THKDynamicTabsManager *manager;

@end

@implementation THKCustomNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
    [self.view addSubview:lbl];
    
    switch (self.type) {
        case 1:
        {
            [self systemNarbar1];
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
        default:
            break;
    }
    
}

- (void)systemNarbar1{
    self.navigationItem.titleView = [self getAvatarTitleView];
}

- (void)customNavbar2{
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    navBar.title = @"标题😆";
    [self.view addSubview:navBar];
}

- (void)customNavbar3{
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    navBar.title = @"标题😆";
    navBar.barStyle = THKNavigationBarStyle_Dark;
    [self.view addSubview:navBar];
}

- (void)customNavbar4{
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    navBar.titleView = [self tabsSliderBar];
    [self.view addSubview:navBar];
}

- (void)customNavbar5{
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    navBar.titleView = [self getAvatarTitleView];
    [self.view addSubview:navBar];
}

- (THKNavigationAvatarTitleView *)getAvatarTitleView{
    THKNavigationAvatarTitleViewModel *titleVM = [[THKNavigationAvatarTitleViewModel alloc] init];
    titleVM.avatarUrl = @"https://pic.to8to.com/user/45/headphoto_172172845.jpg!330.jpg?1646703299";
    titleVM.nickname = @"43432";
    titleVM.identificationType = 12;
    titleVM.subCategory = 0;
    titleVM.uid = 172172845;
    THKNavigationAvatarTitleView *titleView = [[THKNavigationAvatarTitleView alloc] initWithViewModel:titleVM];
    return titleView;
}

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
        make.edges.equalTo(self.view);
    }];
    [manager loadTabs];
    manager.sliderBar.minItemWidth = (TMUI_SCREEN_WIDTH - 54 * 2)/2;
    _manager = manager;
    return manager.sliderBar;
}

@end
