//
//  THKOnlineDesignHomeEditRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/17.
//

#import "THKOnlineDesignHomeEditRequest.h"

@implementation THKOnlineDesignHomeEditRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/tls/home/edit";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKOnlineDesignHomeEditResponse class];
}

@end
