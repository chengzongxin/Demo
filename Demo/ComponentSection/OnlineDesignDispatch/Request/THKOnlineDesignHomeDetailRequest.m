//
//  THKOnlineDesignHomeDetailRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/17.
//

#import "THKOnlineDesignHomeDetailRequest.h"

@implementation THKOnlineDesignHomeDetailRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/home/plan/detail";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKOnlineDesignHomeDetailResponse class];
}

@end
