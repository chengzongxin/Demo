//
//  THKDynamicTabsRequestManager.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/11/16.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDynamicTabsRequestManager : NSObject

+ (instancetype)shareInstance;

// 发送网络请求
- (void)sendRequestWithWholeCode:(NSString *)wholeCode success:(THKRequestSuccess)success failure:(THKRequestFailure)failure;

@end

NS_ASSUME_NONNULL_END
