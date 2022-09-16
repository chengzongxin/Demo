//
//  THKhomeSendCardRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/16.
//

#import "THKhomeSendCardRequest.h"

@implementation THKhomeSendCardRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/home/send/card";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKResponse class];
}

@end
