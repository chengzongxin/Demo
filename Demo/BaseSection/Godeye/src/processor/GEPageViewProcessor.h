//
//  GEPageViewProcessor.h
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import "GEProcessor.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GEPageViewProcessor : GEProcessor

+ (instancetype)defaultProcessor;

- (void)addPageShowEvent:(UIViewController *)vc;

- (void)addPageHideEvent:(UIViewController *)vc;

- (void)addViewPageDetailEvent:(UIViewController *)vc;

/**
 获取当前正在展示的VC

 @return 当前正在展示的VC
 */
- (UIViewController *)topViewController;

- (void)appBecomeActive;
- (void)appResignActive;

@end

NS_ASSUME_NONNULL_END
