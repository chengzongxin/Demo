//
//  TIMCompanyPKRoomDetailRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/22.
//

#import "TIMCompanyPKRoomDetailRequest.h"

@implementation TIMCompanyPKRoomDetailRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/companyPK/room/detail";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [TIMCompanyPKRoomDetailResponse class];
}

@end

@implementation TIMCompanyPKRoomDetailResponse


@end
