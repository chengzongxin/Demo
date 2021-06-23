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

@property (nonatomic, strong, readonly) RACSubject *emptySignal;

@property (nonatomic, strong, readonly) RACReplaySubject *loadingSignal;

@property (nonatomic, strong, readonly) RACReplaySubject *refreshSignal;
@property (nonatomic, strong, readonly, nullable) NSArray <THKMaterialHotListModel *> *data;


@end

NS_ASSUME_NONNULL_END
