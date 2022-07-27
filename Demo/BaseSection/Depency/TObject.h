//
//  TObject.h
//  TBasicLib
//
//  Created by kevin.huang on 14-6-9.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

/**
 app 8.9  将原TObject从其它集成子库中单独拆分出来，且为了尽可能少的影响已有代码的相关初始化、相关api调用等逻辑，保留原相关初始化方法和模型转字典的接口的定义，但调整内部相关实现逻辑，尝试将原MTL及自行解析的相关处理逻辑替换为MJExtension 相关的kv赋值属性的处理。
 @note 内部实现了NSCopying\NSCoding协议, NSCoding直播使用MJExtension相关实现宏
 @note 内部重现了 setValue:forUndefinedKey: 方法，碰到模型里定义的readonly属性且未手动synthesize或未重写相关set方法时，相关key-value信息会printf到控制台显示
 @note 对于一些属性与关键字冲突，导致定义为带下划线的情况，如 数据Key:id 定义为属性: _id， 类似的情况下此类在由数据字典转模型的逻辑中会重写mj_setKeyValues: 方法，对_xxx类似的属性变量进行一次兼容二次赋值处理(从数据字典中读取key为xxx的数据值，若有则赋值给_xxx属性)，但若相关属性名带有多个_开头则不会修正赋值(若属性名为__name，则【不会】从数据中按_nake为key取数据再对__name属性赋值)
 @note 内部对于一个服从某些协议protocol，而又定义的是非正式属性的optional的情况，当未声明可选属性时，mj_keyValues 方法仍然会从其中获取相关值，此时valueForKey: 会走到valueForUndefinedKey: 从而抛出异常而crash，所以此类内部重写valueForUndefinedKey:方法以防止一非非正式协议属性未声明造成的crash
 */
@interface TObject : NSObject<NSCopying, NSCoding>

/**
 app 8.9 调整内部相关实现，原自行解析及MTL映射的逻辑调整为 MJExtension 的相关kv赋值属性方法来做对象的初始化
 */
- (instancetype)initWithDic:(NSDictionary *)dict;

/**
 app 8.9 调整内部相关实现，原自行解析转换字典的逻辑调整为 MJExtension 的相关模型转字典方法实现
 */
- (NSDictionary *)dicData;

///MARK: 内部保留原TObject的相关逻辑，重写了isEqual函数，内部通过类的属性列表遍历，按key取值 判断对比的两者中的属性值是否全部一致，若有不一致的值则返回NO，否则返回YES

///MARK: 内部重写了description方法实现，会返回key-values组成的数据字典并format成字符串返回


@end
