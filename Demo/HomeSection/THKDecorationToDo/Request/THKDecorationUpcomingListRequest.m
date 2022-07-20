//
//  THKDecorationUpcomingListRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/20.
//

#import "THKDecorationUpcomingListRequest.h"

@implementation THKDecorationUpcomingListRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/dhs/decoration/upcoming/list";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKDecorationUpcomingListResponse class];
}

@end
