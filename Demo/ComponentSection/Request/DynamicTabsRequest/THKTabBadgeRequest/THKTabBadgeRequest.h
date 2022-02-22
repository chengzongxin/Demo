//
//  THKTabBadgeRequest.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/11/2.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKBaseRequest.h"
#import "THKTabBadgeResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, THKTabBadgeType) {
    THKTabBadgeType_Follow //关注
    //TODO...如果有其他的可以继续往后面加
};

@interface THKTabBadgeRequest : THKBaseRequest

@property (nonatomic, assign)   THKTabBadgeType   badgeType;

@end

NS_ASSUME_NONNULL_END
