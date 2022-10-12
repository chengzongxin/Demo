//
//  THKCalcConfigRequest.m
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKCalcConfigRequest.h"

@implementation THKCalcConfigRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/calc/config";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKCalcConfigResponse class];
}

@end
