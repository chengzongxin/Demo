//
//  THKMaterialRecommendRankRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKMaterialRecommendRankRequest.h"

@implementation THKMaterialRecommendRankRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/tls/material/category/detail";
}

- (NSDictionary *)parameters {
    return @{@"mainCategoryId":@(self.mainCategoryId),
             @"subCategoryId":@(self.subCategoryId),
             @"needTopSubCategoryList":@(self.needTopSubCategoryList),
    };
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKMaterialRecommendRankResponse class];
}

@end
