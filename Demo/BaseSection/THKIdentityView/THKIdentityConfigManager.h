//
//  THKIdentityConfigManager.h
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/2/5.
//

#import <UIKit/UIKit.h>
#import "THKIdentityViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^T8TBasicBlock)(void);

@interface THKIdentityConfigManager : NSObject

/// 单例管理
+ (instancetype)shareInstane;

/// 加载配置，会加载本地和远程两个配置
- (void)loadConfig;

/// 获取配置
/// @param type 标识类型
/// @param subType 二级标识类型
- (THKIdentityTypeModelSubCategory *)fetchConfigWithType:(NSInteger)type subType:(NSInteger)subType;

- (void)loadConfigWithResultBlock:(T8TBasicBlock)resultBlock;

///加载完成DNS域名接口
@property (nonatomic, assign, readonly) BOOL loadFinishDNS;


/// 是否需要配置请求的ip
-(BOOL)needConfigRequestIPForUrl:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
