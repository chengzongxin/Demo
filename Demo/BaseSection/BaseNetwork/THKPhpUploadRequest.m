//
//  THKPhpUploadRequest.m
//  HouseKeeper
//
//  Created by nigel.ning on 2019/11/28.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKPhpUploadRequest.h"

@implementation THKPhpUploadRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.customModelClass = THKCommonResponse.class;
    }
    return self;
}

- (NSString *)requestUrl {
    NSAssert(self.uploadUrl.length > 0, @"uploadUrl can not be nil or empty string");
    
    return self.uploadUrl;
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKRequestType)requestType {
    return THKRequestTypeHTTP;
}

- (NSDictionary *)parameters {
    return self.customParams ?: @{};
}

- (Class)modelClass {
    return self.customModelClass ?: THKCommonResponse.class;
}

@end
