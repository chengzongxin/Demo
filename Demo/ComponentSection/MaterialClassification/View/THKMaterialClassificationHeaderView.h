//
//  THKMaterialClassificationView.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKView.h"
#import "THKMaterialRecommendRankResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialClassificationHeaderView : THKView

@property (nonatomic, copy) void (^tapItem)(NSInteger index);

@property (nonatomic, assign) NSInteger subCategoryId;
@property (nonatomic , strong) NSArray <THKMaterialRecommendRankSubCategoryList *>              * subCategoryList;

@end

NS_ASSUME_NONNULL_END
