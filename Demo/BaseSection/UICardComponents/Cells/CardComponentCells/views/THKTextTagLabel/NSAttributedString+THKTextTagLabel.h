//
//  NSAttributedString+THKTextTagLabel.h
//  Example
//
//  Created by nigel.ning on 2020/11/12.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSAttributedString THKTextTagLabelAttributedString;

/**
 配合THKTextTagLabel用
 */
@interface NSAttributedString (THKTextTagLabelAttributedString)

#pragma mark - 需要绘制指定背景色视图的相关数据

/// 需要绘制特殊背景样式效果的子串在文本串中的区域range
@property (nonatomic, assign)NSRange thk_drawBackgroundRange;

/// 需要绘制特殊背景样式效果的背景颜色
@property(nonatomic, strong)UIColor *thk_drawBackgroundColor;

/// 需要单独绘制的标签文本串颜色
@property(nonatomic, strong)UIColor *thk_drawRangeTextColor;

/// 需要绘制特殊背景样式的区域的圆角半径,默认为2.
@property (nonatomic, assign)CGFloat thk_drawBackgroundCornerRadius;

@end

NS_ASSUME_NONNULL_END
