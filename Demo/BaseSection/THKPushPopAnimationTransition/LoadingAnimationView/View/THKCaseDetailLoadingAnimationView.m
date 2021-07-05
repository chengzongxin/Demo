//
//  THKCaseDetailLoadingAnimationView.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKCaseDetailLoadingAnimationView.h"
#import "THKTextComponentView.h"

@implementation THKCaseDetailLoadingAnimationView


- (void)thk_setupViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 12;
    
    THKComponentView *v1 = [[THKComponentView alloc] init];
    THKComponentView *v2 = [[THKComponentView alloc] init];
    THKComponentView *v3 = [[THKComponentView alloc] init];
    THKComponentView *v4 = [[THKComponentView alloc] init];
    THKComponentView *v5 = [[THKComponentView alloc] init];
    THKComponentView *v6 = [[THKComponentView alloc] init];
    THKComponentView *v7 = [[THKComponentView alloc] init];
    THKTextComponentView *v8 = [[THKTextComponentView alloc] init];
    THKComponentView *v9 = [[THKComponentView alloc] init];
    THKComponentView *v10 = [[THKComponentView alloc] init];
    THKTextComponentView *v11 = [[THKTextComponentView alloc] init];

    [self addSubview:contentView];
    
    [contentView addSubview:v1];
    [contentView addSubview:v2];
    [contentView addSubview:v3];
    [contentView addSubview:v4];
    [contentView addSubview:v5];
    [contentView addSubview:v6];
    [contentView addSubview:v7];
    [contentView addSubview:v8];
    [contentView addSubview:v9];
    [contentView addSubview:v10];
    [contentView addSubview:v11];

    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.equalTo(@(28));
        make.size.mas_equalTo(CGSizeMake(290, 16));
    }];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1);
        make.top.equalTo(v1.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(149, 16));
    }];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1);
        make.right.equalTo(@(-20));
        make.top.equalTo(v2.mas_bottom).offset(28);
        make.height.equalTo(@(60));
    }];
    [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1);
        make.top.equalTo(v3.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    v4.layer.cornerRadius = 12;
    [v5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v4.mas_right).offset(12);
        make.centerY.equalTo(v4);
        make.size.mas_equalTo(CGSizeMake(84, 24));
    }];
    [v6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.centerY.equalTo(v4);
        make.size.mas_equalTo(CGSizeMake(60, 24));
    }];
    [v7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1);
        make.top.equalTo(v6.mas_bottom).offset(60);
        make.size.mas_equalTo(CGSizeMake(60, 24));
    }];
    [v8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(v7.mas_bottom).offset(40);
    }];
    [v9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1);
        make.top.equalTo(v8.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(60, 24));
    }];
    [v10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1);
        make.right.equalTo(@(-20));
        make.top.equalTo(v9.mas_bottom).offset(40);
        make.height.equalTo(@(190));
    }];
    [v11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(v10.mas_bottom).offset(24);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
