//
//  TObject+TNSCodingHelp.h
//  TBasicLib
//
//  Created by to on 14-12-4.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "TObject.h"

typedef enum{
    TCodingPathDocument  = 0,//Document目录，不会清掉缓存
    TCodingPathCach          = 1
}TCodingPath;

@interface TObject (TNSCodingHelp)

/**
 *  将模型的二进制数据写入Document目录
 *
 *  @param key 通过key来查找模型
 */
- (void)writeObjectForKey:(NSString *)key;

/**
 *  将模型的二进制数据写入指定路径
 *
 *  @param key  通过key来查找模型
 *  @param path 路径类型
 */
- (void)writeObjectForKey:(NSString *)key path:(TCodingPath)path;

/**
 *  读取模型，注意要用读取的模型类调用
 *
 *  @param key 通过key来查找模型
 *
 *  @return 返回该模型实例
 */
+ (id)getObjctForKey:(NSString *)key;

/**
 *  读取模型，注意要用读取的模型类调用
 *
 *  @param key  通过key来查找模型
 *  @param path 路径类型
 *
 *  @return 返回该模型实例
 */
+ (id)getObjctForKey:(NSString *)key path:(TCodingPath)path;

/**
 *  删除归档模型
 *
 *  @param key 通过key来删除归档的模型，默认删除Document目录
 */
+ (void)removeCodingForKey:(NSString *)key;

/**
 *  删除归档模型
 *
 *  @param key  通过key来删除归档的模型
 *  @param path 路径类型
 */
+ (void)removeCodingForKey:(NSString *)key path:(TCodingPath)path;

@end
