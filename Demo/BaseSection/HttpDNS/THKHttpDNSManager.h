////
////  THKHttpDNSManager.h
////  HouseKeeper
////
////  Created by collen.zhang on 2021/4/7.
////  Copyright © 2021 binxun. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface THKHttpDNSManager : NSObject
//
//+ (THKHttpDNSManager *)shareInstane;
//
/////使用新域名 --> 用于雷达工具
//@property (nonatomic, assign) BOOL useNewDomain;
//
//- (void)configDomainDic:(NSDictionary*)dic;
//
//- (void)configDomainSwitch:(NSInteger)switchStatus;
//
///// 域名转换
///// @param request 请求
//- (NSMutableURLRequest *)convertHostForRequest:(NSURLRequest *)request isWebUrl:(BOOL)isWebUrl;
//
///// 域名转换
///// @param urlString url字符串
///// @param isWebUrl 是否是web的url
//- (NSString *)convertHostForUrlString:(NSString *)urlString isWebUrl:(BOOL)isWebUrl;
//
///// host转换
///// @param host url字符串
//- (NSString *)convertHost:(NSString *)host;
//
///// 匹配失败，上报埋点事件
///// @param url 链接
//-(void)reportEventWithUrl:(NSString*)url;
//
///// 二级域名domain to8to.com
//- (NSString*)secondLevelDomain;
//
///// 二级域名domain .to8to.com
//- (NSString*)secondLevelDomainAndPoint;
//
///// 域名的二级的字符串 to8to
//- (NSString*)domainSecondString;
//
///// 转换web资源的url
///// @param webUrl 
//-(NSString*)convertWebResourceUrl:(NSString*)webUrl;
//
///// 是否需要配置请求的ip
//-(BOOL)needConfigRequestIPForUrl:(NSString*)url;
//
///// 是否需要域名替换
//-(BOOL)needConvertUrl;
//
//@end
//
//NS_ASSUME_NONNULL_END
