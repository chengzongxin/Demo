//
//  THKHomeEditCardRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKHomeEditCardRequest.h"

@implementation THKHomeEditCardRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/tls/home/edit/card";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKHomeEditCardResponse class];
}

@end
