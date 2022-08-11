//
//  THKDecorationToDoVM+Godeye.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2022/7/22.
//  Copyright © 2022 binxun. All rights reserved.
//

#import "THKDecorationToDoVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoVM (Godeye)

/// 装修阶段
- (void)stageCardShow:(UIView *)view
          widgetTitle:(NSString *)widgetTitle;

- (void)stageCardClick:(UIView *)view
           widgetTitle:(NSString *)widgetTitle;

/// 展开/折叠按钮
- (void)listUnfoldShow:(UIView *)view
           widgetTitle:(NSString *)widgetTitle
             widgetTag:(NSString *)widgetTag;

- (void)listUnfoldClick:(UIView *)view
            widgetTitle:(NSString *)widgetTitle
              widgetTag:(NSString *)widgetTag;

/// 已完成按钮
- (void)listCheckOffShow:(UIView *)view
             widgetTitle:(NSString *)widgetTitle
          widgetSubtitle:(NSString *)widgetSubtitle
               widgetTag:(NSString *)widgetTag;

- (void)listCheckOffClick:(UIView *)view
              widgetTitle:(NSString *)widgetTitle
           widgetSubtitle:(NSString *)widgetSubtitle
                widgetTag:(NSString *)widgetTag;

/// 装修攻略/工具
- (void)listLearnMoreShow:(UIView *)view
              widgetTitle:(NSString *)widgetTitle
           widgetSubtitle:(NSString *)widgetSubtitle
                widgetTag:(NSString *)widgetTag
              widgetIndex:(NSInteger)widgetIndex
              widgetValue:(NSString *)widgetValue
               widgetType:(NSString *)widgetType;

- (void)listLearnMoreClick:(UIView *)view
               widgetTitle:(NSString *)widgetTitle
            widgetSubtitle:(NSString *)widgetSubtitle
                 widgetTag:(NSString *)widgetTag
               widgetIndex:(NSInteger)widgetIndex
               widgetValue:(NSString *)widgetValue
                widgetType:(NSString *)widgetType;

@end

NS_ASSUME_NONNULL_END
