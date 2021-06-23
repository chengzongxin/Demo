//
//  THKResponse.m
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/4/30.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKResponse.h"
#import <MJExtension/MJExtension.h>

@implementation THKResponse

+ (instancetype)toModelWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [self mj_objectWithKeyValues:dictionary];
}

- (NSDictionary *)toDictionary {
    return self.mj_keyValues;
}

// 归解档宏
MJExtensionCodingImplementation

@end

@implementation THKResponse(NSError)

+ (instancetype)responseWithNetError:(NSError *)error {
    __kindof THKResponse *resp = [[self alloc] init];
    resp.errorCode = error ? error.code : -1;
    resp.status = THKStatusFailure;
    resp.errorMsg = @"网络出问题了，请检查网络连接";
    return resp;
}

@end
