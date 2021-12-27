//
//  THKSelectMaterialMainVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKViewModel.h"
#import "THKDynamicTabsModel.h"
#import "THKRequestCommand.h"
#import "THKMaterialV3IndexTopTabRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKSelectMaterialHomeVM : THKViewModel
// 头部Tab的内容，这个值从后台接口获取，如果获取失败或为空，则默认显示推荐Tab
@property (nonatomic, strong, readonly) NSArray<THKDynamicTabsModel *> *segmentTitles;

@property (nonatomic, strong, readonly) RACCommand *requestTab;


@end

NS_ASSUME_NONNULL_END
