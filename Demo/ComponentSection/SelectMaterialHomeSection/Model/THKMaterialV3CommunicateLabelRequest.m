//
//  THKMaterialV3CommunicateLabelRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import "THKMaterialV3CommunicateLabelRequest.h"

@implementation THKMaterialV3CommunicateLabelRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/materialV3/communicate/label";
}

- (NSDictionary *)parameters {
    return @{@"categoryId":@(self.categoryId)
    };
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKMaterialV3CommunicateLabelResponse class];
}
@end

@implementation THKMaterialV3CommunicateLabelResponse

@end
