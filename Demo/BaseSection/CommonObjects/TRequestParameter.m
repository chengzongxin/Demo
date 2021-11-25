//
//  TRequestParameter.m
//  TBasicLib
//
//  Created by kevin.huang on 14-7-8.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "TRequestParameter.h"
#import <sys/utsname.h>
//#import <TBTLog/TBTLog.h>
//#import <TBasicLib/TBasicLib.h>
//#import "THKAppGroupHandler.h"

@implementation TRequestParameter {
    NSDictionary *_dicAppendDicParameter;
    THKObjectBlock _getCityIdIfNeededBlock;
    THKObjectBlock _getCityNameIfNeededBlock;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *uuid =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.t8t_device_id = uuid ? uuid : @"0";
        self.version = @"2.5";
        self.uid = 172176109;
        self.to8to_token = @"vBM5Pe1cQUgQyLkMSR8Dm8Qg9OOpHLLSLJbg-qoVY7xZP7moUuqPk0d3eTeAEuEf2ExBtV7tOc1-eP9r5mEJQlwQivw3yrR3WkSSR3QXtVvxRGJw9eNOk5pPc6CDHaFA";
        self.appversion = @"9.11.0";
        self.systemversion = [[UIDevice currentDevice] systemVersion];
        self.channel = @"appstore";
        self.idfa = @"00000000-0000-0000-0000-000000000000";
        self.appostype = 2;//标识是ios
        self.deviceModel = [self deviceModel];
    }
    return self;
}

///重写此方法，保证idfa串读取时为当前有效值
- (NSString *)idfa {
    _idfa = @"00000000-0000-0000-0000-000000000000";
    return _idfa;
}


+ (instancetype)sharedParameter {
    static TRequestParameter *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[TRequestParameter alloc] init];
    });
    return sharedManagerInstance;
}

- (void)appendDicParameter:(NSDictionary *)dicParameter {
    _dicAppendDicParameter = dicParameter;
}

- (NSDictionary *)getSharedParameter {
//    self.uid = UID_TO8TO ? [UID_TO8TO integerValue] : 0;
//    self.to8to_token = kUnNilStr([kUserDefaults objectForKey:KT8TTokenKey]);
    NSMutableDictionary *dic = [self mj_keyValues];
//    if (kTo8toAppId != 0) {
        [dic setObject:@(15) forKey:@"appid"];
//    }
    if([_dicAppendDicParameter isKindOfClass:[NSDictionary class]]) {
        [dic addEntriesFromDictionary:_dicAppendDicParameter];
    }
    // 城市ID不存在则主动获取
    if ([dic[@"cityid"] integerValue] == 0) {
        NSInteger cid = [self getCityIdIfNeeded];
        if (cid == 0) {
            NSString *cname = [self getCityNameIfNeeded];
            if ([cname isEqualToString:@"深圳"]) {
                cid = 1130;
            }
        }
        dic[@"cityid"] = @(cid);
        _cityid = cid;
    }
    // 城市名称不存在则主动获取
    id cityName = dic[@"cityName"];
    if (!cityName || [cityName isKindOfClass:[NSNull class]] || [cityName length] == 0) {
        NSString *cname = [self getCityNameIfNeeded];
        if (cname) {
            dic[@"cityName"] = cname;
            _cityName = cname;
        }
    }
    
    //作用：首次安装时，定位成功后赋值，替换默认的城市id
    //cityId > 0,避免定位到的城市获取不到ID
//    if ([TLocationManager currentCityId] != _cityid && [TLocationManager currentCityId] > 0) {
//
//        _cityid = [TLocationManager currentCityId];
//        _cityName = [TLocationManager getCityName];
//        [TRequestParameter sharedParameter].cityid    = _cityid;
//        [TRequestParameter sharedParameter].cityName  = _cityName;
//        [THKAppGroupHandler shareInstane].cityId = _cityid;
//    }
    return dic;
}

- (NSInteger)getCityIdIfNeeded {
    if (_getCityIdIfNeededBlock) {
        return [_getCityIdIfNeededBlock() integerValue];
    }
    return 0;
}

- (NSString *)getCityNameIfNeeded {
    if (_getCityNameIfNeededBlock) {
        return _getCityNameIfNeededBlock();
    }
    return @"";
}

- (void)setCityIdBlock:(THKObjectBlock)cityIdBlock {
    _getCityIdIfNeededBlock = cityIdBlock;
}

- (void)setCityNameBlock:(THKObjectBlock)cityNameBlock {
    _getCityNameIfNeededBlock = cityNameBlock;
}

+ (NSString *)parameterStringForGet {
    NSMutableArray *arr = [NSMutableArray array];
    [[[self sharedParameter]getSharedParameter] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
        [arr addObject:str];
    }];
    NSString *strParameter = [arr componentsJoinedByString:@"&"];
    return strParameter;
}

+ (NSString *)addCommonParameterForUrl:(NSString *)strUrl {
    NSRange rge = [strUrl rangeOfString:@"?"];
    NSString *strParameter = [[self parameterStringForGet] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strUrlForReturn = [NSString stringWithFormat:@"%@%@%@",strUrl,rge.length>0?@"&":@"?", strParameter];
    return strUrlForReturn;
}

- (NSString *)deviceModel {
    if (!_deviceModel) {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString * deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        _deviceModel = deviceModel;
    }
    return _deviceModel;
}

- (NSString *)userAgent {
    NSString *appName = nil ?:
    ([[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?:
     [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey]);
    
    NSString * UA = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%.2f)",
                     appName,
                     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"",
                     self.deviceModel ,
                     [[UIDevice currentDevice] systemVersion],
                     [UIScreen mainScreen].scale];
    return UA;
}

@end
