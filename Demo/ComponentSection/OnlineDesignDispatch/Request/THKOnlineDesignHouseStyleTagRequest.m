//
//  THKOnlineDesignHouseStyleTagRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/17.
//

#import "THKOnlineDesignHouseStyleTagRequest.h"

@implementation THKOnlineDesignHouseStyleTagRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/home/house/config";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKOnlineDesignHouseStyleTagResponse class];
}

@end
