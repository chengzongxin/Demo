//
//  THKTabBadgeRequest.m
//  HouseKeeper
//
//  Created by amby.qin on 2020/11/2.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKTabBadgeRequest.h"

@implementation THKTabBadgeRequest

- (NSString *)requestUrl {
    if (self.badgeType == THKTabBadgeType_Follow) {
        return [NSString stringWithFormat:@"%@%@/ics/follow/unread", kJavaServerDomain, kJavaServerPath];
    }
    return nil;
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (NSDictionary *)parameters {
    return @{};
}

- (Class)modelClass {
    return [THKTabBadgeResponse class];
}

@end
