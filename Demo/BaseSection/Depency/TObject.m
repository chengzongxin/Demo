//
//  TObject.m
//  TBasicLib
//
//  Created by kevin.huang on 14-6-9.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "TObject.h"

@interface TObject ()

@end

@implementation TObject

#pragma mark - NSCoding ---
/// NSCoding协议直接用MJExtension的相关实现宏即可
MJExtensionCodingImplementation;

#pragma mark - NSCopying ---

- (id)copyWithZone:(NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithDic:self.dicData];
}

#pragma mark - init
// 将数据映射到属性
- (instancetype)initWithDic:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        [self mj_setKeyValues:dict];
    }
    return self;
}

- (instancetype)mj_setKeyValues:(NSDictionary *)keyValues {
    [super mj_setKeyValues:keyValues];
    
    //在mj数据转模型的基础上，针对那些定义的属性名 与 数据中的key 有偏差的情况(仅针对名字相同，但属性多一个下划线的情况，兼容一下相关赋值处理)
    //用以存储需要修正二次赋值对应的新的属性名相同的新key及对应的值value字典，不影响super的赋值逻辑，仅重新对需要二次赋值的数据属性再次尝试mj_setKeyValues即可
    NSMutableDictionary<NSString *, id> *fixDatasDic = [NSMutableDictionary dictionary];
    NSDictionary *mj_replacedKeyFromPropertyName = nil;
    if ([self.class respondsToSelector:@selector(mj_replacedKeyFromPropertyName)]) {
        mj_replacedKeyFromPropertyName = [self.class mj_replacedKeyFromPropertyName];
    }
    [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        NSString *propertyName = property.name;
        if ([propertyName hasPrefix:@"_"] &&
            ![propertyName hasPrefix:@"__"] &&
            propertyName.length > 1) {
            //若mj_replacedKeyFromPropertyName 已经自已写了映射关系，则这里需要过滤掉不再二次手动处理
            if (mj_replacedKeyFromPropertyName[propertyName]) {return;}
            
            //仅处理以一个下划线打头的属性，进行可能的数据二次修正赋值逻辑(若子类忘记写idKey:dataKey的映射关系)，则需要手动处理赋值
            NSString *dataKey = [propertyName substringFromIndex:1];
            id dataValue = keyValues[dataKey];
            if (dataValue) {
                fixDatasDic[propertyName] = dataValue;
            }
        }
    }];
    
    if (fixDatasDic.count > 0) {
#if DEBUG
        [fixDatasDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *formatStr = [NSString stringWithFormat:@"<%@>- try setValue:%@, forFormatPropertyKey:%@, dataKey:%@", self.class, obj, key, [key substringFromIndex:1]];
            printf("%s\n", [formatStr UTF8String]);
        }];
#endif
        [super mj_setKeyValues:fixDatasDic];
    }
    
    return self;
}

// 将属性名和对应的值组成字典返回
- (NSDictionary *)dicData {
    return self.mj_keyValues;
}

- (BOOL)isEqual:(TObject *)model {
    if (self == model) return YES;
    if (![model isMemberOfClass:self.class]) return NO;
    
    __block BOOL valuesEqual = YES;
    [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        id selfValue = [self valueForKey:property.name];
        id otherValue = [model valueForKey:property.name];
        valuesEqual = ((selfValue == nil && otherValue == nil) || [selfValue isEqual:otherValue]);
        if (!valuesEqual) {
            *stop = YES;
        }
    }];
    return valuesEqual;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
#if DEBUG
    NSString *formatStr = [NSString stringWithFormat:@"<%@>- setValue:%@, forUndefinedKey:%@", self.class, value, key];
    printf("%s\n", [formatStr UTF8String]);
#endif
}

- (nullable id)valueForUndefinedKey:(NSString *)key {
#if DEBUG
    NSString *formatStr = [NSString stringWithFormat:@"<%@>- try valueForUndefinedKey:%@, may be a optional property in some protocol but do not have the property declaration.", self.class, key];
    printf("%s\n", [formatStr UTF8String]);
#endif
    
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, self.dicData];
}

@end
