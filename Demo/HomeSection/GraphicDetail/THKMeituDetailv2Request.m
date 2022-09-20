//
//  THKMeituDetailv2Request.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKMeituDetailv2Request.h"

@implementation THKMeituDetailv2Request

- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/dhs/meitu/detail/v2";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (NSDictionary *)parameters{
    return @{@"baseId":@(self.baseId)};
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKMeituDetailv2Response class];
}


@end
