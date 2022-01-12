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

/// 开始刷新
- (void)dynamicTabsBeginRefreshing;

/// 停止刷新
- (void)dynamicTabsEndRefreshing;

/// 返回子VC内容滚动列表视图,
/// 1. 用于某些时候需要做唯一联动，避免不必要的滚动视图影响交互
/// 2. 点击状态栏置顶功能
- (UIScrollView *)contentScrollView;

@end

NS_ASSUME_NONNULL_END
