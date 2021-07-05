//
//  TMCardComponentNormalStyleCell.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentBaseAbstractCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 通用的图文内容样式, 图、标题、描述、底部头像、底部title 、底部点赞或其它、图片上可选指定显示内容标记icon
 @note 8.8 标题上方增加了推荐来源说明信息的显示，若显示则视图块整体高度占22，不显示则视图块整体高度为0，内部处理为加在标题视图上方
 */
@interface TMCardComponentNormalStyleCell : TMCardComponentBaseAbstractCell

@end

NS_ASSUME_NONNULL_END
