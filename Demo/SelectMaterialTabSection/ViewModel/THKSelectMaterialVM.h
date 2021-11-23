//
//  THKSelectMaterialVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKViewModel.h"
#import "THKDynamicTabsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKSelectMaterialVM : THKViewModel
// 头部Tab的内容，这个值从后台接口获取，如果获取失败或为空，则默认显示推荐Tab
@property (nonatomic, strong, readonly) NSArray<THKDynamicTabsModel *> *segmentTitles;

@end

NS_ASSUME_NONNULL_END
