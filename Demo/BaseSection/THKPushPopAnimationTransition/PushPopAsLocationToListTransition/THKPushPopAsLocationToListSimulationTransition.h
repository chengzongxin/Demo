//
//  THKPushPopAsLocationToListSimulationTransition.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/8.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKPushPopAsLocationToListTransition.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 在父类功能基础上扩展实现一些转场动画的仿真细节处理，比如 从fromVc.view的某sourceView位置开始动画，负责动画的是另一个专用视图，但动画开始时原sourceView.alpha也会设置为0，在pop回去动画结束后，再重新将sourceView.alpha回置为1。让整体交互效果看起来更加逼真。
 */
@interface THKPushPopAsLocationToListSimulationTransition : THKPushPopAsLocationToListTransition

@end

NS_ASSUME_NONNULL_END
