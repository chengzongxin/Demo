//
//  THKMaterialRecommendRankResponse.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKResponse.h"

NS_ASSUME_NONNULL_BEGIN
@class THKMaterialRecommendRankModel;
@class THKMaterialRecommendRankSubCategoryList;
@class THKMaterialRecommendRankBrandList;
@class THKMaterialRecommendRankGoodsRankList;
@class THKMaterialRecommendRankGoodsRankListGoodsList;

@interface THKMaterialRecommendRankResponse : THKResponse

@property (nonatomic, strong) THKMaterialRecommendRankModel *data;

@end

@interface THKMaterialRecommendRankModel :NSObject

@property (nonatomic , strong) NSArray <THKMaterialRecommendRankSubCategoryList *>              * subCategoryList;
@property (nonatomic , strong) THKMaterialRecommendRankSubCategoryList              * subCategory;
@property (nonatomic , strong) NSArray <THKMaterialRecommendRankBrandList *>              * brandList;
@property (nonatomic , strong) NSArray <THKMaterialRecommendRankGoodsRankList *>              * goodsRankList;

@end

@interface THKMaterialRecommendRankSubCategoryList :NSObject
@property (nonatomic , assign) CGFloat              categoryId;
@property (nonatomic , copy) NSString              * categoryName;
@property (nonatomic , copy) NSString              * cover;

@end


@interface THKMaterialRecommendRankBrandList :NSObject
@property (nonatomic , assign) CGFloat              brandId;
@property (nonatomic , copy) NSString              * brandName;
@property (nonatomic , copy) NSString              * logoUrl;
@property (nonatomic , copy) NSString              * score;
@property (nonatomic , assign) CGFloat              uid;

@end

@interface THKMaterialRecommendRankGoodsRankList :NSObject
@property (nonatomic , assign) CGFloat              listId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , strong) NSArray <THKMaterialRecommendRankGoodsRankListGoodsList *>              * goodsList;

@end

@interface THKMaterialRecommendRankGoodsRankListGoodsList :NSObject
@property (nonatomic , assign) CGFloat              goodsId;
@property (nonatomic , copy) NSString              * model;
@property (nonatomic , copy) NSString              * features;
@property (nonatomic , copy) NSString              * recommendedReason;
@property (nonatomic , copy) NSString              * cover;
// 传入下一层
@property (nonatomic , assign) CGFloat              listId;
@property (nonatomic , copy) NSString              * name;

@end


NS_ASSUME_NONNULL_END
