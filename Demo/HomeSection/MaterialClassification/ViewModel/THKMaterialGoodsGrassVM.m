//
//  THKMaterialGoodsGrassVM.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/6/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKMaterialGoodsGrassVM.h"

@implementation THKMaterialGoodsGrassVM

- (THKBaseRequest *)requestWithInput:(id)input{
    THKMaterialRecommendGoodsGrassRequest *request = [[THKMaterialRecommendGoodsGrassRequest alloc] init];
    request.page = [input integerValue];
    request.subCategoryId = self.subCategoryId;
    return request;
}

@end
