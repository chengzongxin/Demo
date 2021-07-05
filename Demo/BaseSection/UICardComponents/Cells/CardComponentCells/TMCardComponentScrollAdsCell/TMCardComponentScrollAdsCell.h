//
//  TMCardComponentScrollAdsCell.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/10/30.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMCardComponentCellProtocol.h"
#import "TMCardComponentCellDataProtocol.h"

@class THKHomeFlowListModel;
NS_ASSUME_NONNULL_BEGIN
/**
 8.10 首页发版，瀑布流列表首位置可能会显示的可多张广告视图横向滑动的广告位样式cell. 由TAD广告配置系统下方相关数据
 @note 此样式对应的数据暂不会在瀑布流接口中返回，面是TAD相关接口返回的数据自行组装的对象，所以对应style应为custom，且需要自行处理相关埋点
 @warning 因此cell内部可滚动，相关埋点比较特殊，暂相关Page_uid写死为首页page_uid
 */
@interface TMCardComponentScrollAdsCell : UICollectionViewCell<TMCardComponentCellProtocol>

#pragma mark - TMCardComponentCellProtocol  通用的数据刷新UI方法
/**
 用指定的data数据更新相关UI
 */
- (void)updateUIElement:(THKHomeFlowListModel /*NSObject<TMCardComponentCellDataProtocol>*/ *)data;

@end

NS_ASSUME_NONNULL_END
