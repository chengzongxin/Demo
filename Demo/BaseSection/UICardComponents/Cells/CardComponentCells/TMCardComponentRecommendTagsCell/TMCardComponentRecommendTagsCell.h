//
//  TMCardComponentRecommendTagsCell.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/8/19.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentRecommendTagsBaseUICell.h"
#import "TMCardComponentCellProtocol.h"
#import "TMCardComponentCellDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/**
 8.9 版本调整，搜索标签样式卡片定义为卡片组件样式，对应style=11，且瀑布流列表默认有相关标签子项视图的点击跳转处理
 @note 但当前瀑布流相关接口并不会返回此类型数据，仅用在首页信息流、视频推荐列表、搜索综合列表中，单独的相关接口获取此类型数据并按相关规则插入到指定位置进行显示，因相关埋点各个地方仍旧为手动指定，所以当前此cell样式的使用仍可当作custom类型进行处理，外部可选择分别继承后做一些针对性的处理逻辑，相关点击跳转也需要外部自行处理。但若按style=11的类型数据插入到相关列表数据源则会按默认8.9增加的相关逻辑处理，能正常展示且点击能简单的按钮路由跳转，但埋点相关若接口无返回则不会处理，后续若可由接口按既定协议从report字段返回埋点数据则可跟其它卡片类型的相关埋点处理逻辑保持一致。
 */
@interface TMCardComponentRecommendTagsCell : TMCardComponentRecommendTagsBaseUICell<TMCardComponentCellProtocol>

#pragma mark - TMCardComponentCellProtocol  通用的数据刷新UI方法
/**
 用指定的data数据更新相关UI
 */
- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data;

@end

NS_ASSUME_NONNULL_END
