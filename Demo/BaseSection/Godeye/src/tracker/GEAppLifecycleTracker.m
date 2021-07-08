//
//  GEAppLifecycleTracker.m
//  Pods
//
//  Created by jerry.jiang on 2018/12/26.
//

#import "GEAppLifecycleTracker.h"
#import "GEDispatcher.h"
#import "GEProcessor+GodeyePrivate.h"
#import "GEPageViewProcessor.h"
#import "GEEnvironmentParameter.h"

NSString *GEApplicationSuspendEventName = @"appSuspend";
NSString *GEApplicationDestroyEventName = @"appDestory";
NSString *GEApplicationInstallEventName = @"appInstall";
NSString *GEApplicationLaunchEventName = @"appLaunch";
//针对积分墙用户主动上报idfa的事件上报 appIdfaAuthorize
NSString *GEApplicationAppIdfaAuthorizeEventName = @"appIdfaAuthorize";

@implementation GEAppLifecycleTracker

static NSString *kGEAppFirstLaunchKey = @"com.to8to.GEFirstLaunchKey";

+ (instancetype)defaultTracker
{
    static GEAppLifecycleTracker *tracker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tracker = [[GEAppLifecycleTracker alloc] init];
    });
    return tracker;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackgroundNotification:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForegroundNotification:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appTerminate)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appLaunchWithOption:(NSDictionary *)launchOption
{
    BOOL firstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kGEAppFirstLaunchKey];
    if (!firstLaunch) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGEAppFirstLaunchKey];
        [self reportEvent:GEApplicationInstallEventName properties:nil];
    }
    
    NSString *launch_from = @"desktop";
    NSString *launch_data = launchOption[UIApplicationLaunchOptionsSourceApplicationKey];
    if (launch_data) {
        launch_from = @"app";
    } else {
        NSDictionary *remoteNotification = launchOption[UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification) {
            launch_from = @"push";
            launch_data = [self convertDictToJsonStr:remoteNotification];
        }
    }

    [self reportEvent:GEApplicationLaunchEventName
           properties:@{@"launch_from":launch_from, @"launch_data":launch_data ?: @""}];
}

// App将要进入后台的通知
- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification {
    if (self.handleControlApplicationCycle) {
        return;
    }
    
    [self appResignActive];
}

// App将要进入前台的通知
- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification {
    if (self.handleControlApplicationCycle) {
        return;
    }
    
    [self appBecomeActive];
}

// App将要进入后台
- (void)handleControlApplicationDidEnterBackground:(UIApplication *)application {
    if (!self.handleControlApplicationCycle) {
        return;
    }
    
    [self appResignActive];
}

// App将要进入前台
- (void)handleControlApplicationWillEnterForeground:(UIApplication *)application {
    if (!self.handleControlApplicationCycle) {
        return;
    }
    
    [self appBecomeActive];
}

- (void)appBecomeActive
{
    [[GEEnvironmentParameter defaultParameter] appDidBecomeActive];
    [self reportEvent:@"appReactive" properties:nil];
    [[GEPageViewProcessor defaultProcessor] appBecomeActive];
}

- (void)appResignActive
{
    [[GEEnvironmentParameter defaultParameter] appDidResignActive];
    [[GEPageViewProcessor defaultProcessor] appResignActive];
    [self reportEvent:GEApplicationSuspendEventName properties:nil];
}

- (void)appTerminate
{
    [self reportEvent:GEApplicationDestroyEventName properties:nil];
}

- (NSString *)convertDictToJsonStr:(NSDictionary *)dict {
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData || error) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString ?: @""];
    
    // 去掉字符串中的空格
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    // 去掉字符串中的换行符
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

@end
