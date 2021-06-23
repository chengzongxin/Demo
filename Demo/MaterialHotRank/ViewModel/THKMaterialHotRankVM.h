//
//  THKMaterialHotRankVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"
#import "THKMaterialHotListRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialHotRankVM : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestCommand;

@property (nonatomic, strong, readonly, nullable) NSArray <THKMaterialHotListModel *> *data;

/// 头部标题
@property (nonatomic, strong, readonly) NSArray <NSArray *> *headerTitles;
/// 图标
@property (nonatomic, strong, readonly) NSArray <NSArray *> *icons;
/// 文本
@property (nonatomic, strong, readonly) NSArray <NSArray *> *titles;
/// 二级文本
@property (nonatomic, strong, readonly) NSArray <NSArray *> *subtitles;

@end

NS_ASSUME_NONNULL_END
