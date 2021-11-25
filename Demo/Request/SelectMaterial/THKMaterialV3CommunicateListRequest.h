//
//  THKMaterialV3CommunicateListRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import "THKBaseRequest.h"
#import "THKMaterialCommunicateListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialV3CommunicateListRequest : THKBaseRequest
@property (nonatomic, assign) NSInteger categoryId; ///<品类id
@property (nonatomic, assign) NSInteger wholeCode; ///<标签全码
@property (nonatomic, assign) NSInteger page;
@end

@interface THKMaterialV3CommunicateListResponse : THKResponse
@property (nonatomic, strong) NSArray <THKMaterialCommunicateListModel *> *data;
@end

NS_ASSUME_NONNULL_END
