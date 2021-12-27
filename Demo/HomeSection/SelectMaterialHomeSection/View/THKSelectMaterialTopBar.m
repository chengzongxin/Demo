//
//  THKSelectMaterialTopBar.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/24.
//

#import "THKSelectMaterialTopBar.h"

@implementation THKSelectMaterialTopBar

- (void)thk_setupViews {
    [super thk_setupViews];
    
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
        make.bottom.mas_equalTo(-6);
    }];
    
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[UIViewController.new tmui_topViewController].navigationController popViewControllerAnimated:YES];
    }];
}

- (CGSize)intrinsicContentSize{
    return UILayoutFittingExpandedSize;
}

#pragma mark - sub ui lazy loads

TMUI_PropertyLazyLoad(UIButton, backBtn);

@end
