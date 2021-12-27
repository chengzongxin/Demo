//
//  THKCompanyDetailTabRequest.m
//  HouseKeeper
//
//  Created by amby.qin on 2020/11/16.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKCompanyDetailTabRequest.h"

@implementation THKCompanyDetailTabRequest

- (NSString *)wholeCodeForThisRequest {
    return kDynamicTabsWholeCodeCompanyDetail;
}

- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/dcs/tabs";
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


@end
