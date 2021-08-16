//
//  THKPicCaptchaRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKPicCaptchaRequest.h"

@implementation THKPicCaptchaRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/user/pic/captcha/info";
}

- (NSDictionary *)parameters {
    return @{@"type":@(self.type?:1)};
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKPicCaptchaResponse class];
}
@end

@implementation THKPicCaptchaResponse

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":[THKPicCaptchaModel class]};
}

@end


@implementation THKPicCaptchaModel

@end
