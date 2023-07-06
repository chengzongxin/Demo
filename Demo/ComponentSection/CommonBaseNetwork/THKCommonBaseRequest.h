//
//  THKCommonBaseRequest.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2023/5/18.
//  Copyright © 2023 binxun. All rights reserved.
//

#import "THKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol THKCommonBaseRequest <NSObject>

@optional
- (NSString *)requestUrl;
- (NSString *)requestDomain;
- (THKHttpMethod)httpMethod;
- (NSDictionary *)parameters;
- (THKParameterType)parameterType;
- (Class)modelClass;

@end


/// 继承这个类，可以不用写里面的子类方法，但要按照约定命名Request类、Response类名
/// Request采用小驼峰写法，requestUrl会自动把大写转换成小写，再在前面加 “/”，例如，THKUserSuperPKList 则会变成 /user/super/p/k/list。
/// Response会使用Request前缀，只把最后的替换成Response
@interface THKCommonBaseRequest : THKBaseRequest <THKCommonBaseRequest>

@end

NS_ASSUME_NONNULL_END
