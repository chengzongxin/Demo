//
//  THKOnlineDesignSearchAreaRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignSearchAreaRequest.h"

@implementation THKOnlineDesignSearchAreaRequest

- (NSString *)requestDomain {
    return @"https://tumaxopenapi.to8to.com";
}

- (NSString *)requestUrl {
    return @"/app/v2/housetype/community";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (NSDictionary *)parameters{
    return @{@"city":@(self.city),
             @"wd":self.wd?:@"",
    };
}

- (THKParameterType)parameterType {
    return THKParameterTypeDefault;
}

- (Class)modelClass {
    return [THKOnlineDesignSearchAreaResponse class];
}


@end
