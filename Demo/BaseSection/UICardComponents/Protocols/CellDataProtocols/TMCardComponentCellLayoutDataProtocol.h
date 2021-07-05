//
//  TMCardComponentCellLayoutDataProtocol.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "TMCardComponentMacro.h"

NS_ASSUME_NONNULL_BEGIN

#define TMCardComponentCellLayoutDataProtocolSyntheSizeAutoImplementation \
TMCardComponentProtocolSyntheSize(layout_coverShowHeight) \
TMCardComponentProtocolSyntheSize(layout_titleBoxViewHeight) \
TMCardComponentProtocolSyntheSize(layout_subTitleBoxViewHeight) \
TMCardComponentProtocolSyntheSize(layout_bottomViewHeight) \

/**cell的具体展示需要依赖的布局协议,仅表示布局，未包含具体要显示的数据
 @note 如果是属于卡片组件内部支持样式的卡片对应的数据结构则需要满足此协议
 */
@protocol TMCardComponentCellLayoutDataProtocol <NSObject>

/**
 展示时封面图视图显示的高度
 @note 显示的封面图视图宽度相对屏幕计算后始终是固定值不需要单独返回
*/
@property (nonatomic, assign)CGFloat layout_coverShowHeight;

/**
 图片样式卡片中，标题区域整体块视图的高度，包含上部8pt间距及实际标题显示的lbl高度
 @warning 当有标题显示时，此值赋值对应8pt+lbl显示最多两行文本适应的高度；当无标题显示时，若有逼标题显示，为保持视觉效果统一，此值需要赋值4(用于修正副标题上部的间距)，若无副标题显示则赋值为0
 */
@property (nonatomic, assign)CGFloat layout_titleBoxViewHeight;

/**
 图片样式卡片中，副标题区域整体块视图的高度，包含上部4pt间距及实际副标题显示的lbl高度
 @warning 当无逼标题显示时，此值应该赋0；当有逼标题显示时，此值应该赋固定值20
*/
@property (nonatomic, assign)CGFloat layout_subTitleBoxViewHeight;

/**
 对应显示在cell底部的内容域视图块的整体高度
 @note TMCardComponentCellBottomView 视图对象的显示高度
 @note  底部头像距离下方cell的空白视觉效果间距为22pt，这里调整cell底部空白区域高度为14，剩下的8pt用layout中的同列相邻cell的间距调整为8来达到相同的视觉效果，若中间需要用一些自定义的外部cell相关适配更加合理
 */
@property (nonatomic, assign)CGFloat layout_bottomViewHeight;

@end

NS_ASSUME_NONNULL_END
