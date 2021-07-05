//
//  TMCardComponentQaStyleCell.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/6/11.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentBaseAbstractCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 8.6 从旧分类样式中拆解出的新的问答的单独样式
 单独的提问及回答样式，卡片样式分两种效果，根据实际数据确定展示哪种及是否显示相关动画效果
 @note 卡片高度固定，当有回答文本展示时高度为234, 当无回答文本展示时高度为193
 @version 8.6 add
 */
@interface TMCardComponentQaStyleCell : TMCardComponentBaseAbstractCell

@end

NS_ASSUME_NONNULL_END
