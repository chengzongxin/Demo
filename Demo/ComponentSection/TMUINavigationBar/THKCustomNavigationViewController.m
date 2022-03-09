//
//  THKCustomNavigationViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import "THKCustomNavigationViewController.h"
#import "THKNavigationAvatarTitleView.h"
#import "THKNavigationBar.h"

@interface THKCustomNavigationViewController ()

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
            [self systemNarbar];
        }
            break;
        case 2:
        {
            [self customNavbar1];
        }
            break;
        case 3:
        {
            [self customNavbar2];
        }
            break;
        default:
            break;
    }
    
}

- (void)systemNarbar{
    self.navigationItem.titleView = [self getAvatarTitleView];
}

- (void)customNavbar1{
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
    navBar.title = @"标题😆";
    [self.view addSubview:navBar];
}


- (void)customNavbar2{
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


@end
