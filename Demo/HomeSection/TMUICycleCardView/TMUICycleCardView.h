//
//  TMUICycleCardView.h
//  Demo
//
//  Created by Joe.cheng on 2022/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TMUICycleCardViewConfigCellBlock)(UICollectionViewCell *cell,NSIndexPath *indexPath,id model);

@interface TMUICycleCardView : UIView
/// 卡片左右之间的距离 默认16
@property (nonatomic, assign) CGFloat horSpacing;
/// 卡片底部之间的距离 默认 4
@property (nonatomic, assign) CGFloat verSpacing;
/// 自动滚动时长 默认2秒
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;
/// 数据模型，配置后会自动刷新滚动视图
@property (nonatomic, strong) NSArray *models;

/// 注册cell
/// @param cellClass cell的class，
/// usage:[cycle registerCell:[CycleCardCell class]];
- (void)registerCell:(Class)cellClass;

/// 配置Cell
/// @param configBlock 在回调中配置cell元素
- (void)configCell:(TMUICycleCardViewConfigCellBlock)configBlock;


@end

NS_ASSUME_NONNULL_END
