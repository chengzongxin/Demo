//
//  TMCardComponentHelper.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/9/7.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "TMCardComponentCellDataModel.h"
#import "TMCardComponentCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 对于外部自定义collectionview, 若需要直接用到卡片组件样式cell的ui，提供一些便捷的对外方法
 @note 注意collectionView的layout必须是 CHTCollectionViewWaterfallLayout, 否则调用相关方法时会报错
 */
@interface TMCardComponentHelper : NSObject

/**
 向collectionView实例中注册当前版本所支持的卡片组件cell
 */
+ (void)registCardComponentCellsInCollectionView:(UICollectionView *)collectionView;


/**
 内部有相关懒加载cellData的layout_cellSize的处理逻辑，外部可调用此方法获取正确的cellSize进行布局，也可在外部自行调用相关方法对cellData中的layout相关的属性赋值
 @note 外部若手动对layout相关属性赋值，可调用代码 @code [TMCardComponentCellSizeTool loadCellSizeToCellDataIfNeed:cellData layout:(CHTCollectionViewWaterfallLayout*)collectionView.collectionViewLayout] @endcode
 */
+ (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(CHTCollectionViewWaterfallLayout*)layout
                cellData:(__kindof TMCardComponentCellDataModel *)cellData
            sectionInset:(UIEdgeInsets)inset;

/**
 
传入卡片组件对应的数据项，返回一个可直接作collectionView当前cell的对象
 * @warning cellData.style 若为Custom则返回nil
 * @param collectionView 对应的瀑布流列表视图实例
 * @param cellData 对应的瀑布流卡片组件样式cell所对应的数据模型对象
 * @param indexPath 对应瀑布流当前的索引对象
 * @param godEyeReportDataBlock 卡片组件涉及天眼上报所需的相关widgetUid及geResource数据字典的相关外部赋值回调
 * @note 内部会根据godEyeReportDataBlock处理的相关值，自行判断处理cell的天眼上报数据的赋值逻辑，此方法内部还会处理cell天眼暴光的相关逻辑。但cell的点击天眼上报处理需要外部自行手动调用。 可在点击时加上代码 @code if (cell.geWidgetUid.length > 0) {
     [[GEWidgetClickEvent eventWithWidget:cell indexPath:indexPath] report];
 } @endcode 即可
 */
+ (__kindof UICollectionViewCell<TMCardComponentCellProtocol> *)collectionViewCellInCollectionView:(UICollectionView *)collectionView
                                                             cellData:(__kindof TMCardComponentCellDataModel *)cellData
                                                        itemIndexPath:(NSIndexPath *)indexPath
                                                godEyeReportDataBlock:(void(^)(NSString **cellWidgetUid, NSDictionary **cellResource))godEyeReportDataBlock;

@end

NS_ASSUME_NONNULL_END
