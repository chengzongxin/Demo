//
//  THKHouseCardConfigRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKHouseCardConfigRequest.h"

@implementation THKHouseCardConfigRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/house/card/config";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKHouseCardConfigResponse class];
}

@end
