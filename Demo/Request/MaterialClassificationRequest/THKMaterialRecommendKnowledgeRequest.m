//
//  THKMaterialRecommendKnowledgeRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKMaterialRecommendKnowledgeRequest.h"

@implementation THKMaterialRecommendKnowledgeRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/tls/material/knowledge/list";
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
    return [THKMaterialRecommendKnowledgeResponse class];
}

@end
