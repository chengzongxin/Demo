//
//  TMEmptyView+THKOnlineDesignEmptyView.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/18.
//

#import <TMEmptyView/TMEmptyView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMEmptyView (THKOnlineDesignEmptyView)
+ (instancetype)showOnlineDesignEmptyInView:(UIView *)view safeMargin:(UIEdgeInsets)margin contentType:(TMEmptyContentType)contentType configContentBlock:(void (^)(NSObject<TMEmptyContentItemProtocol> * _Nonnull content))configContentBlock clickBlock:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
