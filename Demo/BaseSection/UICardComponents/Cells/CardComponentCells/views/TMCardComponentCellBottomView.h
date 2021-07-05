//
//  TMCardComponentCellBottomView.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMCardComponentCellDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief v8.10 UI样式调整。高度到上而下顺序应分布为 9 + 14 +13 = 36。9为头像距离上方文本串视图的间距，14为头像尺寸，13为头像距离底部间距。
 * @note 整体卡片上下间距外部列表里已调整为10pt
 *
 * @note == old ===============================================================================================================
 *
 * @note 若需要显示则高度应该为42, UI处上而下分布 12 + 16 + 14
 * @note 内部自下而上分的视图块区域分别底部12\内容块20，顶部间距根据实际高度自由适配即可
 * @note 按设计稿，若不需要显示则相关整体高度应赋值为0；若需要显示，当是图文样式且有标题但无副标题时高度应该为42-2=40 (标题距离此视图的间距为10)，其它显示的情况给42即可
 * @warning 底部头像距离下方cell的空白视觉效果间距为22pt，这里调整cell底部空白区域高度为14，剩下的8pt用layout中的同列相邻cell的间距调整为8来达到相同的视觉效果，若中间需要用一些自定义的外部cell相关适配更加合理
 */
@interface TMCardComponentCellBottomView : UIView

- (void)updateUI:(NSObject<TMCardComponentCellDataProtocol> * _Nullable)cellData;

@end

NS_ASSUME_NONNULL_END
