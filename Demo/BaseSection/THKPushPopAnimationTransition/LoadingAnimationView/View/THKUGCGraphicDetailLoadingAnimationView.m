//
//  THKUGCGraphicDetailLoadingAnimationView.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/6/18.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKUGCGraphicDetailLoadingAnimationView.h"

@implementation THKUGCGraphicDetailLoadingAnimationView

- (void)thk_setupViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 12;
    
    THKComponentView *v1 = [[THKComponentView alloc] init];
    THKComponentView *v2 = [[THKComponentView alloc] init];
    THKComponentView *v3 = [[THKComponentView alloc] init];
    THKTextComponentView *v4 = [[THKTextComponentView alloc] init];
    THKTextComponentView *v5 = [[THKTextComponentView alloc] init];
    THKTextComponentView *v6 = [[THKTextComponentView alloc] init];
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
    
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.equalTo(@(24));
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    v1.layer.cornerRadius = 16;
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1.mas_right).offset(12);
        make.centerY.equalTo(v1);
        make.size.mas_equalTo(CGSizeMake(90, 24));
    }];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.centerY.equalTo(v1);
        make.size.mas_equalTo(CGSizeMake(72, 32));
    }];
    v3.layer.cornerRadius = 6;
    [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(v3.mas_bottom).offset(30);
    }];
    [v5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(v4.mas_bottom).offset(30);
    }];
    [v6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(v5.mas_bottom).offset(30);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


@end
