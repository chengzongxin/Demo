//
//  NSObject+TRouter.h
//  Pods
//
//  Created by 彭军 on 2019/8/20.
//

#import <Foundation/Foundation.h>

@class TRouterCallbackData;

NS_ASSUME_NONNULL_BEGIN

typedef void (^TRouterCallback)(TRouterCallbackData *data);

@interface NSObject (TRouter)
@property (nonatomic,copy)TRouterCallback routerCallback;
@end

@interface TRouterCallbackData : NSObject
@property (nonatomic,assign)NSInteger code;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSDictionary *userInfo;
@end

NS_ASSUME_NONNULL_END
