//
//  THKHttpDNSManager.m
//  HouseKeeper
//
//  Created by collen.zhang on 2021/4/7.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKHttpDNSManager.h"
//#import "HtmlURLProtocol.h"
//#import "CCCandyWebCache.h"
//#import <Godeye/GECommonEventTracker.h>
//#import "THKIdentityConfigManager.h"
@interface THKHttpDNSManager()

@property (nonatomic, copy) NSDictionary* domainDic;

//web的域名是做反向查找的，通过huhudi -> to8to
@property (nonatomic, copy) NSDictionary* webDomainDic;

@property (nonatomic, assign) NSInteger switchStatus;

@property (nonatomic, strong) NSMutableArray* reportArray;

/// to8to.com
@property (nonatomic, copy) NSString* secondLevelDomainStr;

/// .to8to.com
@property (nonatomic, copy) NSString* pointSecondLevelDomainStr;

/// to8to
@property (nonatomic, copy) NSString* secondDomainStr;

@end

@implementation THKHttpDNSManager

+ (THKHttpDNSManager *)shareInstane {
    static THKHttpDNSManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _switchStatus = 1;
    }
    return self;
}

-(void)setDomainDic:(NSDictionary *)domainDic{
    _domainDic = domainDic;
    _webDomainDic = nil;

    //配置表每次更新时，domain字符串都置为空
    _secondLevelDomainStr = nil;
    _pointSecondLevelDomainStr = nil;
    _secondDomainStr = nil;

    _useNewDomain = NO;
    if (domainDic.count >= 1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (NSString *key in domainDic) {
            dic[domainDic[key]] = key;
        }
        _webDomainDic = [dic copy];

        _useNewDomain = YES;
    }

}

-(void)configDomainDic:(NSDictionary *)dic{
    if ([dic isKindOfClass:[NSDictionary class]] && dic.count > 0) {
        self.domainDic = [dic copy];
    }else{
        self.domainDic = nil;
    }
//    THKDebugLog(@"configDomainDic = %@",dic);
}

- (void)configDomainSwitch:(NSInteger)switchStatus{
    if (switchStatus == 1) {
        if (_switchStatus != switchStatus) {
            [self addHtmlProtocolSeesionConfiguration];
        }
    }else{
        [self configDomainDic:nil];
        [self removeHtmlProtocolSeesionConfiguration];
    }
    _switchStatus = switchStatus;
}

-(void)addHtmlProtocolSeesionConfiguration{
//    NSURLSessionConfiguration *nConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    if (nConfig) {
//        NSMutableArray *protocolList = [NSMutableArray arrayWithArray:nConfig.protocolClasses];
//        if ([protocolList containsObject:[HtmlURLProtocol class]]) {
//            [protocolList insertObject:[HtmlURLProtocol class] atIndex:0];
//            nConfig.protocolClasses = protocolList;
//        }
//    }
}

-(void)removeHtmlProtocolSeesionConfiguration{
//    NSURLSessionConfiguration *nConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    if (nConfig) {
//        NSMutableArray *protocolList = [NSMutableArray arrayWithArray:nConfig.protocolClasses];
//        if ([protocolList containsObject:[HtmlURLProtocol class]]) {
//            [protocolList removeObject:[HtmlURLProtocol class]];
//            nConfig.protocolClasses = protocolList;
//        }
//    }
}

- (NSMutableURLRequest *)convertHostForRequest:(NSURLRequest *)request isWebUrl:(BOOL)isWebUrl{
    NSMutableURLRequest *mReq = [request mutableCopy];
    if (self.domainDic.count == 0) {
        return mReq;
    }
//    if(isWebUrl){
//        if (![CCCandyWebCache defaultWebCache].offlineEnable) {
//            //未开启离线模式，weburl不替换
//            return mReq;
//        }
//    }
    NSString *urlString = [self convertHostForURL:[mReq URL]];
    if (urlString) {
        NSURL *url = [NSURL URLWithString:urlString];
//        if (url && ![url.absoluteString containsString:@"gw/app/startUpConfig"]) {
        if (url) {
            [mReq setURL:url];
        }
    }
    return mReq;
}

- (NSString *)convertHostForURL:(NSURL *)URL{
    if(!URL){
        return nil;
    }
    NSString *replacedHost = [self convertHost:URL.host];

    if (replacedHost.length > 0) {
        NSRange hostFirstRange = [URL.absoluteString rangeOfString:URL.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString *newUrl = [URL.absoluteString stringByReplacingCharactersInRange:hostFirstRange withString:replacedHost];
            return newUrl;
        }
    }else{
        [self reportEventWithUrl:URL.absoluteString];
    }
    return URL.absoluteString;
}

