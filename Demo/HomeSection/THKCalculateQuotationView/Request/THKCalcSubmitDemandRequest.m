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


- (NSDictionary *)parameters{
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
        } else if (propertyValue){
            [para setObject:propertyValue forKey:propertyName];
        }
    }];
    return para;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKCalcSubmitDemandResponse class];
}


@end
