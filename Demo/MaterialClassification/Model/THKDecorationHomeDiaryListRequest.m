//
//  THKDecorationHomeDiaryListRequest.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/5/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKDecorationHomeDiaryListRequest.h"

@implementation THKDecorationHomeDiaryListRequest

- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/diarybook/company/diary/list";
}

- (NSDictionary *)parameters {
    return @{@"page":@(self.page)};
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKDecorationHomeDiaryListResponse class];
}

@end
