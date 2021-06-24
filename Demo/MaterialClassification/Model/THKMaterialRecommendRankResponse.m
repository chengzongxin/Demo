//
//  THKMaterialRecommendRankResponse.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKMaterialRecommendRankResponse.h"

@implementation THKMaterialRecommendRankResponse

@end

@implementation THKMaterialRecommendRankModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"subCategoryList":THKMaterialRecommendRankSubCategoryList.class,
        @"brandList":THKMaterialRecommendRankBrandList.class,
        @"goodsRankList":THKMaterialRecommendRankGoodsRankList.class,
    };
}

@end

@implementation THKMaterialRecommendRankSubCategoryList
@end


@implementation THKMaterialRecommendRankBrandList
@end


@implementation THKMaterialRecommendRankGoodsRankList
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"goodsList":THKMaterialRecommendRankGoodsRankListGoodsList.class
    };
}
@end


@implementation THKMaterialRecommendRankGoodsRankListGoodsList
@end
