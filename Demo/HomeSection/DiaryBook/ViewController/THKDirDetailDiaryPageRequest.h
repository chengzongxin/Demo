//
//  THKDirDetailDiaryPageRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/10/27.
//

#import "THKBaseRequest.h"
#import "THKDiaryInfoModel.h"
#import "THKDiaryProducer.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDirDetailDiaryPageRequest : THKBaseRequest
@property (nonatomic, strong) NSString *snapshotId;          ///< 访问快照id，为空则由后端取最新快照进行返回
@property (nonatomic, assign) NSInteger diaryBookId;         ///<日记本id
@property (nonatomic, strong) NSString *diaryId;         ///< 子日记id，优先级高于firstStageId
@property (nonatomic, strong) NSString *firstStageId;            ///< 阶段id，优先级高于offset
@property (nonatomic, strong) NSString *offset;          ///< 当前子日记偏移量
@property (nonatomic, strong) NSArray *range;            ///< 固定传两个元素。定位数据前后范围，如：offset=10,range=[-10, 0],则往前加载十条，最终此次返回0~9（offset - range[0] ~ offset + range[1] - 1）的数据；diaryId AND firstStageId 的情况一样，找到对应子日记id的offset后进行相应计算

//@property (nonatomic, assign) THKDiaryProductIdType idType;


@end


@interface THKDirDetailDiaryPageResponseData : NSObject
@property (nonatomic, strong) NSString *snapshotId;//访问快照id，用于后续列表刷新时访问同一快照的数据
@property (nonatomic, assign) NSInteger total;// 列表总数
@property (nonatomic, strong) NSArray <THKDiaryInfoModel *>*diaryInfos;// 返回数据集合
@property (nonatomic, assign) BOOL beContinued;//是否待续 | 请求到最后一页的时候再返回
@property (nonatomic, strong) NSString *urgeText;//催更文案 | 请求到最后一页的时候再返回
@end

@interface THKDirDetailDiaryPageResponse : THKResponse

@property (nonatomic, strong) THKDirDetailDiaryPageResponseData *data;

@end

NS_ASSUME_NONNULL_END
