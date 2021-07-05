//
//  TMCardComponentUIConfigDefine.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/10/29.
//  Copyright © 2020 binxun. All rights reserved.
//

#ifndef TMCardComponentUIConfigDefine_h
#define TMCardComponentUIConfigDefine_h

/// MARK: 用于定义一些卡片组件样式UI对应的高度、间距等常量宏，方便后期版本更新时，若不涉及布局结构调整仅修改一些小的间距时能直接修改此值的常量宏定义即可

/// 卡片整体cell的圆角半径值
#define TMCardUIConfigConst_cardCornerRadius  (4) //v9.2.1改成了4，以前是6

/// 卡片普通样式的封面图的圆角半径值
#define TMCardUIConfigConst_coverCornerRadius  (2)

/// 显示在封面图四个角的浮层小Icon视图的对应封面邻近边的安全边距
#define TMCardUIConfigConst_floatingIconSafeMargin  (12)

/// 普通样式里卡片中的子内容视图距离卡片左边或右边的安全边距
#define TMCardUIConfigConst_contentLeftRightMargin  10 //(12)

/// 普通样式在图片下方显示的第一个文本视图上方距离封面图底部的间距值
#define TMCardUIConfigConst_firstLabelTopMargin (9)//10

/// 普通样式在图片下方显示的第二个文本视图上方距离第一个文本视图底部的间距值
#define TMCardUIConfigConst_secondLabelTopMargin (8)

/// 普通样式下多数情况定义为副标题lable，仅支持一行显示的lbl高度
#define TMCardUIConfigConst_singleLineLabelHeight  (16)

/// 底部最下方的(非封面视图、非统一的底部视图外的)其它子视图距离底部的安全边距值
#define TMCardUIConfigConst_bottomMargin   10 //(12)


/// =========bottom box  view ========================================

/// 底部昵称视图整块视图的高度 | 内部承载内容的块视图，定义与底部的安全间距，其它视图y轴上中心与此内容承载容器视图中心平齐
#define TMCardUIConfigConst_bottomBoxViewShowHeight   (8 + 16 + 12)

/// 底部昵称整块视图中，真正承载显示内容的块视图高度
#define TMCardUIConfigConst_bottomBoxViewContentContainerHeight   (20)

/// 底部昵称整块视图中，真正承载显示内容的块视图距离底边的间距
#define TMCardUIConfigConst_bottomBoxViewInnerBottomMargin   (10)

/// 底部昵称整块视图中，真正承载显示内容的块视图中头像视图的尺寸，宽高相等，y轴居中显示
#define TMCardUIConfigConst_bottomBoxViewInnerAvatarSize   (16)

/// 当普通样式卡片下显示只有封面图和底部视图时，可能需要将底部视图高度增加以下值以修正底部视图的整体高度，按最新设计稿上方间距为10，下方间距为12。
#define TMCardUIConfigConst_bottomBoxViewShowHeightFixTopMarginPlus   (2)


#endif /* TMCardComponentUIConfigDefine_h */
