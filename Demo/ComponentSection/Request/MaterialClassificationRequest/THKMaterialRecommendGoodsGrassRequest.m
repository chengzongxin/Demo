//
//  THKMaterialRecommendGoodsGrassRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKMaterialRecommendGoodsGrassRequest.h"

@implementation THKMaterialRecommendGoodsGrassRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/material/goods/grass/list";
}

- (NSDictionary *)parameters {
    return @{@"page":@(self.page?:1),
             @"size":@(self.size?:20),
             @"subCategoryId":@(self.subCategoryId)
    };
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKMaterialRecommendGoodsGrassResponse class];
}

@end
