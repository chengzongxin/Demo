//
//  THKResponse.h
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/4/30.
//  Copyright © 2019 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    /// 接口请求成功，通常返回的数据status值为0或200时，会对response对象的status赋值为此值
    THKStatusSuccess = 0,
    
    /// 接口请求失败。包含请求成功但状态码不对以及网络不通情况下的失败会对response对象的status赋值此值
    THKStatusFailure = 1,
} THKStatus;

@interface THKResponse : NSObject<NSCoding>

// 版本号
@property (nonatomic,assign) CGFloat version;

// 操作的控制器名称
@property (nonatomic,strong) NSString *action;

// 错误编码 0、200表示一切正常或操作成功
@property (nonatomic,assign) NSInteger errorCode;

// 符合条件的总信息数
@property (nonatomic,assign) NSUInteger allRows;

// 错误信息
@property (nonatomic, copy) NSString *errorMsg;

// 网络请求结果 errorCode为0,200时为success,否则为failure
@property (nonatomic, assign) THKStatus status;

/**
 NSDictionary 转 Model，网络请求成功后会自动调用
 
 @param dictionary NSDictionary
 @return Model
 */
+ (instancetype)toModelWithDictionary:(NSDictionary *)dictionary;

// 将Model转换成NSDictionary
- (NSDictionary *)toDictionary;

@end

@interface THKResponse(NSError)

/**
 便捷的由error生成__kindof THKResponse 类型的对象的方法
 @note 返回的对象status值为 THKStatusFailure， code 为error.code，通常情况下网络不通导致的请求失败的error.code < 0,errMsg 为 对应定义的 toast提示文本串
 @warning 若error为nil，亦会返回一个表示网络状态问题的response，只是对应的errorCode会为-1
 */
+ (instancetype)responseWithNetError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
