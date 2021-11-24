//
//  THKAvatarViewModel.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/2/7.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKAvatarViewModel.h"

@interface THKAvatarViewModel ()
@property (nonatomic, strong) RACSubject *onTapSubject;
@property (nonatomic, assign)BOOL isTapEnable;
@end

@implementation THKAvatarViewModel

- (instancetype)initWithAvatarUrl:(NSString *)avatarUrl identityType:(NSInteger)identityType identitySubType:(NSInteger)identitySubType{
    return [self initWithAvatarUrl:avatarUrl placeHolderImage:kDefaultHeadPortrait_60 identityType:identityType identitySubType:identitySubType];
}

- (instancetype)initWithAvatarUrl:(NSString *)avatarUrl placeHolderImage:(nullable UIImage *)placeHolderImage identityType:(NSInteger)identityType identitySubType:(NSInteger)identitySubType{
    if (self = [super init]) {        
        self.avatarUrl = avatarUrl;
        self.placeHolderImage = placeHolderImage;
        self.identityType = identityType;
        self.identitySubType = identitySubType;
    }
    return self;
}

- (void)initialize{
    self.placeHolderImage = kDefaultHeadPortrait_60;
    self.identityType = 0;
    self.identitySubType = 0;
    self.onTapSubject = RACSubject.subject;
    self.identityRatio = 3.6;
    self.identityIconCenterOffset = CGPointZero;    
}

- (void)setIdentityRatio:(CGFloat)identityRatio{
    _identityRatio = identityRatio;
    if (identityRatio <= 0) {
        NSAssert(0, @"比例必须大于0");
    }
}

//@synthesize isTapEnable = _isTapEnable;
//- (void)makeTapEnable:(BOOL)tapEnable {
//    self.isTapEnable = tapEnable;
//}
//
//- (void)makeTapAutoEnableAndSignal:(void(^)(RACSubject *tapSubject))tapSignal {
//    [self makeTapEnable:YES];
//    
//    if (tapSignal) {
//        tapSignal(self.onTapSubject);
//    }
//}
//
//- (void)sendNext:(id)x {
//    [self.onTapSubject sendNext:x];
//}

@end
