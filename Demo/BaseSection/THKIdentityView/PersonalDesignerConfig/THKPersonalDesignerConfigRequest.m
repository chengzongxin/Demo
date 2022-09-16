//
//  THKPersonalDesignerConfigRequest.m
//  HouseKeeper
//
//  Created by cl w on 2021/2/4.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKPersonalDesignerConfigRequest.h"

@implementation THKPersonalDesignerConfigRequest

//- (NSString *)requestDomain {
//    return kJavaServerC1Domain;
//}
+(NSString*)thk_requestPath{
    return @"/gw/app/startUpConfig";
}
- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@%@%@",kJavaServerDomain,kJavaServerPath,@"/gw/app/startUpConfig"];
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (THKRequestType)requestType {
    return THKRequestTypeJSON;
}

- (NSDictionary *)parameters
{
    return @{@"accessType" : @(_accessType)};
}

- (Class)modelClass {
    return [THKPersonalDesignerConfigResponse class];
}

@end
