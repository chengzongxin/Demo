//
//  THKOnlineDesignSearchHouseRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignSearchHouseRequest.h"

@implementation THKOnlineDesignSearchHouseRequest

- (NSString *)requestDomain {
    return @"https://tumaxopenapi.to8to.com";
}

- (NSString *)requestUrl {
    return @"/app/v2/housetype/search";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (NSDictionary *)parameters{
    return @{@"city":@(self.city),
             @"wd":self.wd?:@"",
             @"page":@(self.page),
             @"perPage":@(self.perPage)
    };
}

- (THKParameterType)parameterType {
    return THKParameterTypeDefault;
}

- (Class)modelClass {
    return [THKOnlineDesignSearchHouseResponse class];
}

@end
