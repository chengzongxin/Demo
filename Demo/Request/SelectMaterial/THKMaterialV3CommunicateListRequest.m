//
//  THKMaterialV3CommunicateListRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import "THKMaterialV3CommunicateListRequest.h"

@implementation THKMaterialV3CommunicateListRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/tls/materialV3/communicate/list";
}

- (NSDictionary *)parameters {
    NSMutableDictionary *para = [
        @{@"categoryId":@(self.categoryId),
          @"page":@(self.page),
    } mutableCopy];
    if (self.wholeCode) {
        para[@"wholeCode"] = @(self.wholeCode);
    }
    return para;
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKMaterialV3CommunicateListResponse class];
}
@end

@implementation THKMaterialV3CommunicateListResponse
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":THKMaterialCommunicateListModel.class};
}
@end
