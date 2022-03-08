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
    self.title = @"123";
    
    [self customNavbar];
    
}

- (void)systemNarbar{
    THKNavigationAvatarTitleViewModel *titleVM = [[THKNavigationAvatarTitleViewModel alloc] init];
    titleVM.avatarUrl = @"https://pic.to8to.com/user/45/headphoto_172172845.jpg!330.jpg?1646703299";
    titleVM.nickname = @"43432";
    titleVM.identificationType = 12;
    titleVM.subCategory = 0;
    titleVM.uid = 172172845;
    THKNavigationAvatarTitleView *titleView = [[THKNavigationAvatarTitleView alloc] initWithViewModel:titleVM];
    
    self.navigationItem.titleView = titleView;
}

- (void)customNavbar{
    self.navBarHidden = YES;
    self.tmui_navBarHidden = YES;
    THKNavigationBar *navBar = [THKNavigationBar createInstance];
    
    [self.view addSubview:navBar];
}


@end
