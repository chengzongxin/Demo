//
//  THKViewController+NavigationBar.m
//  Demo
//
//  Created by Joe.cheng on 2022/5/16.
//

#import "THKViewController+NavigationBar.h"

@implementation UIViewController (NavigationBar)

TMUISynthesizeIdStrongProperty(navBar, setNavBar)

- (void)addNavgationBar{
    self.view.backgroundColor = UIColor.whiteColor;
    self.navBarHidden = YES;
    self.navBar = [[TMUINavigationBar alloc] init];
    [self.view addSubview:self.navBar];
}

@end
