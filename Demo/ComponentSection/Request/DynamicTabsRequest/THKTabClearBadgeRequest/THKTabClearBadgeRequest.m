//
//  THKTabClearBadgeRequest.m
//  HouseKeeper
//
//  Created by amby.qin on 2020/11/2.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKTabClearBadgeRequest.h"

@implementation THKTabClearBadgeRequest

- (NSString *)requestUrl {
    if (self.badgeType == THKTabBadgeType_Follow) {
        return [NSString stringWithFormat:@"%@%@/ics/remove/follow/unread", kJavaServerDomain, kJavaServerPath];
    }
    return nil;
}

@end
