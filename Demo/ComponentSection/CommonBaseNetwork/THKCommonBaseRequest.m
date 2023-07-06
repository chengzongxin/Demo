//
//  THKCommonBaseRequest.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2023/5/18.
//  Copyright © 2023 binxun. All rights reserved.
//

#import "THKCommonBaseRequest.h"
#import "THKCommonResponse.h"

@implementation THKCommonBaseRequest

- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
//   一般url： /user/superPK/list
    NSString *clsStr = NSStringFromClass(self.class);
    clsStr = [clsStr stringByReplacingOccurrencesOfString:@"THK" withString:@""];
    clsStr = [clsStr stringByReplacingOccurrencesOfString:@"Request" withString:@""];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z]{1}"
                                                                           options:0
                                                                             error:&error];
    if (error){
        NSLog(@"Error %@", [error description]);
    }
    NSArray *payloadRanges = [regex matchesInString:clsStr options:0 range:NSMakeRange(0, [clsStr length])];
    NSMutableString *urlString = [[clsStr lowercaseString] mutableCopy];
    NSInteger slashCount = 0;
    for (NSTextCheckingResult *result in payloadRanges) {
        [urlString insertString:@"/" atIndex:result.range.location + slashCount];
        slashCount++;
    }

    return urlString;
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (NSDictionary *)parameters {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [self tmui_enumratePropertiesUsingBlock:^(objc_property_t  _Nonnull property, NSString * _Nonnull propertyName) {
        NSString *propertyValue = [self valueForKey:(NSString *)propertyName];
        if ([propertyValue isKindOfClass:NSString.class]) {
            [para setObject:propertyValue forKey:propertyName];
        }else if ([propertyValue isKindOfClass:NSArray.class]) {
            NSArray *values = (NSArray *)propertyValue;
            NSMutableArray *arrayDict = [NSMutableArray array];
            [values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrayDict addObject:[obj mj_keyValues]];
            }];
            [para setObject:arrayDict forKey:propertyName];
        } else if ([propertyValue isKindOfClass:NSNumber.class]){
            [para setObject:propertyValue forKey:propertyName];
        }
    }];
    return para;
}


- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    NSString *clsStr = NSStringFromClass(self.class);
    NSString *resClsStr = [clsStr stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
    Class resCls = NSClassFromString(resClsStr);
    return [resCls class] ?: [THKCommonResponse class];
}

@end
