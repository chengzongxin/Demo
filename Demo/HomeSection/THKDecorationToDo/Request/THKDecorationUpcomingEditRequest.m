//
//  THKDecorationUpcomingEditRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/20.
//

#import "THKDecorationUpcomingEditRequest.h"

@implementation THKDecorationUpcomingEditRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/dhs/decoration/upcoming/list";
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (NSDictionary *)parameters{
    return @{@"childId":@(self.childId),
             @"todoStatus":self.todoStatus?:@"0"};
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKDecorationUpcomingEditResponse class];
}
@end
