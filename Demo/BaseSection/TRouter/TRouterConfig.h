//
//  TRouterConfig.h
//  Example
//
//  Created by 彭军 on 2019/4/29.
//  Copyright © 2019 to8to. All rights reserved.
//  此类主要由业务继承来扩展需要登录的路由页面、以及构建不同的TRouter子类

#import <Foundation/Foundation.h>
#import "TRouterProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface TRouterConfig : NSObject<TRouterConfigProtocol>

@end

NS_ASSUME_NONNULL_END
