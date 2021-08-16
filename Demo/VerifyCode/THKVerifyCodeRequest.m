//
//  THKVerifyCodeRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKVerifyCodeRequest.h"

@implementation THKVerifyCodeRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/user/verify/code/send";
}

- (NSDictionary *)parameters {
    return @{@"source":@(self.source),
             @"imgUuid":self.imgUuid?:@"",
             @"imgCode":self.imgCode?:@"",
             @"phone":self.phone?:@"",
             @"phoneId":self.phoneId?:@"",
             @"ip":self.ip?:@"",
             @"platform":self.platform?:@"1",
    };
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKVerifyCodeResponse class];
}
@end

@implementation THKVerifyCodeResponse

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":[THKVerifyCodeModel class]};
}

@end

@implementation THKVerifyCodeModel

@end
