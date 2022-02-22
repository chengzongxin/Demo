//
//  THKTabBadgeResponse.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/11/2.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKResponse.h"
#import "THKTabBadgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKTabBadgeResponse : THKResponse

@property (nonatomic, strong)   THKTabBadgeModel    *data;

@end

NS_ASSUME_NONNULL_END
