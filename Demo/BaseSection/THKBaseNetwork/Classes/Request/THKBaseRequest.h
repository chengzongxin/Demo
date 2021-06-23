//
//  THKBaseRequest.h
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/4/30.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKResponse.h"
#import "THKNetworkDefine.h"
#import "THKBaseRequestProtocol.h"
#import <Foundation/Foundation.h>
//#import <TBTNetwork/TBTNetwork.h>
#import "TBTNetwork.h"
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^THKRequestSuccess)(id response);
typedef void(^THKRequestFailure)(NSError *error);

@interface THKBaseRequest : TBTRequest <THKBaseRequestProtocol>

// 网络请求Signal 每调用一次将获取一个新的Signal
- (RACSignal *)rac_requestSignal;

// 发送网络请求
- (void)sendSuccess:(THKRequestSuccess)success failure:(THKRequestFailure)failure;

// 网络请求成功后可以将返回的数据存储到本地, 在当前线程直接缓存
- (void)saveResponseDataToLocalFile;

// 异步缓存数据到本地
- (void)saveResponseDataToLocalFileAsynchronously;

// 读取本地缓存的数据
- (void)loadCacheSuccess:(THKRequestSuccess)success failure:(THKRequestFailure)failure;

// 取消网络请求
- (void)cancel;


#pragma mark - Radar

// 用于网络性能监控的Model
@property (nonatomic, strong) id netModel;
// 日志Model
@property (nonatomic, strong) id logModel;
// 网络请求成功返回数据, 目前是供雷达(Radar)SDK使用
@property (nonatomic, strong) NSDictionary *responseDict;
// 请求开始时间
@property (nonatomic, assign) NSTimeInterval startTime;

@end

NS_ASSUME_NONNULL_END
