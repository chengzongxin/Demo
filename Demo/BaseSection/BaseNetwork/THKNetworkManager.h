//
//  THKNetworkManager.h
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/11/5.
//  Copyright © 2019 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKNetworkManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 获取当前来的单例对象
 
 @return 当前类对象
 */
+ (THKNetworkManager *)sharedManager;

/**
 初始化网络请求
 */
- (void)setupNetwork;


/// 是否设置了UserAgent
-(BOOL)isSettedUserAgent;
@end

NS_ASSUME_NONNULL_END
