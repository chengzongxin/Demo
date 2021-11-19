//
//  THKDynamicTabsRequestProtocol.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/11/16.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol THKDynamicTabsRequestProtocol <NSObject>

@required
/**
 可以多个wholeCode对应一个request
 */
+ (NSArray<NSString *> *)wholeCode;

@end

NS_ASSUME_NONNULL_END
