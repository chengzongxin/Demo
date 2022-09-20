//
//  THKOnlineDesignHomeConfigRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/15.
//

#import "THKOnlineDesignHomeConfigRequest.h"

@implementation THKOnlineDesignHomeConfigRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/home/config";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKOnlineDesignHomeConfigResponse class];
}

@end
