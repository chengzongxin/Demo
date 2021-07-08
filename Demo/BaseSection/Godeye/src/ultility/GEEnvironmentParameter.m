//
//  GEEnvironmentParameter.m
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import "GEEnvironmentParameter.h"
#import "GELocation.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <arpa/inet.h>
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <CommonCrypto/CommonDigest.h>
#import "GEDispatcher.h"
#if __has_include(<TUUIDGenerator/TUUIDGenerator.h>)
#import <TUUIDGenerator/TUUIDGenerator.h>
#else
#import "TUUIDGenerator.h"
#endif
#import "Godeye.h"

NSString *md5_convert(NSString *string)
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [NSString stringWithString:result];
}

@interface GEEnvironmentParameter () {
    // 等于0:默认值, 大于0:记录的是进入后台的时间, 小于0:进入后台30秒后生成了新的session
    NSTimeInterval _enterBackgroundTime;
}


@property (nonatomic, readonly) NSString *app_version;

@property (nonatomic, readonly) NSString *model;
@property (nonatomic, readonly) NSString *idfa;
@property (nonatomic, readonly) NSString *idfv;
@property (nonatomic, readonly) NSString *network_type;
@property (nonatomic, readonly) NSString *wifi_ssid;
@property (nonatomic, readonly) NSString *wifi_ip;
@property (nonatomic, readonly) long timestamp;

@property (nonatomic, readonly) NSString *device_id;//无埋点设备号
@property (nonatomic, assign) NSTimeInterval sessionTime;// session创建的时间

@end

@implementation GEEnvironmentParameter

static NSString *UNKNOWN = @"unknown";

@synthesize model = _model;
@synthesize app_version = _app_version;
@synthesize network_type = _network_type;
@synthesize wifi_ssid = _wifi_ssid;
@synthesize wifi_ip = _wifi_ip;
@synthesize session = _session;
@synthesize device_id = _device_id;

- (NSDictionary *)parameter
{
    if (!self.app_name) {
        NSAssert(self.app_name != nil, @"app_name can not be nil");
        return @{};
    }
    NSDictionary *hardwareParameter = @{@"manufacturer":@"Apple",
                                        @"brand":[UIDevice currentDevice].model,
                                        @"screen_height":@([UIScreen mainScreen].bounds.size.height).description,
                                        @"screen_width":@([UIScreen mainScreen].bounds.size.width).description,
                                        @"model":self.model,
                                        @"idfa":self.idfa,
                                        @"idfv":self.idfv,
                                        @"network_type":self.network_type,
                                        @"wifi_ssid":self.wifi_ssid,
                                        @"wifi_ip":self.wifi_ip,
                                        };
    NSMutableDictionary *headerParameter = [@{
                                              @"first_id":self.first_id ?: @"",
                                              @"user_id":self.user_id ?: @"0",
                                              @"account_id":self.account_id ?: @"0",
                                              @"app_name":self.app_name,
                                              @"app_version":self.app_version,
                                              @"channel":self.channel,
                                              @"longtitude":@([GELocation longitude]).description,
                                              @"latitude":@([GELocation latitude]).description,
                                              @"os":[UIDevice currentDevice].systemName,
                                              @"os_version":[UIDevice currentDevice].systemVersion,
                                              @"device":hardwareParameter,
                                              @"device_id": self.device_id,
                                              @"lib_version":GODEYE_VERSION ?: @"",
                                              @"isnew" : @(self.isnew),
                                              } mutableCopy];
    if (_debugInfo) {
        headerParameter[@"debug_id"] = _debugInfo;
    }
    if (_user_city) {
        headerParameter[@"user_city"] = _user_city;
    }
    return [headerParameter copy];
}

+ (instancetype)defaultParameter
{
    static GEEnvironmentParameter *defaultObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultObject = [[GEEnvironmentParameter alloc] init];
    });
    return defaultObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enterBackgroundTime = 0;
        _sessionTime = 0;
    }
    return self;
}

- (void)setImmediatelyReportList:(NSArray *)immediatelyReportList {
    [GEDispatcher defaultDispatcher].immediatelyReportList = immediatelyReportList;
}

- (void)appDidResignActive {
    _enterBackgroundTime = self.timestamp / 1000;
}

