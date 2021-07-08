//
//  Godeye.m
//  Pods
//
//  Created by jerry.jiang on 2018/12/25.
//

#import "Godeye.h"
#import "GELocation.h"
#import "GEEnvironmentParameter.h"
#import "GEAppLifecycleTracker.h"
#import "GEDispatcher.h"

static BOOL _logEnable = NO;

void GELog(NSString *format, ...) {
    if (!_logEnable) {
        return;
    }
    va_list args;
    NSString *log = format;
    if (args) {
        va_start(args, format);
        log = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }
    printf("%s\n", [log UTF8String]);
}

@implementation Godeye

+ (void)initialize
{
#if DEBUG
    [self setLogEnable:NO];
#else
    [self setLogEnable:NO];
#endif
}

+ (void)startWithAppName:(NSString * _Nonnull)appName launchOption:(NSDictionary *)launchOption
{
    NSParameterAssert(appName);
    GELog(@"Godeye Info: Starting...");
    [GEEnvironmentParameter defaultParameter].app_name = appName;
    [GELocation updateLocation];
    [[GEAppLifecycleTracker defaultTracker] appLaunchWithOption:launchOption];
}

+ (BOOL)handelURL:(NSURL *)url sourceApplication:(NSString *)application
{
#if DEBUG
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:url.absoluteString];
    if ([components.host isEqualToString:@"tbtrouter"] && [components.path isEqualToString:@"/bigdata"]) {
        for (NSURLQueryItem *item in components.queryItems) {
            if ([item.name isEqualToString:@"room"]) {
                [GEDispatcher defaultDispatcher].roomId = item.value;
                break;
            }
        }
        [[GEDispatcher defaultDispatcher] connectToRocketCI];
    }
#endif
    return NO;
}

+ (void)setLogEnable:(BOOL)enable
{
    _logEnable = enable;
}

// 是否手动调用App进入后台和返回前台的方法, 默认NO
+ (void)handleControlApplicationCycle:(BOOL)enable {
    [GEAppLifecycleTracker defaultTracker].handleControlApplicationCycle = enable;
}

// App将要进入后台
+ (void)applicationDidEnterBackground:(UIApplication *)application {
    [[GEAppLifecycleTracker defaultTracker] handleControlApplicationDidEnterBackground:application];
}

// App将要进入前台
+ (void)applicationWillEnterForeground:(UIApplication *)application {
    [[GEAppLifecycleTracker defaultTracker] handleControlApplicationWillEnterForeground:application];
}

@end
