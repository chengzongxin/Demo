//
//  THKMaterialRecommendKnowledgeRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKBaseRequest.h"
#import "THKMaterialRecommendKnowledgeResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialRecommendKnowledgeRequest : THKBaseRequest

@property (nonatomic, assign) NSInteger subCategoryId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@end

NS_ASSUME_NONNULL_END
