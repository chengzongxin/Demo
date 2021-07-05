//
//  TMCardComponentScrollAdsBannerView.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/10/30.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN
/**
 支持无限横向滚动的广告Banner视图
 */
@interface TMCardComponentScrollAdsBannerView : THKView

/*! 注册cell类型\cell展示时的回调\cell点击时的回调
 * @warning 若cellClass为NULL 则会回调默认的UICollectionViewCell类型
 */
- (void)registCellClass:(Class)cellClass fillCellForRowAtIndex:(void(^)(__kindof UICollectionViewCell * cell, NSUInteger index))fillBlock didClickCellForRowAtIndex:(void(^)(__kindof UICollectionViewCell * cell, NSUInteger index))clickBlock;

/*! 刷新容器视图，需要传入子视图生成的数量
 */
- (void)reloadDataOfTotalItemCount:(NSUInteger)itemCount;

@property (nonatomic, copy, nullable)void(^didScrollToPageIndexBlock)(NSInteger curIdx, NSInteger totalCount);///< 横向滚动时，当前页位置索引发生变化的回调，curIdx为当前展示的数据索引值(从0开始)，totalCount为传入的数据项数量

- (NSInteger)currentIndex;///< 当前显示的广告数据的索引值

/// 当视图离开视野或重新加到视野时调用，只有已调用过reloadDataxx方法后，若需要timer定时滚动以下方法再调用进行暂停、恢复自动滚动才会生效
- (void)resumeTimerIfNeed;
- (void)pauseTimeIfNeed;

@end

NS_ASSUME_NONNULL_END
