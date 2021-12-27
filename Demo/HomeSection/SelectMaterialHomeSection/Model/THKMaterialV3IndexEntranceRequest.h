//
//  THKMaterialV3IndexEntranceRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import "THKBaseRequest.h"
#import "THKMaterialTabEntranceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialV3IndexEntranceRequest : THKBaseRequest
@property (nonatomic, assign) NSInteger categoryId; ///<品类id
@end

@interface THKMaterialV3IndexEntranceResponse: THKResponse

@property (nonatomic, strong) THKMaterialTabEntranceModel *data;

@end

NS_ASSUME_NONNULL_END
