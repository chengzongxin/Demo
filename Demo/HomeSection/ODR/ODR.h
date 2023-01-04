//
//  ODR.h
//  Demo
//
//  Created by Joe.cheng on 2023/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ODR : NSBundleResourceRequest


/// 创建ODR初始化并请求资源
/// @param tags tag
/// @param completionHandler 完成回调
/// @param errorBlock 失败回调
- (instancetype)initWithTags:(NSSet<NSString *> *)tags
                  completion:(void (^)(BOOL resourcesAvailable))completionHandler
                       error:(void (^)(NSError *error))errorBlock;

@end

NS_ASSUME_NONNULL_END
