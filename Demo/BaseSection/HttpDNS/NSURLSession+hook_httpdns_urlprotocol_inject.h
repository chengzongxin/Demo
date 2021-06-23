//
//  NSURLSession+hook_httpdns_urlprotocol_inject.h
//  HouseKeeper
//
//  Created by nigel.ning on 2021/3/1.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
正常添加urlprotocol拦截的方法：
 //注册自定义protocol
[NSURLProtocol registerClass:[CustomURLProtocol class]];
 NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
configuration.protocolClasses = @[[CustomURLProtocol class]];
 @note 由于用的AFNetworking框架， [AFHTTPSessionManager manager]不是单例，为了能统一处理到所有基于AFNetworking框架的网络请求，这里统一对系统NSURLSession的相关方法进行hook来注入相关自定义的urlprotocol。
 */
@interface NSURLSession (hook_httpdns_urlprotocol_inject)

@end

NS_ASSUME_NONNULL_END
