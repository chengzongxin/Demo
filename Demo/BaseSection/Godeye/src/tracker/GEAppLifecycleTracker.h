//
//  GEAppLifecycleTracker.h
//  Pods
//
//  Created by jerry.jiang on 2018/12/26.
//

#import "GEProcessor.h"


@interface GEAppLifecycleTracker : GEProcessor

+ (instancetype)defaultTracker;

- (void)appLaunchWithOption:(NSDictionary *)launchOption;

// 是否是手动控制App进入前后台, 默认未NO
@property (nonatomic, assign) BOOL handleControlApplicationCycle;

// 手动的App将要进入后台
- (void)handleControlApplicationDidEnterBackground:(UIApplication *)application;
// 手动的App将要进入前台
- (void)handleControlApplicationWillEnterForeground:(UIApplication *)application;

@end
