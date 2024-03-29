//
//  THKDiaryProducer.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/10/26.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THKDiaryInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKDiaryProductFromType_Memory,
    THKDiaryProductFromType_Remote,
} THKDiaryProductFromType;

typedef enum : NSUInteger {
    THKDiaryProductIdType_diaryId,
    THKDiaryProductIdType_stageId,
    THKDiaryProductIdType_offsetId,
} THKDiaryProductIdType;

typedef struct {
    int left;
    int right;
} THKMapRange;

typedef void (^THKDiaryProductComplete)(NSArray *datas,THKDiaryProductFromType fromType,NSInteger offset);
typedef void (^THKDiaryProductFailure)(NSError *error);

@interface THKDiaryProducer : NSObject

@property (nonatomic, copy) NSArray <THKDiaryInfoModel *>*map;

@property (nonatomic, assign, readonly) NSInteger totalCount;

@property (nonatomic, assign) NSInteger diaryBookId;

// 上下滑动加载
- (void)scrollLoadData:(NSInteger)idx isDown:(BOOL)isDown complete:(THKDiaryProductComplete)complete failure:(THKDiaryProductFailure)failure;
// 初始化加载
- (void)loadDataWithOffsetId:(NSInteger)offsetId complete:(THKDiaryProductComplete)complete failure:(THKDiaryProductFailure)failure;
// 从日记加载
- (void)loadDataWithDiaryId:(NSInteger)diaryId complete:(THKDiaryProductComplete)complete failure:(THKDiaryProductFailure)failure;
// 从阶段加载
- (void)loadDataWithStageId:(NSInteger)stageId complete:(THKDiaryProductComplete)complete failure:(THKDiaryProductFailure)failure;

@end

NS_ASSUME_NONNULL_END
