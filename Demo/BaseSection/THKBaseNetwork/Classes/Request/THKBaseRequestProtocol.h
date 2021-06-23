//
//  THKBaseRequestProtocol.h
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/5/5.
//  Copyright © 2019 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// HTTP Method
typedef NS_ENUM(NSUInteger, THKHttpMethod) {
    THKHttpMethodGET,
    THKHttpMethodPOST,
};

// 接口参数结构
typedef NS_ENUM(NSUInteger, THKParameterType) {
    THKParameterTypeDefault,// 默认类型, 直接传递参数, 不做任何拼装, 如: '@{参数}' -->PHP接口使用此种结构
    THKParameterTypeArgs,// 参数使用args包裹一层, 如: '@{@"args":@{参数}}' -->部分Java接口使用此种结构
    THKParameterTypeArgsWithSubargs,// 参数使用args包裹一层, 然后再用子args包裹一层, 例如: '@{@"args":@{@"pri_args":@{参数}, @"pub_args":@{公参}}}' -->Java接口 老网关使用此种结构
    THKParameterTypeArgsWithUrl,// 公参在URL中拼接, 业务参数包裹在args中, 例如:@{@"args":@"JSON字符串"} -->Java接口 新网关使用此种结构
};

// 请求入参类型
typedef NS_ENUM(NSInteger, THKRequestType) {
    THKRequestTypeHTTP = 0,// 表单类型
    THKRequestTypeJSON,// 默认JSON类型
    THKRequestTypeLIST,// List
};

@protocol THKBaseRequestProtocol <NSObject>

#pragma mark - Request Configuration

/**
 baseUrl 应该只包含URL的host部分, 例如: http://www.example.com

 @return baseUrl
 */
- (NSString *)requestDomain;

/**
 网络请求Path, 如果是完整的URL则会忽略 requestDomain

 @return Path
 */
- (NSString *)requestUrl;

/**
 HTTP Method, 默认POST
 
 @return GET POST
 */
- (THKHttpMethod)httpMethod;

/**
 是否添加公参, 默认YES
 
 @return YES:添加, NO:不添加
 */
- (BOOL)isAddCommonParameter;

/**
 是否需要鉴权, 主要针对Java接口, 是否在URL中拼接uid和token

 @return YES: 需要鉴权, NO:不需要鉴权, 默认为YES.
 */
- (BOOL)needLoginAuthentication;

/**
 网络请求接口类型, 由于不同类型接口的入参结构不同, 在此根据接口类型对入参不同的部分做统一处理.
 如果说已知类型无法满足则可选择自定义
 
 @return PHP接口, Java接口, Java接口新网关, 自定义.
 */
- (THKParameterType)parameterType;

/**
 网络请求入参类型

 @return 网络请求入参类型
 */
- (THKRequestType)requestType;

/**
 网络请求参数

 @return 参数
 */
- (nullable NSDictionary *)parameters;

/**
 网络请求头, 基类已添加 'User-Agent' 子类重写此方法是需要注意是否需要此参数
 
 @return 所有的网络请求头, HTTPHeaderField
 */
- (nullable NSDictionary<NSString*, NSString*> *)requestHeaderFieldValueDictionary;

/**
 返回数据对应解析后的Model.
 必须继承与[THKResponse], 默认为基类[THKResponse]
 
 @return Model
 */
- (Class)modelClass;

#pragma mark - Cache

/**
 自定义当前请求缓存数据的文件名称, 如果要用到缓存功能, 则子类需要重写此方法, 自定义缓存文件名称
 如果不自定义, 或者给了空字符串, 则使用 baseUrl,requestUrl,parameters作为文件名
 缓存会校验App的版本号, 如果缓存的App版本号与当前版本号不一致则判定缓存失效, 此时会去网络请求

 @return 缓存文件名称
 */
- (nonnull NSString *)customRequestCacheFileName;

/**
 缓存的有效时长, 默认是-1, 缓存无效
 
 @return 缓存时长
 */
- (NSInteger)cacheTimeInSeconds;

/**
 缓存的版本号, 默认是0
 
 @return 缓存版本号
 */
- (long long)cacheVersion;

@end

NS_ASSUME_NONNULL_END
