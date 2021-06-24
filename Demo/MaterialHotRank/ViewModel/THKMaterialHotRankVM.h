//
//  THKMaterialHotRankVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKStateMechanismsViewModel.h"
#import "THKMaterialHotListRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialHotRankVM : THKStateMechanismsViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestCommand;

@property (nonatomic, strong, readonly, nullable) NSArray <THKMaterialHotListModel *> *data;

@end

NS_ASSUME_NONNULL_END
