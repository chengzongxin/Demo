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

///页面滑动的过程中，偏移的位置。
///子页面有view距离底部40，在滑动过程中需要添加offY偏移量，因为vc是固定高度
-(void)contentScrollViewDidScrollOffY:(CGFloat)offY;
@end

NS_ASSUME_NONNULL_END
