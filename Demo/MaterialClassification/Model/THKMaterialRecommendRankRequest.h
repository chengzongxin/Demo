//
//  THKMaterialRecommendRankRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKBaseRequest.h"
#import "THKMaterialRecommendRankResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialRecommendRankRequest : THKBaseRequest
// 子分类编号 主页进来不传 全部分类页点击子分类传
@property (nonatomic, assign) NSInteger subCategoryId;
// 是否需要顶部子分类列表 首次进入时传1-需要 其他传0-不需要
@property (nonatomic, assign) NSInteger needTopSubCategoryList;

@end

NS_ASSUME_NONNULL_END
