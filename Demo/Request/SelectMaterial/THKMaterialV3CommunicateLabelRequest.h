//
//  THKMaterialV3CommunicateLabelRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import "THKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialV3CommunicateLabelRequest : THKBaseRequest
@property (nonatomic, assign) NSInteger categoryId; ///<品类id
@end

@interface THKMaterialV3CommunicateLabelResponse : THKResponse

@end

NS_ASSUME_NONNULL_END
