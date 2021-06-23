//
//  THKMaterialHotListRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKMaterialHotListRequest.h"
#import "THKMaterialHotListResponse.h"

@implementation THKMaterialHotListRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/tls/material/hot/list";
}

- (NSDictionary *)parameters {
    return @{@"page":@(self.page?:1),
             @"size":@(self.size?:10)
    };
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKMaterialHotListResponse class];
}

@end
