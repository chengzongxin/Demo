//
//  THKImageTabSegmentControl.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/10/30.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKSegmentControl.h"
#import "THKDynamicTabsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKImageTabSegmentButton : UIButton

@property (nonatomic, strong, readonly)     UIImageView *iconImageView;
@property (nonatomic, strong, readonly)     UILabel *textLabel;
@property (nonatomic, strong, readonly)     UIImageView *badgeIconView;
@property (nonatomic, strong, readonly)     THKDynamicTabsModel *tabModel;

@property (nonatomic, assign) BOOL exposed;//是否已曝光

- (void)setButtonModel:(THKDynamicTabsModel *)model textWidth:(CGFloat)textWidth;

@end

@interface THKImageTabSegmentControl : THKSegmentControl

- (void)showButtonBadgeWithModel:(THKDynamicTabsModel *)model;

/**
 动态变化tab内容
 */
- (void)reloadSegmentWithTitles:(NSArray<THKDynamicTabsModel *> *)segmentTitles animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
