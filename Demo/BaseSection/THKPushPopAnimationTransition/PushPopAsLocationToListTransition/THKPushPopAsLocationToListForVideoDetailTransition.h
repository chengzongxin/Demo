//
//  THKPushPopAsLocationToListForVideoDetailTransition.h
//  HouseKeeper
//
//  Created by nigel.ning on 2021/1/20.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKPushPopAsLocationToListTransition.h"
//#import "THKVideoDetailSinglePlayerView.h"

NS_ASSUME_NONNULL_BEGIN

/// 8.15 add 专用于列表页到视频详情页的转场，因视频详情页pop自定义转场返回时，由于视频播放器视图的尺寸与实际渲染的画面的尺寸不完全一致，当动画转场回到列表对应位置时，相关效果需要特殊处理，所以额外继承一个转场动画逻辑单独处理视频详情页的相关返回动画交互
/// 相关push操作会保留父类已有的push效果；仅针对pop交互做特殊处理
@interface THKPushPopAsLocationToListForVideoDetailTransition : THKPushPopAsLocationToListTransition

/// 1. 视频渲染位置需要依赖播放器视图进行相关判断取值;
/// 2. 因视图按原默认处理无法获取到相关截图，也需要视频详情页传递此对象来辅助获取当前的视频截图
//@property (nonatomic, copy, nullable)THKVideoDetailSinglePlayerView * (^getAliPlayerViewBlock)(void);

@end

NS_ASSUME_NONNULL_END
