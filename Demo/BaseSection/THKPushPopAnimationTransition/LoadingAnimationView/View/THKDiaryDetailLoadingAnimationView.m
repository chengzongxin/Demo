//
//  THKDiaryDetailLoadingAnimationView.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/5/12.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKDiaryDetailLoadingAnimationView.h"
//#import "THKCustomCornerRadiusView.h"

@implementation THKDiaryDetailLoadingAnimationView

//- (void)thk_setupViews {
//    
//    UIView *contentView = [[UIView alloc] init];
//    contentView.backgroundColor = [UIColor grayColor];
//    
//    UIView *bkg = [[UIView alloc] init];
//    bkg.backgroundColor = [UIColor whiteColor];
//    bkg.layer.cornerRadius = 12;
//    
//    THKCustomCornerRadiusView *v1 = [[THKCustomCornerRadiusView alloc] init];
//    v1.backgroundColor = _THKColorWithHexString(@"f5f7fa");
//    v1.customCornerRadius = THKCustomCornerRadiusMake(4, 20, 20, 4);
//    THKComponentView *v2 = [[THKComponentView alloc] init];
//    THKComponentView *v3 = [[THKComponentView alloc] init];
//    THKComponentView *v4 = [[THKComponentView alloc] init];
//    THKComponentView *v5 = [[THKComponentView alloc] init];
//    THKComponentView *v6 = [[THKComponentView alloc] init];
//    THKComponentView *v7 = [[THKComponentView alloc] init];
//    THKComponentView *v8 = [[THKComponentView alloc] init];
//    THKComponentView *v9 = [[THKComponentView alloc] init];
//    THKComponentView *v10 = [[THKComponentView alloc] init];
//    THKComponentView *v11 = [[THKComponentView alloc] init];
//    THKComponentView *v12 = [[THKComponentView alloc] init];
//    THKComponentView *v13 = [[THKComponentView alloc] init];
//    THKComponentView *v14 = [[THKComponentView alloc] init];
//
//    [self addSubview:contentView];
//    [contentView addSubview:bkg];
//
//    [bkg addSubview:v1];
//    [bkg addSubview:v2];
//    [bkg addSubview:v3];
//    [bkg addSubview:v4];
//    [bkg addSubview:v5];
//    [bkg addSubview:v6];
//    [bkg addSubview:v7];
//    [bkg addSubview:v8];
//    [bkg addSubview:v9];
//    [bkg addSubview:v10];
//    [bkg addSubview:v11];
//    [bkg addSubview:v12];
//    [bkg addSubview:v13];
//    [bkg addSubview:v14];
//
//    [bkg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(contentView);
//        make.top.equalTo(@(kTNavigationBarHeight()+40+96));
//    }];
//
//    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(bkg);
//        make.centerY.equalTo(bkg.mas_top);
//        make.size.mas_equalTo(CGSizeMake(130, 170));
//    }];
//    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(20));
//        make.right.equalTo(@(-20));
//        make.top.equalTo(@(120));
//        make.height.equalTo(@(33));
//    }];
//    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(v2);
//        make.top.equalTo(v2.mas_bottom).offset(10);
//        make.height.equalTo(@(17));
//    }];
//    [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(v3);
//        make.top.equalTo(v3.mas_bottom).offset(10);
//        make.height.equalTo(@(14));
//    }];
//    [v5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(@(0));
//        make.top.equalTo(@(234));
//        make.height.equalTo(@(8));
//    }];
//    [v6 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(24));
//        make.top.equalTo(v5.mas_bottom).offset(12);
//        make.size.mas_equalTo(CGSizeMake(60, 38));
//    }];
//    [v7 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(20));
//        make.right.equalTo(@(-20));
//        make.top.equalTo(v6.mas_bottom).offset(30);
//        make.height.equalTo(@(35));
//    }];
//    [v8 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(v7);
//        make.top.equalTo(v7.mas_bottom).offset(16);
//        make.height.equalTo(@(15));
//    }];
//    [v9 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(v8);
//        make.top.equalTo(v8.mas_bottom).offset(8);
//        make.height.equalTo(v8);
//    }];
//    [v10 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(v9);
//        make.right.equalTo(v9.mas_right).offset(-100);
//        make.top.equalTo(v9.mas_bottom).offset(8);
//        make.height.equalTo(v9);
//    }];
//    [v11 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(20));
//        make.right.equalTo(@(-20));
//        make.top.equalTo(v10.mas_bottom).offset(30);
//        make.height.equalTo(@(35));
//    }];
//    [v12 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(v11);
//        make.top.equalTo(v11.mas_bottom).offset(16);
//        make.height.equalTo(@(15));
//    }];
//    [v13 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(v12);
//        make.top.equalTo(v12.mas_bottom).offset(8);
//        make.height.equalTo(v12);
//    }];
//    [v14 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(v13);
//        make.right.equalTo(v13.mas_right).offset(-100);
//        make.top.equalTo(v13.mas_bottom).offset(8);
//        make.height.equalTo(v13);
//    }];
//    
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//}


@end
