//
//  TBTNetworkConfig.m
//  TBTNetwork
//
//  Created by 荀青锋 on 2019/6/27.
//

#import "TBTNetworkConfig.h"
#import <AFNetworking/AFSecurityPolicy.h>

@interface TBTNetworkConfig ()

@end

@implementation TBTNetworkConfig

+ (TBTNetworkConfig *)sharedConfig {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultConfig];
    }
    return self;
}

- (void)initDefaultConfig {
    // 配置网络请求隐私策略
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    self.debugLogEnabled = YES;
    self.securityPolicy  = securityPolicy;
    self.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",
                                                        @"text/plain",
                                                        @"text/json",
                                                        @"application/json",
                                                        @"text/javascript"]];
}

@end
