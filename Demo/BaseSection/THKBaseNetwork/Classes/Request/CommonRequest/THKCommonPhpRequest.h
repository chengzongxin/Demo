//
//  THKCommonPhpRequest.h
//  HouseKeeper
//
//  Created by nigel.ning on 2019/11/8.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKCommonRequest.h"
#import "THKCommonResponse.h"

NS_ASSUME_NONNULL_BEGIN

/**
 针对php接口: 对于一些旧代码业务调用接口集成度高，再尽可能少改动接口逻辑的前提下，需要提供一套通用的不包含任务业务数据逻辑的请求处理类，相关请求链接、请求参数、请求方式等均可由外部指定的通用请求方式，对应的解析response也为THKCommonResponse对象，便于最少代码替换旧的接口调用处理逻辑
 @note 外部只需要赋值完整的请求api地址commonUrl及传递功能性的参数字典commonParamsDic即可，其它父类中的配置参数项内部均会按php接口的默认配置值赋值
 @note php接口 requestType默认为THKRequestTypeHTTP，parameterType默认为父类默认值THKParameterTypeDefault
 */
@interface THKCommonPhpRequest : THKCommonRequest

///MARK: 通常外部仅需要赋值以下属性值即可
// common_requestUrl;///< 请求的接口网关url串，必需手动赋值

// common_httpMethod;///< 表示GET或POST请求方式，必需手动赋值

// common_parameters;///< 请求的接口参数字典,不包含公参数据，若请求有参数则必需手动赋值


@end

NS_ASSUME_NONNULL_END
