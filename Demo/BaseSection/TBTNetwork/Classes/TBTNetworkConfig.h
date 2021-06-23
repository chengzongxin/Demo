//
//  TBTNetworkConfig.h
//  TBTNetwork
//
//  Created by 荀青锋 on 2019/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AFSecurityPolicy;

@interface TBTNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 获取当前类的单例对象

 @return 当前类对象
 */
+ (TBTNetworkConfig *)sharedConfig;

/**
 网络请求Base URL, 例如: http://www.example.com, 默认为空串
 */
@property (nonatomic, strong) NSString *baseUrl;

/**
 AFNetworking用到的加密策略, 具体可以查看 AFSecurityPolicy类
 */
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

/**
 是否开始debug下的log信息, 默认开启
 */
@property (nonatomic) BOOL debugLogEnabled;

/**
 初始化AFHTTPSessionManager用到的配置信息, 默认为nil
 */
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

/**
 可接收的返回数据类型, 默认为nil
 例如: @"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain"
 */
@property (nonatomic, copy, nullable) NSSet *acceptableContentTypes;

@end

NS_ASSUME_NONNULL_END
