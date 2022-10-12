//
//  THKCalcSubmitDemandRequest.m
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKCalcSubmitDemandRequest.h"

@implementation THKCalcSubmitDemandRequest

- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/calc/submitDemand";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKCalcSubmitDemandResponse class];
}


@end
