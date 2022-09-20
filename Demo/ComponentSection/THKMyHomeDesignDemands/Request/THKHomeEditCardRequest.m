//
//  THKHomeEditCardRequest.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKHomeEditCardRequest.h"

@implementation THKHomeEditCardRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/tls/home/edit/card";
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
    return [THKHomeEditCardResponse class];
}


- (void)setStyleCode:(NSString *)code{
    [self setColumnListTag:@"styleTag" code:code];
}

- (void)setBudgetCode:(NSString *)code{
    [self setColumnListTag:@"budgetTag" code:code];
}

- (void)setColumnListTag:(NSString *)tag code:(NSString *)code{
    NSMutableArray <THKOnlineDesignHomeEditColumnList *> *columnList = [self.columnList mutableCopy];
    columnList = [[columnList tmui_filter:^BOOL(THKOnlineDesignHomeEditColumnList * _Nonnull item) {
        return ![item.columnType isEqualToString:tag];
    }] mutableCopy];
    
    THKOnlineDesignHomeEditColumnList *list = [THKOnlineDesignHomeEditColumnList new];
    list.columnType = tag;
    list.idList = @[code];
    if (columnList == nil) {
        columnList = [NSMutableArray array];
    }
    [columnList addObject:list];
    self.columnList = columnList;
}



@end
