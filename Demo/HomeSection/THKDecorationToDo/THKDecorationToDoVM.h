//
//  THKDecorationToDoVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKViewModel.h"
#import "THKStateMechanismsViewModel.h"
#import "THKDecorationToDoModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface THKDecorationToDoVM : THKStateMechanismsViewModel

@property (nonatomic, strong, readonly) NSString *subtitle;

@property (nonatomic, copy, readonly) NSArray <THKDecorationUpcomingModel *> *stageList;

@property (nonatomic, copy, readonly) NSArray <THKDecorationUpcomingListModel *> *upcomingList;

@property (nonatomic, strong ,readonly) RACSubject *emptySignal;

@property (nonatomic, strong, readonly) RACSubject *nodataSignal;

@property (nonatomic, strong, readonly) THKRequestCommand *editCommand;
//
//@property (nonatomic, strong, readonly) THKRequestCommand *listCommand;


- (void)saveUpcomingListCachWithMainId:(NSInteger)mainId isOpen:(BOOL)isOpen;

- (THKDecorationUpcomingListCacheModel *)readUpcomingListCachWithMainId:(NSInteger)mainId;



- (void)editModelRequest:(THKDecorationUpcomingChildListModel *)model success:(void (^)(void))success fail:(void (^)(void))fail;

@end

NS_ASSUME_NONNULL_END
