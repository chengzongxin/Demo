//
//  THKDynamicTabsRequest.m
//  HouseKeeper
//
//  Created by amby.qin on 2020/7/10.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKDynamicTabsRequest.h"

@implementation THKDynamicTabsRequest

- (instancetype)init {
    if (self = [super init]) {
        //[[THKDynamicTabsRequestManager shareInstance] addRequest:self wholeCode:[self wholeCodeForThisRequest]];
    }
    return self;
}

- (NSString *)wholeCodeForThisRequest {
    return nil;
}

- (NSString *)requestDomain {
    if ([self.wholeCode isEqualToString:kDynamicTabsWholeCodeLocalDiaryChannel]) {
        return kJavaServerC2Domain;
    }
    return kJavaServerC1Domain;
}

- (NSString *)requestUrl {
    if ([self.wholeCode isEqualToString:kDynamicTabsWholeCodeHomePage]) {
        //9.5.0 UI交互及接口调整，首页获取标签配置项数据用 @"gw/opts/tags";
        //return @"/gw/opts/index/tags";//9.5.0之前用此url
        return @"gw/opts/tags";
    } else if ([self.wholeCode isEqualToString:kDynamicTabsWholeCodeLocalDiaryChannel]) {
        return @"gw/opts/tags";
    }
    return @"gw/opts/tags";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (NSDictionary *)parameters {
// 9.5.0 之前的逻辑，若是首页全码则会直接返回
//    if ([self.wholeCode isEqualToString:kDynamicTabsWholeCodeHomePage]) {
//        return @{};
//    }
    
    NSMutableDictionary *dict = @{@"wholeCode":self.wholeCode?:@""}.mutableCopy;
    if (self.extraParam) {
        [dict addEntriesFromDictionary:self.extraParam];
    }
    return dict.copy;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKDynamicTabsResponse class];
}

@end
