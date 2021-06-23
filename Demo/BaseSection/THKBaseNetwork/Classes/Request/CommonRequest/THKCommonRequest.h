//
//  THKCommonRequest.h
//  HouseKeeper
//
//  Created by nigel.ning on 2019/11/27.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKBaseRequest.h"
#import "THKCommonResponse.h"

NS_ASSUME_NONNULL_BEGIN

/**
 基于THKBaseRequest封装的通用型请求类，即可自定义配置参数最全的类，一般情况下用不到，特别情况根据实际需要选择性使用
 @note 此可用作其它特定类型请求对象的类的基类，如可在此基础上封装 统一的phpRequest 、javaRequest 可分别对应原工程里的THTTPManager_PHP()、THTTPManager_JavaNew()的功能 (THTTPManager_Java()--旧java网关工程里已无使用)
 @note 鉴于BaseRequest里相关方法或属性均为协议扩展的getter方法，不支持外部直接使用修改，所以这里为相关方法、属性不与基类重复，对基类的定义的行为属性进行二次包装成可写属性，会在定义的属性前统一增加common前缀,外部使用此类或其子类时只需要关注提供的common属性赋值即可。
 */
@interface THKCommonRequest : THKBaseRequest

///MARK: required


@property (nonatomic, copy)NSString *common_requestUrl;///< 请求的接口网关url串，必需手动赋值

@property (nonatomic, assign)THKHttpMethod common_httpMethod;///< 表示GET或POST请求方式，必需手动赋值

@property (nonatomic, assign)THKRequestType common_requestType;///< 请求的reqeust类型，建议php给 http、java给json

@property (nonatomic, strong, nullable)NSDictionary *common_parameters;///< 请求的接口参数字典,不包含公参数据，若请求有参数则必需手动赋值

@property (nonatomic, assign)THKParameterType common_parameterType;///<  参数自定义的结构类型，PHP接口, Java接口, Java接口新网关分别对应不同类型，具体看相关举报值的注释说明

///MARK: optional

@property (nonatomic, strong)Class common_modelClass;///<  数据解析对应的response的模型类，默认为THKCommonResponse, 外部可根据需要选择性传入其它response类型，此类必需是继承自THKResponse的类, 若为null则用THKCommonResponse类型接收

@property (nonatomic, assign)BOOL common_isAddCommonParameter;///< 是否添加公参，默认为YES

@property (nonatomic, assign)BOOL common_needLoginAuthentication;///< 是否需要鉴权, 主要针对Java接口, 是否在URL中拼接uid和token, 默认为YES

@end

NS_ASSUME_NONNULL_END
