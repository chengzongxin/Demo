//
//  TBTRequest.h
//  TBTNetwork
//
//  Created by 荀青锋 on 2019/6/26.
//

#import "TBTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const TBTRequestCacheErrorDomain;

typedef NS_ENUM(NSInteger, TBTRequestCacheError) {
    TBTRequestCacheErrorExpired = -1,
    TBTRequestCacheErrorVersionMismatch = -2,
    TBTRequestCacheErrorAppVersionMismatch = -3,
    TBTRequestCacheErrorInvalidCacheTime = -4,
    TBTRequestCacheErrorInvalidMetadata = -5,
    TBTRequestCacheErrorInvalidCacheData = -6,
};

@interface TBTRequest : TBTBaseRequest

#pragma mark - Request Configuration

/**
 是否缓存数据到本地, 如果缓存数据到本地则优先读取本地缓存数据, 如果本地无缓存则从网络请求, 默认不缓存
 
 YES: 缓存到本地
 NO: 不换粗
 */
@property (nonatomic, assign) BOOL isCasheData;

/**
 数据是否来自缓存

 @return YES:来自缓存, NO:不是缓存
 */
- (BOOL)isDataFromCache;

/**
 发起请求, 忽略缓存, 更新缓存
 */
- (void)startWithoutCache;

/**
 缓存数据到当前路径下

 @param data 数据
 */
- (void)saveResponseDataToCacheFile:(NSData *)data;

/**
 异步缓存数据到本地

 @param data 数据
 */
- (void)asynchronouslySaveResponseDataToCacheFile:(NSData *)data;

/**
 读取缓存数据

 @param error 错误信息
 @return YES:读取成功, NO:读取失败
 */
- (BOOL)loadCacheWithError:(NSError * _Nullable __autoreleasing *)error;

#pragma mark - Subclass Override

/**
 缓存的有效时长, 默认是-1, 此时不缓存

 @return 缓存时长
 */
- (NSInteger)cacheTimeInSeconds;

/**
 缓存的版本号, 默认是0

 @return 缓存版本号
 */
- (long long)cacheVersion;

/**
 是否异步的写入缓存

 @return YES:异步缓存, NO:同步缓存, 默认YES
 */
- (BOOL)writeCacheAsynchronously;

/**
 缓存用的, 作为文件名的一部分

 @param argument 网络请求参数
 @return 作为文件名的参数
 */
- (nullable id)cacheFileNameFilterForRequestArgument:(nullable id)argument;

/**
 自定义缓存文件名字

 @return 缓存文件名
 */
- (nonnull NSString *)customCacheFileName;

@end

NS_ASSUME_NONNULL_END
