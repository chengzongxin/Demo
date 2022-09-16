//
//  THKMaterialV3IndexEntranceRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import "THKMaterialV3IndexEntranceRequest.h"

@implementation THKMaterialV3IndexEntranceRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/materialV3/index/entrance";
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
    return [THKMaterialV3IndexEntranceResponse class];
}
@end

@implementation THKMaterialV3IndexEntranceResponse

@end

