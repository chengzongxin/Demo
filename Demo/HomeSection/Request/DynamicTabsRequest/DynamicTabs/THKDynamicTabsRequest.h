//
//  THKDynamicTabsRequest.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/7/10.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKBaseRequest.h"
#import "THKDynamicTabsResponse.h"
#import "THKDynamicTabsRequestProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDynamicTabsRequest : THKBaseRequest//<THKDynamicTabsRequestProtocol>

@property (nonatomic, copy) NSString *wholeCode;
@property (nonatomic, copy) NSDictionary *extraParam;


@end

NS_ASSUME_NONNULL_END
