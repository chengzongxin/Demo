//
//  THKDynamicTabsResponse.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/7/10.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKResponse.h"
#import "THKDynamicTabsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDynamicTabsResponse : THKResponse

@property (nonatomic, copy) NSArray<THKDynamicTabsModel *>  *data;

@end

NS_ASSUME_NONNULL_END
