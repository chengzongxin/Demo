//
//  THKCommonRequest.m
//  HouseKeeper
//
//  Created by nigel.ning on 2019/11/27.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKCommonRequest.h"

@implementation THKCommonRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.common_isAddCommonParameter = YES;
        self.common_needLoginAuthentication = YES;
        self.common_modelClass = THKCommonResponse.class;
    }
    return self;
}

- (NSString *)requestUrl {
    return self.common_requestUrl;
}

- (THKHttpMethod)httpMethod {
    return self.common_httpMethod;
}

- (THKRequestType)requestType {
    return self.common_requestType;
}

- (THKParameterType)parameterType {
    return self.common_parameterType;
}

- (NSDictionary *)parameters {
    return self.common_parameters;
}

- (Class)modelClass {
    return self.common_modelClass ?: THKCommonResponse.class;
}

- (BOOL)isAddCommonParameter {
    return self.common_isAddCommonParameter;
}

- (BOOL)needLoginAuthentication {
    return self.common_needLoginAuthentication;
}

@end
