//
//  TMCardComponentCellSizeTool.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import "TMCardComponentCellDataProtocol.h"
#import "TMCardComponentCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

/**用于计算相关cell显示的size的工具类*/
@interface TMCardComponentCellSizeTool : NSObject

/**
 若data的cellSize为CGSizeZero且style为组件支持的统一双瀑布流样式的卡片类型，则计算并赋值相关cellSize属性
 layout有相关其它配置数据
 @warning 若相关style为custom则此方法内部不处理
 */
+ (void)loadCellSizeToCellDataIfNeed:(NSObject<TMCardComponentCellDataProtocol> *)data layout:(__kindof CHTCollectionViewWaterfallLayout*)layout;

/// 可以指定加载section的 UIEdgeInsets
+ (void)loadCellSizeToCellDataIfNeed:(NSObject<TMCardComponentCellDataProtocol> *)data layout:(__kindof CHTCollectionViewWaterfallLayout*)layout sectionInset:(UIEdgeInsets )sectionInset;

#pragma mark - 辅助方法字体、行间距等
///MARK: 主要用于NormalStyle样式里的标题文本高度计算
+ (CGFloat)NormalStyleCellTitleLineGap;///< 当标题支持多行显示时的标题文本的行间距
+ (UIFont *)NormalStyleCellTitleFont;///<  当标题支持多行显示时的标题字体

+ (UIColor *)NormalStyleCellTitleColor;///<  当标题支持多行显示时的标题颜色
+ (UIFont *)NormalStyleCellTitlTextTagFont;///< v8.11 add| 显示在标题串前面位置的文本标签串的字体
+ (UIColor *)NormalStyleCellTitlTextTagForegroundColor;///< v8.11 add| 标题前面的文本标签串的颜色
+ (UIColor *)NormalStyleCellTitlTextTagBackgroundColor;///< v8.11 add| 标题前面文本标签串区域的背景色

///MARK: 主要用于TopicStyle样式里的标题文本高度计算
+ (UIFont *)TopicStyleCellTitleFont;///<  当标题支持多行显示时的标题字体
+ (CGFloat)TopicStyleCellTitleLineGap;///< 当标题支持多行显示时的标题文本的行间距

@end

NS_ASSUME_NONNULL_END
