//
//  UIViewController+THKNavigationBar.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2022/6/13.
//  Copyright © 2022 binxun. All rights reserved.
//

#import "UIViewController+THKNavigationBar.h"

@implementation UIViewController (THKNavigationBar)

#pragma mark THKNavigationTitleProtocol 简单设置标题

- (void)setThk_title:(NSString *)thk_title{
    self.thk_navBar.title = thk_title;
}

- (void)setThk_attrTitle:(NSAttributedString *)thk_AttrTitle{
    self.thk_navBar.attrTitle = thk_AttrTitle;
}

- (NSString *)thk_title{
    return self.thk_navBar.title;
}

- (NSAttributedString *)thk_attrTitle{
    return self.thk_navBar.attrTitle;
}

- (void)setThk_leftTitle:(NSString *)thk_leftTitle{
    UIButton *btn = [self setupItemButton:thk_leftTitle attrTitle:nil image:nil target:self selector:@selector(navBackAction:)];
    self.thk_navBar.leftView = btn;
}

- (NSString *)thk_leftTitle{
    UIButton *btn = (UIButton *)self.thk_navBar.leftView;
    if ([btn isKindOfClass:UIButton.class]) {
        return btn.tmui_text;
    }else{
        return nil;
    }
}

- (void)setThk_attrLeftTitle:(NSAttributedString *)thk_attrLeftTitle{
    UIButton *btn = [self setupItemButton:nil attrTitle:thk_attrLeftTitle image:nil target:self selector:@selector(navBackAction:)];
    self.thk_navBar.leftView = btn;
}

- (NSAttributedString *)thk_attrLeftTitle{
    UIButton *btn = (UIButton *)self.thk_navBar.leftView;
    if ([btn isKindOfClass:UIButton.class]) {
        return btn.tmui_attrText;
    }else{
        return nil;
    }
}

- (void)setThk_rightTitle:(NSString *)thk_rightTitle{
    UIButton *btn = [self setupItemButton:thk_rightTitle attrTitle:nil image:nil target:self selector:@selector(navRightAction:)];
    self.thk_navBar.rightView = btn;
}

- (NSString *)thk_rightTitle{
    UIButton *btn = (UIButton *)self.thk_navBar.rightView;
    if ([btn isKindOfClass:UIButton.class]) {
        return btn.tmui_text;
    }else{
        return nil;
    }
}

- (void)setThk_attrRightTitle:(NSAttributedString *)thk_attrRightTitle{
    UIButton *btn = [self setupItemButton:nil attrTitle:thk_attrRightTitle image:nil target:self selector:@selector(navRightAction:)];
    self.thk_navBar.rightView = btn;
}

- (NSAttributedString *)thk_attrRightTitle{
    UIButton *btn = (UIButton *)self.thk_navBar.rightView;
    if ([btn isKindOfClass:UIButton.class]) {
        return btn.tmui_attrText;
    }else{
        return nil;
    }
}

- (void)thk_setBackItemEnable:(BOOL)isEnable{
//    [self thk_setBackItemEnable:isEnable diaEnableColor:[UIBarButtonItem t_unEnableTextColor]];
}

- (void)thk_setBackItemEnable:(BOOL)isEnable diaEnableColor:(UIColor *)disEnableColor{
    [self thk_setButtonItem:(UIButton *)self.thk_navBar.leftView enable:isEnable diaEnableColor:disEnableColor];
}

- (void)thk_setRightItemEnable:(BOOL)isEnable{
//    [self thk_setRightItemEnable:isEnable diaEnableColor:[UIBarButtonItem t_unEnableTextColor]];
}

- (void)thk_setRightItemEnable:(BOOL)isEnable diaEnableColor:(UIColor *)disEnableColor{
    [self thk_setButtonItem:(UIButton *)self.thk_navBar.rightView enable:isEnable diaEnableColor:disEnableColor];
}


- (void)thk_setButtonItem:(UIButton *)btn enable:(BOOL)isEnable diaEnableColor:(UIColor *)disEnableColor{
    if (![btn isKindOfClass:[UIButton class]]) {
        return;
    }
    if (isEnable) {
//        disEnableColor = [UIBarButtonItem t_normalTextColor];
    }
    
    [btn setTitleColor:disEnableColor forState:UIControlStateNormal];
    btn.selected = !isEnable;
    btn.enabled = isEnable;
}

