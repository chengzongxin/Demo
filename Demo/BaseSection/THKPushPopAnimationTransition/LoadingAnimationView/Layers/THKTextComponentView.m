//
//  THKTextComponentView.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/6/17.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKTextComponentView.h"
#import "THKComponentView.h"

@implementation THKTextComponentView

- (instancetype)init {
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    THKComponentView *v1 = [[THKComponentView alloc] init];
    THKComponentView *v2 = [[THKComponentView alloc] init];
    THKComponentView *v3 = [[THKComponentView alloc] init];
    THKComponentView *v4 = [[THKComponentView alloc] init];

    [self addSubview:v1];
    [self addSubview:v2];
    [self addSubview:v3];
    [self addSubview:v4];
    
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.equalTo(@(0));
        make.size.mas_equalTo(CGSizeMake(246, 14));
    }];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(@(-20));
        make.top.equalTo(v1.mas_bottom).offset(12);
        make.height.equalTo(@(14));
    }];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(@(-20));
        make.top.equalTo(v2.mas_bottom).offset(12);
        make.height.equalTo(@(14));
    }];
    [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.equalTo(v3.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(123, 14));
        make.bottom.equalTo(self);
    }];
}

@end
