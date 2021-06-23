//
//  TBTNetworkManager.h
//  TBTNetwork
//
//  Created by 荀青锋 on 2019/6/26.
//

#import <Foundation/Foundation.h>
#import "TBTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
typedef NSString *(^TBTNetworkFormatUrlBlock)(NSString *url);
@interface TBTNetworkManager : NSObject

/// 格式化url回调
@property (nonatomic, copy) TBTNetworkFormatUrlBlock formatUrlBlock;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 获取当前来的单例对象

 @return 当前类对象
 */
+ (TBTNetworkManager *)sharedManager;

/**
 新增一个网络请求

 @param request 网络请求对象
 */
- (void)addRequest:(TBTBaseRequest *)request;

/**
 取消一个网络请求

 @param request 网络请求对象
 */
- (void)cancelRequest:(TBTBaseRequest *)request;

/**
 取消所有的网络请求
 */
- (void)cancelAllRequests;

/**
 检验返回数据格式的正确性

 @param json 接口返回数据
 @param jsonValidator 正确的数据格式
 @return 校验结果
 */
+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator;

@end

NS_ASSUME_NONNULL_END
