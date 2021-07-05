//
//  TRouter.m
//  Example
//
//  Created by 彭军 on 2019/4/29.
//  Copyright © 2019 to8to. All rights reserved.
//

#import "TRouter.h"
#import "TRouterManager.h"
#import "TRuntimeHelper.h"

TRouterPath  const TRouterPage_WebView = @"/common/webview";

@implementation TRouter

/**
 通过参数构建一个router
 
 @param routeName 路由名称
 @return router
 */
+ (instancetype)routerWithName:(TRouterPath)routeName{
    Class subClass = [[TRouterManager sharedManager].config routeSubClassForRouteName:routeName];
    TRouter *router = [[subClass alloc] init];
    router.routeName = routeName;
    return router;
    
}

+ (instancetype)routerWithName:(TRouterPath)routeName param:(NSDictionary *)param jumpController:(UIViewController*)jumpController{
    Class subClass = [[TRouterManager sharedManager].config routeSubClassForRouteName:routeName];
    TRouter *router = [[subClass alloc] init];
    router.routeName = routeName;
    router.param = param;
    router.jumpController = jumpController;
    return router;
}

/**
 通过参数构建一个router
 
 @param routeName 路由名称
 @param runtimeParam 页面对应参数，自动赋值
 @param jumpController 跳转的控制器
 @return router
 */
+ (instancetype)routerWithName:(TRouterPath)routeName runtimeParam:(NSDictionary *)runtimeParam jumpController:(UIViewController*)jumpController{
    Class subClass = [[TRouterManager sharedManager].config routeSubClassForRouteName:routeName];
    TRouter *router = [[subClass alloc] init];
    router.routeName = routeName;
    router.runtimeParam = runtimeParam;
    router.jumpController = jumpController;
    return router;
}


+ (instancetype)routerFromUrl:(NSString *)routerUrl{
    
    return [self routerFromUrl:routerUrl jumpController:nil];
}

+ (instancetype)routerFromUrl:(NSString *)routerUrl jumpController:(UIViewController*)jumpController{
    
    TRouterPath routeName = nil;
    TRouter *router = nil;
    NSDictionary *param = nil;
    if (!routerUrl.length) {
        return nil;
    }
    //去除收尾空格
    routerUrl = [routerUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:routerUrl];
    if (!url) {
        //对url取得query进行encode，防止中文以及特殊字符导致创建url为空；
        NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *encodeUrl = [routerUrl stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
        url = [NSURL URLWithString:encodeUrl];
        if (!url) {
            return nil;
        }
    }
    NSLog(@"TRouter:-- \n scheme:%@ \n host:%@ \n path:%@ \n query:%@",url.scheme,url.host,url.path,url.query?:@"");
    
    NSString *scheme = url.scheme;
    NSString *query = url.query;
    NSString *host = url.host;
    routeName = url.path;
    
    if (![TRouterManager sharedManager].scheme) {
        NSAssert(NO, @"TRouter:--未注册路由协议scheme");
    }
    
    if (![TRouterManager sharedManager].hosts.count) {
        NSAssert(NO, @"TRouter:--未注册路由协议host");
    }
    
    if ([scheme hasPrefix:@"http"]) {
        routeName = TRouterPage_WebView;
        param = @{@"url":routerUrl};
    }else{
        
        if (![scheme isEqualToString:[TRouterManager sharedManager].scheme]) {
            NSLog(@"TRouter:-- 路由协议scheme与注册的scheme不一致！");
            return nil;
        }
        if (![[TRouterManager sharedManager].hosts containsObject:host]) {
            NSLog(@"TRouter:--路由协议hosts与注册的host不一致,或者未注册！");
            return nil;
        }
        
        if (query && query.length) {
            param = [self dictionaryFromQuery:query];
        }
    }
    
    Class subClass = [[TRouterManager sharedManager].config routeSubClassForRouteName:routeName];
    router = [[subClass alloc] init];
    router.routeName = routeName;
    router.param = param;
    router.routerUrl = routerUrl;
    router.jumpController = jumpController;
    return router;
}


/**
 执行跳转
 
 @return <#return value description#>
 */
-(BOOL)perform{
    return [[TRouterManager sharedManager] performRouter:self];
}


/**
获取目的对象

@return
*/
-(id)build{
    if (self.routeName.length) {
        return [[TRouterManager sharedManager] createTargetForRouter:self];
    }else{
        NSLog(@"TRouter:-- 路由Path为空！");
        return nil;
    }
}


/**
 将query参数转成NSDictionary
 
 @param query url参数
 @return NSDictionary
 */
+ (NSDictionary*)dictionaryFromQuery:(NSString*)query
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray<NSString *> *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count >= 2) {
            NSString* key = [[kvPair objectAtIndex:0] stringByRemovingPercentEncoding];
            NSString* value = nil;
            if (kvPair.count == 2) {
                value = [[kvPair objectAtIndex:1] stringByRemovingPercentEncoding];
            }else {
                //若count > 2，则表示value串里可能也会含有=符号，这里直接按"key=value"构建顺序，从原串里舍弃前key.length+1的长度串即可
                value = [[pairString substringFromIndex:([kvPair objectAtIndex:0].length+1)] stringByRemovingPercentEncoding];
            }
            if (value) {
                value = [value stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                [pairs setObject:value forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}


/**
 runtime设置给目标对象
 
 @param object <#object description#>
 */
- (void)setValuesForObject:(id)object {
    if (self.runtimeParam && object) {
        for (id key in self.runtimeParam.allKeys) {
            if (![key isKindOfClass:[NSString class]]) {
                NSCAssert(NO, @"key:%@ 不是字符串",key);
                continue;
            }
            if (![TRuntimeHelper isClass:[object class] hasProperty:key]) {
                NSCAssert(NO, @"key:%@ 不存在 ",key);
                continue;
            }
            
            id value = [self.runtimeParam objectForKey:key];
            NSError *error = nil;
            if (![object validateValue:&value forKey:key error:&error]) {
                NSCAssert(NO, @"value:%@ 类型错误,key:%@",value,key);
                continue;
            } else {
                [object setValue:value forKey:key];
            }
        }
    }
}


/**
 路由名称匹配
 
 @param routerName 路由名
 @return YES:NO
 */
- (BOOL)routerMatch:(TRouterPath)routerName{
    
    if (self.routeName && [self.routeName isEqualToString:routerName]) {
        return YES;
    }
    return NO;
}

/**
 判断传入url是否支持路由协议
 
 @param url <#url description#>
 @return <#return value description#>
 */
+ (BOOL)isRouterUrl:(id)routerUrl{
    
    NSURL *baseUrl;
    if ([routerUrl isKindOfClass:[NSString class]]) {
        //对url取得query进行encode，防止中文以及特殊字符导致创建url为空；
        NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *encodeUrl = [routerUrl stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
        baseUrl = [NSURL URLWithString:encodeUrl];
    }else if ([routerUrl isKindOfClass:[NSURL class]]){
        baseUrl = routerUrl;
    }
    
    if (baseUrl && [baseUrl.scheme isEqualToString:[TRouterManager sharedManager].scheme] &&
        [[TRouterManager sharedManager].hosts containsObject:baseUrl.host])
    {
        return YES;
    }
    return NO;
}

/**
 判断该路由是否支持跳转（当前版本是否实现了该路由协议）
 
 @param routerUrl <#routerUrl description#>
 @return <#return value description#>
 */
+ (BOOL)canRouter:(id)routerUrl{
    return [[TRouterManager sharedManager] canRouter:routerUrl];
}

@end
