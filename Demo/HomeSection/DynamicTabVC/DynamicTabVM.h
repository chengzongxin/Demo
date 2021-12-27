//
//  DynamicTabVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/17.
//

#import "THKViewModel.h"
#import "THKDynamicTabsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DynamicTabStyle_Single = 0,
    DynamicTabStyle_Suspend,
    DynamicTabStyle_Nested,
    DynamicTabStyle_Immersion
} DynamicTabStyle;

@interface DynamicTabVM : THKViewModel

// 头部Tab的内容，这个值从后台接口获取，如果获取失败或为空，则默认显示推荐Tab
@property (nonatomic, strong, readonly) NSArray<THKDynamicTabsModel *> *segmentTitles;

@property (nonatomic, assign) DynamicTabStyle isSuspend;
@property (nonatomic, assign) CGFloat headerHeight;

@end

NS_ASSUME_NONNULL_END
