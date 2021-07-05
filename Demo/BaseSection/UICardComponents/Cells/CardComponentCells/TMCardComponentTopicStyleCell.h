//
//  TMCardComponentTopicStyleCell.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/6/11.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentBaseAbstractCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @note v8.10 话题样式重新调整-封面铺满，标题最多两行 | 设计稿宽高：174x232，定义为卡片高度固定:232 重新调整UI，相关UI对应的数据取值逻辑在之前旧的取值逻辑基础上，增加头像列表的取值，取content.imgs数组做最近几个参与人头像视图的显示
 * @note old =================================================================
 * @note 8.6 从旧分类样式中拆解出的新的话题的单独样式
 * @note 单独的话题样式, 无新增加字段，话题Icon及话题文本复用原bottom的imageUrl和title, 话题名复用cover的title字段，参与话题的描述复用原subTitle字段
 * @note 话题名支持最多2行显示
 @ version 8.10 modify | 8.6 add
 */
@interface TMCardComponentTopicStyleCell : TMCardComponentBaseAbstractCell

@end

NS_ASSUME_NONNULL_END
