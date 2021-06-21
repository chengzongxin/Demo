//
//  THKDynamicGroupEntranceModel.m
//  HouseKeeper
//
//  Created by amby.qin on 2020/7/10.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKDynamicGroupEntranceModel.h"

@implementation THKDynamicGroupEntranceModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"groupId":@"id"};
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"geReported"];
}

@end

@implementation THKDynamicGroupEntranceData

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"entrances":THKDynamicGroupEntranceModel.class};
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[THKDynamicGroupEntranceData class]]) {
        return NO;
    }
    THKDynamicGroupEntranceData *model = (THKDynamicGroupEntranceData *)object;
    return [self.mj_keyValues isEqual:model.mj_keyValues];
}

@end
