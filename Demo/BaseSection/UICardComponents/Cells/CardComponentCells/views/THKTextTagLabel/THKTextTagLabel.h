//
//  THKTextTagLabel.h
//  Example
//
//  Created by nigel.ning on 2020/11/12.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+THKTextTagLabel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 卡片组件里使用 内部头部的文本标签用子Label显示
 @note 可以当正常UILable使用，也可以setAttributedText:时，参数传入THKTextTagLabelAttributedString对象显示自定义样式的富文本，即开头位置的子串或不换行的子串(注意：显示时不能处于换行区域的子串)显示时展示自定义的背景颜色样式(系统默认的方块矩形背景不能调整显示效果)（自定义的可指定圆角绘制形状等）
 @warning ⚠️ 富文本的thk_drawBackgroundRange.location必须为0，即必须是文本串的开头几个字符为标签串，否则无效
 */
@interface THKTextTagLabel : UILabel

@end

NS_ASSUME_NONNULL_END
