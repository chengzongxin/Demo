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
            lbl.text = @"系统导航栏";
        }
            break;
        case 2:
        {
            [self customNavbar];
            lbl.text = @"自定义导航栏";
        }
            break;
        default:
            break;
    }
    
}

- (void)systemNarbar{
    self.navigationItem.titleView = [self getAvatarTitleView];
}

- (void)customNavbar{
    self.navBarHidden = YES;
    THKNavigationBar *navBar = [THKNavigationBar createInstance];
    [navBar configContent:^__kindof UIView * _Nonnull(UIView * _Nonnull contentView) {
        THKNavigationAvatarTitleView *titleView = [self getAvatarTitleView];
        [contentView addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(contentView);
        }];
        return titleView;
    }];
    
    
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
