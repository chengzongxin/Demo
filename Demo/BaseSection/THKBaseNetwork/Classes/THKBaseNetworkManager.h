//
//  THKBaseNetworkManager.h
//  THKBaseNetwork
//
//  Created by 荀青锋 on 2019/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class THKBaseRequest;

typedef void(^THKRequestBlock)(THKBaseRequest *request);
typedef NSDictionary * _Nullable(^THKParametersBlock)(void);
typedef NSString * _Nullable(^THKStringBlock)(void);

@interface THKBaseNetworkManager : NSObject

// 用户ID取 THKUserModel 类中的 uid 属性
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) THKStringBlock userIdBlock;

// 用户Token取 THKUserModel 类中的 to8to_token 属性
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) THKStringBlock tokenBlock;

// UserAgent取 [[TRequestParameter sharedParameter] userAgent]
@property (nonatomic, copy) NSString *userAgent;
@property (nonatomic, copy) THKStringBlock userAgentBlock;

// 公参取 [[TRequestParameter sharedParameter] getSharedParameter]
@property (nonatomic, copy) NSDictionary *parameters;
@property (nonatomic, copy) THKParametersBlock parametersBlock;

// 请求开始回调
@property (nonatomic, copy) THKRequestBlock startRequestBlock;
// 请求成功回调
@property (nonatomic, copy) THKRequestBlock successRequestBlock;
// 请求失败回调
@property (nonatomic, copy) THKRequestBlock failureRequestBlock;

/**
 所有的请求回调

 @param startRequestBlock 请求开始
 @param successRequestBlock 请求成功
 @param failureRequestBlock 请求失败
 */
- (void)requestStart:(THKRequestBlock)startRequestBlock
             success:(THKRequestBlock)successRequestBlock
             failure:(THKRequestBlock)failureRequestBlock;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 获取当前来的单例对象
 
 @return 当前类对象
 */
+ (THKBaseNetworkManager *)sharedManager;

@end

NS_ASSUME_NONNULL_END
