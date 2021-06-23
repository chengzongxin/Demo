//
//  NSURLSession+hook_httpdns_urlprotocol_inject.m
//  HouseKeeper
//
//  Created by nigel.ning on 2021/3/1.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "NSURLSession+hook_httpdns_urlprotocol_inject.h"
//#import "NSObject+swizzle.h"
#import <objc/runtime.h>
//#import "HtmlURLProtocol.h"

@implementation NSURLSession (hook_httpdns_urlprotocol_inject)

/// MARK: [NSURLSession sessionWithConfiguration:xx] 最终会触发 [NSURLSession sessionWithConfiguration:xx delegate:nil delegateQueue:nil],所以swizzle第二个api即可

+ (void)load {
    
//    [self exchangeClassMethod:@selector(sessionWithConfiguration:) withClassMethod:@selector(swizzle_httpdns_urlprotocol_sessionWithConfiguration:)];
//    [self exchangeClassMethod:@selector(sessionWithConfiguration:delegate:delegateQueue:) withClassMethod:@selector(swizzle_httpdns_urlprotocol_sessionWithConfiguration:delegate:delegateQueue:)];
    
    ExchangeImplementations(self, @selector(sessionWithConfiguration:delegate:delegateQueue:), @selector(swizzle_httpdns_urlprotocol_sessionWithConfiguration:delegate:delegateQueue:));
}

/*
+ (NSURLSession *)swizzle_httpdns_urlprotocol_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration {
    NSURLSessionConfiguration *nConfig = configuration;
    if (!nConfig) {
        nConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    if (nConfig) {
        NSMutableArray *protocolList = [NSMutableArray arrayWithArray:nConfig.protocolClasses];
        [protocolList insertObject:[THKHttpDNS_CustomURLProtocol class] atIndex:0];
        nConfig.protocolClasses = protocolList;
    }
    
    //
    return [self swizzle_httpdns_urlprotocol_sessionWithConfiguration:nConfig];
}
*/

+ (NSURLSession *)swizzle_httpdns_urlprotocol_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue {
    NSURLSessionConfiguration *nConfig = configuration;
    if (!nConfig) {
        nConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
//    if (nConfig) {
//        NSMutableArray *protocolList = [NSMutableArray arrayWithArray:nConfig.protocolClasses];
//        if (![protocolList containsObject:[HtmlURLProtocol class]]) {
//            [protocolList insertObject:[HtmlURLProtocol class] atIndex:0];
//            nConfig.protocolClasses = protocolList;
//        }
//    }
    
    //
    return [self swizzle_httpdns_urlprotocol_sessionWithConfiguration:nConfig delegate:delegate delegateQueue:queue];
}

@end
