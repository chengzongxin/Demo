//
//  THKDynamicTabsProtocol.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/11/25.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol THKDynamicTabsProtocol <NSObject>

@optional
/**
 刷新
 */
- (void)needReloadData;

/**
 返回YES 每次显示都刷新
 */
- (BOOL)alwaysFreshWhenAppear;

@end

NS_ASSUME_NONNULL_END