-(void)reportEventWithUrl:(NSString*)url{
    if ([self canUseNewDomain] && self.switchStatus == 1 && ([url containsString:@"to8to.com"] || [url containsString:@"t8tcdn.com"])) {
        NSString *host = [NSURL URLWithString:url].host;
        if (host.length == 0) {
            return;
        }
        if (!([host containsString:@"to8to.com"] || [host containsString:@"t8tcdn.com"])) {//host不包含这2个，不做记录
            return;
        }
        //防止死循环，发起埋点请求时，发现未匹配，又发起请求了
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            if ([self.reportArray containsObject:host]) { //已上传
//                return;
//            }
//            AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
//            NSDictionary *properties = @{@"page_uid" : kUnNilStr(appDelegate.topViewController.gePageUid),
//                                         @"page_url" : kUnNilStr(url),
//            };
//            [self.reportArray safeAddObject:host];
//            [GECommonEventTracker reportEvent:@"appPageLoad" properties:properties];
//        }];
    }
}
/// 域名转换
/// @param urlString url字符串
- (NSString *)convertHostForUrlString:(NSString *)urlString isWebUrl:(BOOL)isWebUrl{
//    if(isWebUrl){
//        if (![CCCandyWebCache defaultWebCache].offlineEnable) {
//            //未开启离线模式，weburl不替换
//            return urlString;
//        }
//    }
    if (urlString.length == 0) {
        return urlString;
    }
    NSURL *URL = [NSURL URLWithString:urlString];
    if (!URL) {
        return urlString;
    }

    return [self convertHostForURL:URL];
}

/// host转换
/// @param host url字符串
- (NSString *)convertHost:(NSString *)host{
    if (host.length == 0) {
        return nil;
    }
    if (![self.domainDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (![self canUseNewDomain]) {
        return nil;
    }
    NSString *newHost = self.domainDic[host];
    if (!newHost && [host containsString:@"to8to"]) {
        //没匹配到，可能是城市相关的域名bj.to8to.com // http://bj.to8to.com/zs/1148888
        //做特殊处理
        NSArray *array = [host componentsSeparatedByString:@"."];
        if (array.count == 3) {
            //to8to.com
            NSString *secondHost = [self getSecondLevelDomainWithHost:host];

            //huhudi.com
            NSString *replaceHost = self.domainDic[secondHost];

            if (replaceHost.length >= 1) {//如果能替换
                //host bj.to8to.com
                newHost = [host stringByReplacingOccurrencesOfString:secondHost withString:replaceHost];
            }
        }
    }
    return newHost;
}

/// 获取host的域名
/// @param host
-(NSString*)getSecondLevelDomainWithHost:(NSString*)host{
    NSArray *array = [host componentsSeparatedByString:@"."];
    if (array.count == 2) {
        return host;
    }else if (array.count == 3){
        NSRange range = [host rangeOfString:@"."];
        if (range.location != NSNotFound) {
            host = [host substringFromIndex:range.location+1];
//            THKDebugLog(@"===>>>>value = %@",host);
            return host;
        }
    }
    return nil;
}

-(BOOL)canUseNewDomain{
    if (self.domainDic.count > 0 && self.useNewDomain) {
        return YES;
    }
    return NO;
}
/// 二级域名domain to8to.com
- (NSString*)secondLevelDomain{
    if ([self canUseNewDomain]) {
        if (self.secondLevelDomainStr) {
            return self.secondLevelDomainStr;
        }
        NSString *value = [[self.domainDic allValues] firstObject];
        value = [self getSecondLevelDomainWithHost:value];
        if (value) {
            self.secondLevelDomainStr = value;
            return value;
        }
    }
    return @"to8to.com";
}

/// 二级域名domain .to8to.com
-(NSString*)secondLevelDomainAndPoint{
    if ([self canUseNewDomain]) {
        if (self.pointSecondLevelDomainStr) {
            return self.pointSecondLevelDomainStr;
        }
        self.pointSecondLevelDomainStr = [@"." stringByAppendingString:[self secondLevelDomain]];
        return self.pointSecondLevelDomainStr;
    }
    return @".to8to.com";
}

/// 域名的二级的字符串
-(NSString*)domainSecondString{
    if ([self canUseNewDomain]) {
        if (self.secondDomainStr) {
            return self.secondDomainStr;
        }
        NSString *value = [[self.domainDic allValues] firstObject];
        NSArray* array = [value componentsSeparatedByString:@"."];
        if (array.count == 3) {
            self.secondDomainStr = array[1];
            return array[1];
        }else if (array.count == 2) {
            self.secondDomainStr = array[0];
            return array[0];
        }
    }
    return @"to8to";
}

/// 是否需要配置请求的ip
//-(BOOL)needConfigRequestIPForUrl:(NSString*)url{
//    return [[THKIdentityConfigManager shareInstane] needConfigRequestIPForUrl:url];
//}

-(BOOL)needConvertUrl{
    if (self.switchStatus == 1 && self.domainDic.count >= 1) {
        return YES;
    }
    return NO;
}

-(NSMutableArray *)reportArray{
    if (!_reportArray) {
        _reportArray = [[NSMutableArray alloc] init];
    }
    return _reportArray;
}

/// 转换web资源的url
/// @param webUrl
-(NSString*)convertWebResourceUrl:(NSString*)webUrl{
//    if (![CCCandyWebCache defaultWebCache].offlineEnable) {
//        //未开启离线模式
//        return webUrl;
//    }
    if (webUrl.length == 0) {
        return webUrl;
    }
    NSString *host = [webUrl componentsSeparatedByString:@"/"].firstObject;
    NSString *newHost = [self.webDomainDic objectForKey:host];
    if (newHost.length > 0) {
        return [webUrl stringByReplacingOccurrencesOfString:host withString:newHost];
    }
    return webUrl;
}
@end
