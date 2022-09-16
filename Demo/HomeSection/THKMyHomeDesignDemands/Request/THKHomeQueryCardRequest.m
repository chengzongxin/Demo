//
//  THKHomeQueryCardRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKHomeQueryCardRequest.h"

@implementation THKHomeQueryCardRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/home/query/card";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKHomeQueryCardResponse class];
}

@end