- (void)thk_setBackButtonItemTitle:(NSString *)title target:(id)target action:(SEL)selector{
    UIButton *btn = [self setupItemButton:title attrTitle:nil image:nil target:target selector:selector];
    self.thk_navBar.leftView = btn;
}

- (void)thk_setRightButtonItemTitle:(NSString *)title target:(id)target action:(SEL)selector{
    UIButton *btn = [self setupItemButton:title attrTitle:nil image:nil target:target selector:selector];
    self.thk_navBar.rightView = btn;
}

- (void)thk_setBackButtonItemImage:(UIImage *)image target:(id)target action:(SEL)selector{
    UIButton *btn = [self setupItemButton:nil attrTitle:nil image:image target:target selector:selector];
    self.thk_navBar.leftView = btn;
}

- (void)thk_setRightButtonItemImage:(UIImage *)image target:(id)target action:(SEL)selector{
    UIButton *btn = [self setupItemButton:nil attrTitle:nil image:image target:target selector:selector];
    self.thk_navBar.rightView = btn;
}

- (void)thk_setBackButtonItemTitle:(NSString *)title Image:(UIImage *)image target:(id)target action:(SEL)selector{
    UIButton *btn = [self setupItemButton:title attrTitle:nil image:image target:target selector:selector];
    self.thk_navBar.leftView = btn;
}

- (void)thk_setRightButtonItemTitle:(NSString *)title Image:(UIImage *)image target:(id)target action:(SEL)selector{
    UIButton *btn = [self setupItemButton:title attrTitle:nil image:image target:target selector:selector];
    self.thk_navBar.rightView = btn;
}


#pragma mark - 创建对应的ItemButton

- (UIButton *)setupItemButton:(NSString *)title attrTitle:(NSAttributedString *)attrTitle image:(UIImage *)image target:(id)target selector:(SEL)selector{
    UIButton *btn = [UIButton tmui_button];
    btn.tmui_font = UIFont(16);
    btn.tmui_titleColor = UIColorHex(333533);
    if (title) {
        btn.tmui_text = title;
    }
    if (attrTitle) {
        btn.tmui_attrText = attrTitle;
    }
    if (image) {
        btn.tmui_image = image;
    }
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [btn tmui_addTarget:target action:selector];
    return btn;
}


#pragma mark - Public
- (void)thk_layoutNavgationBar{
    TMUINavigationBar *navBar = objc_getAssociatedObject(self, @selector(thk_navBar));
    if (self.navBarHidden && navBar) {
        [self.view addSubview:navBar];
        [self.view bringSubviewToFront:navBar];
    }
}

- (NSString *)thk_NavBarTitle{
    TMUINavigationBar *navBar = objc_getAssociatedObject(self, @selector(thk_navBar));
    if (self.navBarHidden && navBar) {
        return navBar.title;
    }else{
        return nil;
    }
}

#pragma mark - setter & getter


- (TMUINavigationBar *)thk_navBar{
    TMUINavigationBar *navBar = objc_getAssociatedObject(self, _cmd);
    if (!navBar) {
        navBar = [[TMUINavigationBar alloc] init];
        objc_setAssociatedObject(self, _cmd, navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.navBarHidden = YES;
        if (THKNavBarInTabVC) {
            // 如果在嵌套tab下，设置隐藏，高度为0，不影响其他UIView的约束
            navBar.height = 0;
            navBar.hidden = YES;
        }
        if ([self isViewLoaded]) {
            [self.view addSubview:navBar];
            self.view.tmui_layoutSubviewsBlock = ^(__kindof UIView * _Nonnull view) {
                if (navBar.superview == view) {
                    [view bringSubviewToFront:navBar];
                }
            };
        }
    }
    return navBar;
}


#pragma mark - TMUINavigationBarProtocol 响应导航item上点击操作
- (void)navBackAction:(id)sender{
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)navRightAction:(UIButton *)btn{
    
}


@end
