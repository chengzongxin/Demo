//
//  TMCardComponentCollectionViewLayout.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "MultiStylesCollectionViewWaterfallLayout.h"

NS_ASSUME_NONNULL_BEGIN

/// A supplementary view that identifies the header for a given section.
#define TMCardComponentCollectionElementKindSectionHeader CHTCollectionElementKindSectionHeader

/// A supplementary view that identifies the footer for a given section.
#define TMCardComponentCollectionElementKindSectionFooter CHTCollectionElementKindSectionFooter

/**
 卡片瀑布流列表使用的layout，外部若需要单独集成组件卡片，也可以直接使用此layout，可以复用瀑布流列表相关的layout默认配置参数
 */
@interface TMCardComponentCollectionViewLayout : MultiStylesCollectionViewWaterfallLayout

/**
 获取相关赋值默认配置项后的layout对象
 @note 获取的相关配置项为 双列、列间距为8、同列的上下两item间距为8、整体内容区域距离上下左右边距为 UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
 @note 8.10 UI改版，调整整行两边左右安全间距为10，上下两个item间距为10,横向两个item间距为7 即对应sectionInset为UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)， minimumInteritemSpacing为10， minimumColumnSpacing为7;
 */
+ (instancetype)cardsCollectionLayout;

@end

NS_ASSUME_NONNULL_END
