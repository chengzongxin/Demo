//
//  THKMaterialV3IndexTopTabRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import "THKMaterialV3IndexTopTabRequest.h"

@implementation THKMaterialV3IndexTopTabRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/tls/materialV3/index/topTab";
}


- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKMaterialV3IndexTopTabResponse class];
}
@end

@implementation THKMaterialV3IndexTopTabResponse
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":THKDynamicTabsModel.class};
}
@end

@implementation MaterialV3IndexTopTabModel

@end

