//
//  THKAvatarViewModel.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/2/7.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKAvatarViewModel.h"

@implementation THKAvatarViewModel

- (instancetype)initWithAvatarUrl:(NSString *)avatarUrl identityType:(NSInteger)identityType{
    return [self initWithAvatarUrl:avatarUrl placeHolderImage:nil identityType:identityType identitySubType:0];
}

- (instancetype)initWithAvatarUrl:(NSString *)avatarUrl placeHolderImage:(nullable UIImage *)placeHolderImage identityType:(NSInteger)identityType identitySubType:(NSInteger)identitySubType{
    if (self == [super init]) {
        self.avatarUrl = avatarUrl;
        self.placeHolderImage = placeHolderImage;
        self.identityType = identityType;
        self.identitySubType = identitySubType;
    }
    return self;
}

- (void)initialize{
    self.placeHolderImage = kDefaultHeadImg;
    self.identityType = 0;
    self.identitySubType = 0;
    self.onTapSubject = RACSubject.subject;
    self.identityRatio = 3.6;
    self.identityIconCenterOffset = CGPointZero;
    self.onTapSubject = RACSubject.subject;
}

- (void)setIdentityRatio:(CGFloat)identityRatio{
    _identityRatio = identityRatio;
    if (identityRatio <= 0) {
        NSAssert(0, @"比例必须大于0");
    }
}

@end
