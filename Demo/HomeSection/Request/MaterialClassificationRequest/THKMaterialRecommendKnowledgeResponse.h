//
//  THKMaterialRecommendKnowledgeResponse.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKResponse.h"
#import "TMCardComponentCellDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialRecommendKnowledgeResponse : THKResponse
@property (nonatomic, strong) NSArray <TMCardComponentCellDataModel *> *data;
@end

NS_ASSUME_NONNULL_END