- (void)appDidBecomeActive {
    
    NSTimeInterval currentTime = self.timestamp / 1000;
    
    // App进入后台, 未在后台产生新的session, 并且在后台停留的时间超过了30秒, 此时需要刷新session
    if (_enterBackgroundTime > 0 && (currentTime - _enterBackgroundTime > 30.0)) {
        _enterBackgroundTime = 0;// 重置进入后台时间
        _sessionTime = 0;// 重置sessionTime
        _session = nil;// 重置session
        
        // App进入后台生成了新的session, 并且session生成的时间超过30秒, 此时需要刷新session
    } else if (_enterBackgroundTime < 0 && (_sessionTime > 0) && (currentTime - _sessionTime > 30.0)) {
        _enterBackgroundTime = 0;// 重置进入后台时间
        _sessionTime = 0;// 重置sessionTime
        _session = nil;// 重置session
    } else {
        _enterBackgroundTime = 0;// 重置进入后台时间
    }
}

- (NSString *)session {
    
    // 当前时间戳
    long currentTime = self.timestamp / 1000;
    
    // App进入后台会记录一个时间戳[_enterBackgroundTime], 如果时间戳[_enterBackgroundTime]为0, 则说明没有进入后台的操作, 则不需要刷新session
    // 如果当前时间戳和进入后台的时间戳[_enterBackgroundTime]之间的差值大于30秒,则需要刷新session, 刷新完session后需要立马将[_enterBackgroundTime]置为-1,
    // 避免重复刷新session
    
    BOOL refresh = ((_enterBackgroundTime > 0) && (currentTime - _enterBackgroundTime > 30.0));
    
    if (!_session || refresh) {
        
        if (refresh) {
            // 因为进入后台刷新session的需要将进入后台的时间置为负数
            _enterBackgroundTime = -1;
        }
        
        _sessionTime = currentTime;
        _session = [NSString stringWithFormat:@"s_%@", md5_convert([NSString stringWithFormat:@"%ld_%d_%@", currentTime, arc4random(), self.first_id])];
    }
    
    return _session;
}

// App当前是否处于后台
- (BOOL)isInBackground {
    NSTimeInterval currentTime = self.timestamp / 1000;
    
    // 进入后台时长大于30秒
    if (_enterBackgroundTime > 0 && (currentTime - _enterBackgroundTime > 30.0)) {
        return YES;
    }
    
    return (_enterBackgroundTime < 0);
}

- (NSString *)network_type
{
    if (!_network_type) {
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
        SCNetworkReachabilityFlags flags;
        SCNetworkReachabilityGetFlags(defaultRouteReachability,&flags);
        CFRelease(defaultRouteReachability);
        
        _network_type = UNKNOWN;
        
        if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
            _network_type = @"wifi";
        }
        
        if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
        {
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *access = info.currentRadioAccessTechnology;
            
            if (access) {
                if ([access isEqualToString:CTRadioAccessTechnologyLTE]) {
                    _network_type = @"4G";
                } else if ([access isEqualToString:CTRadioAccessTechnologyEdge] || [access isEqualToString:CTRadioAccessTechnologyGPRS]) {
                    _network_type = @"2G";
                } else {
                    _network_type = @"3G";
                }
            }
        }
    }
    return _network_type;
}

- (NSString *)wifi_ssid
{
    if (!_wifi_ssid) {
        NSArray *interfaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
        for (NSString *name in interfaceNames) {
            NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
            if (info[@"SSID"]) {
                _wifi_ssid = info[@"SSID"];
            }
        }
        if (!_wifi_ssid) {
            _wifi_ssid = UNKNOWN;
        }
    }
    return _wifi_ssid;
}

- (NSString *)wifi_ip
{
    NSString *address = UNKNOWN;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)app_version
{
    if (!_app_version) {
        _app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _app_version;
}

- (NSString *)channel
{
    return _channel ? _channel : @"appstore";
}

- (long)timestamp
{
    return (long)(CURRENT_TIMESTAMP * 1000);
}

- (NSString *)model
{
    if (!_model) {
        struct utsname systemInfo;
        uname(&systemInfo);
        _model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    }
    return _model;
}

- (NSString *)first_id
{
    if (!_first_id) {
        _first_id = [TUUIDGenerator getFristId];
    }
    return _first_id;
}


- (NSString *)idfa
{
    return [TUUIDGenerator getIDFA];    
}

- (NSString *)idfv
{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

- (NSString *)device_id
{
    if (!_device_id) {
        _device_id = [NSString stringWithFormat:@"d_%@", md5_convert([NSString stringWithFormat:@"%@%@", self.idfa, self.idfv])];
    }
    return _device_id;
}

- (NSString *)userAgent
{
    NSString *appName = _app_name ?:
    ([[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?:
     [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey]);
    
    NSString *UA = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%.2f)",
                    appName,
                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"",
                    self.model,
                    [[UIDevice currentDevice] systemVersion],
                    [UIScreen mainScreen].scale];
    return UA;
}

@end
