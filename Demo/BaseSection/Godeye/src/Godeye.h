//
//  Godeye.h
//  Pods
//
//  Created by jerry.jiang on 2018/12/25.
//

#import <Foundation/Foundation.h>
#import "UIViewController+Godeye.h"
#import "UIScrollView+Godeye.h"
#import "UIView+Godeye.h"
#import "UIResponder+Godeye.h"
#import "GEWidgetEvent.h"
#import "GECollectionView.h"
#import "GETableView.h"

#define CURRENT_TIMESTAMP (CFAbsoluteTimeGetCurrent()+kCFAbsoluteTimeIntervalSince1970)
#define GODEYE_VERSION @"0.9.12"
extern void GELog(NSString *frmt, ...);
@interface Godeye : NSObject

+ (void)startWithAppName:(NSString * _Nonnull)appName launchOption:(NSDictionary *_Nullable)launchOption;

+ (BOOL)handelURL:(NSURL * _Nullable)url sourceApplication:(NSString * _Nullable)application;

+ (void)setLogEnable:(BOOL)enable;
// 是否手动调用App进入后台和返回前台的方法, 默认NO
+ (void)handleControlApplicationCycle:(BOOL)enable;
// App将要进入后台
+ (void)applicationDidEnterBackground:(UIApplication *)application;
// App将要进入前台
+ (void)applicationWillEnterForeground:(UIApplication *)application;

@end
