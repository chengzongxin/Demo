//
//  THKOnlineDesignHomeEditRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/17.
//

#import "THKOnlineDesignHomeEditRequest.h"

@implementation THKOnlineDesignHomeEditPlanImgList

@end

@implementation THKOnlineDesignHomeEditRecordingInfoList

@end

@implementation THKOnlineDesignHomeEditRequest
- (NSString *)requestDomain {
    return kJavaServerC2Domain;
}

- (NSString *)requestUrl {
    return @"/tls/home/edit";
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
            [para setObject:[NSNumber numberWithInt:propertyValue.intValue] forKey:propertyName];
        }
    }];
    return para;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}

- (Class)modelClass {
    return [THKOnlineDesignHomeEditResponse class];
}

@end
