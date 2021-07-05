//
//  TRouterManager.m
//  Example
//
//  Created by 彭军 on 2019/4/29.
//  Copyright © 2019 to8to. All rights reserved.
//

#import "TRouterManager.h"
#import "TRuntimeHelper.h"
#import "TRouterConfig.h"
#import "TPushRouter.h"
@interface TRouterManager ()
@property (nonatomic, strong) NSArray *routerClasses;
@property (nonatomic, strong) NSCache *classMapCache;
@end


@implementation TRouterManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static TRouterManager *s_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        s_sharedInstance = [[TRouterManager alloc] init];
    });
    return s_sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //动态获取所有遵循了TRouterProtocol的类
        _routerClasses = [TRuntimeHelper getClassesThatConfirmToProtocol:@protocol(TRouterProtocol)];
        _classMapCache = [[NSCache alloc] init];
        TRouterConfig *config = [[TRouterConfig alloc] init];
        _config = config;
        _hosts = [NSArray array];
    }
    return self;
}

- (void)registerScheme:(NSString *)scheme{
    _scheme = scheme;
}

- (void)registerHost:(NSString *)host{
    NSMutableArray *oldHosts = [self.hosts mutableCopy];
    [oldHosts addObject:host];
    _hosts = oldHosts;
}


/**
 *  执行路由跳转
 *
 *  @param router 路由参数model
 *  @return BOOL 是否成功跳转，返回NO代表未跳转或先跳到了其他页面，等待用户操作后才可以跳转到指定页面
 */
- (BOOL)performRouter:(TRouter *)router{
    
    if (!router) {
        return NO;
    }

    BOOL (^routerAction)(TRouter *router) = ^(TRouter *router){
        Class routerClass = [self findClassForRouter:router];
        if (routerClass) {
            [self performRouter:router withClass:routerClass];
            return YES;
        } else {
            //获取APP通用升级页面的路由
            TRouter *upgradeRouter;
            if (self.upgradeRouterDataSource) {
                upgradeRouter = self.upgradeRouterDataSource();
            }
            if(!upgradeRouter){
                return NO;
            }
            Class upgradeRouterClass = [self findClassForRouter:upgradeRouter];
            if (upgradeRouterClass) {
                [self performRouter:upgradeRouter withClass:upgradeRouterClass];
                return YES;
            } else {
                return NO;
            }
        }
    };
    
    if (router.needlogin || [self.config isNeedLogin:router]) {
        //因为走登录流程，被打断，所有返回值默认为NO；
        [self handleLoginWithRouter:router afterLogin:^(TRouter *crouter) {
            routerAction(crouter);
        }];
        
    }else{
        return routerAction(router);
    }
    
    return NO;
}

- (BOOL)performRouter:(TRouter *)router withClass:(Class)routerClass {
    //创建视图控制器，并对其属性进行赋值
    id target = [self createTargetForRouter:router withClass:routerClass];
    
    //处理各个页面特殊的操作,CustomAction必须要实现此方法
    if ([routerClass respondsToSelector:@selector(handleRouter:withHandler:)]) {
        [routerClass performSelector:@selector(handleRouter:withHandler:) withObject:router withObject:target];
    }
    
    //执行跳转
    if (target && [target isKindOfClass:[UIViewController class]] && [router isKindOfClass:[TPushRouter class]]) {
        return [self performPushRouter:(TPushRouter *)router withViewController:target];
    }
    return YES;
}

- (BOOL)performPushRouter:(TPushRouter*)router withViewController:(UIViewController *)publicVC {
    
    [self handleJumpController:router];
    
    if (!router.jumpController &&
        ([router isKindOfClass:[TPushRouter class]] && router.transitionStyle.integerValue != TransitionStyleCustom)) {
        NSAssert(NO, @"TRouter:-- jumpController不能为空");
    }
    
    if(router.transitionStyle.integerValue == TransitionStyleCustom){
        //自定义处理
    }else if (router.transitionStyle.integerValue == TransitionStylePresent) {
        [router.jumpController presentViewController:publicVC animated:YES completion:nil];
    }
    //push或pop方式
    else{
        
        UINavigationController *navControl = (UINavigationController *)router.jumpController;
        if (![navControl isKindOfClass:[UINavigationController class]]) {
            NSCAssert(NO, @"TRouter:-- 导航控制器类型不对，应为：UINavigationController!");
            return NO;
        }
        
        //普通推入跳转
        if(router.transitionStyle.integerValue == TransitionStyleNormalPush){
            
            [navControl pushViewController:publicVC animated:YES];
            
        }else if (router.transitionStyle.integerValue == TransitionStylePopOrPushIsExist){
            for (NSInteger i = navControl.viewControllers.count - 1; i >=0; i--) {
                UIViewController *vc = [navControl.viewControllers objectAtIndex:i];
                if ([vc isKindOfClass:[publicVC class]] && [vc respondsToSelector:@selector(canPopFromVC:withRouter:)] ) {
                    BOOL canPop = [vc performSelector:@selector(canPopFromVC:withRouter:) withObject:vc withObject:router];
                    if (canPop) {
                        if (i<=1) {
                            [navControl popToRootViewControllerAnimated:NO];
                        }else{
                            [navControl popToViewController:[navControl.viewControllers objectAtIndex:i-1] animated:NO];
                        }
                    }
                    break;
                }
            }
            [router setValuesForObject:publicVC];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [navControl pushViewController:publicVC animated:YES];
            });
        }
        else {
            NSCAssert(NO, @"TRouter:-- 不支持该类型的跳转!");
            return NO;
        }
        
    }
    return YES;
}


-(void )handleJumpController:(TPushRouter *)router{
    
    if (router.transitionStyle.integerValue == TransitionStyleCustom || router.transitionStyle.integerValue == TransitionStylePresent) {
        //自定义处理跳转/Present方式，判断跳转控制器为空则获取全局的跳转控制器
        if (!router.jumpController) {
            if (self.jumpControllerDataSource) {
                router.jumpController = self.jumpControllerDataSource();
            }
        }
        
    }else{
        //如果是其他push/pop跳转则判断jumpController的类型进行转换，如果为空则取全局跳转控制器
        if ([router.jumpController isKindOfClass:[UINavigationController class]]) {
            
            return;
            
        }else if([router.jumpController isKindOfClass:[UIViewController class]]){
            
            if (router.jumpController.navigationController) {
                router.jumpController = router.jumpController.navigationController;
            }else{
                if (self.jumpControllerDataSource) {
                    router.jumpController = self.jumpControllerDataSource();
                }
            }
        }
        else{
            if (self.jumpControllerDataSource) {
                router.jumpController = self.jumpControllerDataSource();
            }
        }
        
    }

}


/**
 根据跳转的类型创建对应的页面
 
 @param router 路由参数
 @return 返回对应路由控制
 */
- (id)createTargetForRouter:(TRouter *)router{
    
    Class routerTargetClass = [self findClassForRouter:router];
    if (routerTargetClass) {
        id target = [self createTargetForRouter:router withClass:routerTargetClass];
        //处理各个页面特殊的操作,CustomAction必须要实现此方法
        if ([routerTargetClass respondsToSelector:@selector(handleRouter:withHandler:)]) {
            [routerTargetClass performSelector:@selector(handleRouter:withHandler:) withObject:router withObject:target];
        }
        return target;
    }else{
        NSString *error = [NSString stringWithFormat:@"TRouter:--未找到实现该路由PATH：%@",router.routeName];
        NSLog(error);
//        NSAssert(NO, error);
    }
    return nil;
}


/**
 根据router查找对应的类名

 @param router <#router description#>
 @return <#return value description#>
 */
- (Class)findClassForRouter:(TRouter *)router {
    Class cacheClass = [self.classMapCache objectForKey:router.routeName];
    if (cacheClass) {
        //已经缓存的类型，可以直接跳转
        return cacheClass;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
        //未缓存的，先判断该种类型的跳转能被哪个类响应,并缓存下来，再执行跳转
        for (Class<TRouterProtocol> routerClass in self.routerClasses) {
            BOOL canHandle = NO;
            if ([routerClass respondsToSelector:@selector(canHandleRouter:)]) {
                canHandle = [routerClass performSelector:@selector(canHandleRouter:) withObject:router];
            }
            if (canHandle) {
                [self.classMapCache setObject:routerClass forKey:router.routeName];
                return routerClass;
            }
        }
#pragma clang diagnostic pop
    }
    return nil;
}


- (id)createTargetForRouter:(TRouter *)router withClass:(Class)routerTargetClass{
    
    id result;
    //创建页面
    if ([routerTargetClass respondsToSelector:@selector(createVCWithRouter:)]) {
        result = [routerTargetClass performSelector:@selector(createVCWithRouter:) withObject:router];
    }
    //没有实现createVCWithRouter：方法的
    else {
        if (![routerTargetClass respondsToSelector:@selector(handleRouter:withHandler:)]) {
            NSString *error = [NSString stringWithFormat:@"TRouter:-- 路由：%@ 没有实现【createVCWithRouter:】或【handleRouter:withHandler:】方法！",router.routeName];
            NSLog(error);
            NSCAssert(NO, error);
        }
    }
    
    if (result){
        [router setValuesForObject:result];
    }
    
    if (router.routerCallback && [result isKindOfClass:[NSObject class]]) {
        ((NSObject *)result).routerCallback = router.routerCallback;
        router.routerCallback = nil;
    }
    
    return result;
}

- (void)handleLoginWithRouter:(TRouter*)router afterLogin:(void (^)(TRouter *router))completion{
    if (self.doLoginCallback) {
        self.doLoginCallback(router, ^(BOOL result) {
            if (result) {
                completion(router);
            }
        });
    }
    
}

/**
 判断该路由是否支持跳转（当前版本是否实现了该路由协议）
 
 @param routerUrl <#routerUrl description#>
 @return <#return value description#>
 */
- (BOOL)canRouter:(id)routerUrl{
    
    NSURL *baseUrl;
    if ([routerUrl isKindOfClass:[NSString class]]) {
        //对url取得query进行encode，防止中文以及特殊字符导致创建url为空；
        NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *encodeUrl = [routerUrl stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
        baseUrl = [NSURL URLWithString:encodeUrl];
    }else if ([routerUrl isKindOfClass:[NSURL class]]){
        baseUrl = routerUrl;
    }
    
    if (!baseUrl) {
        return NO;
    }
    
    NSString *scheme = baseUrl.scheme.lowercaseString;
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        return YES;
        
    }else if ([baseUrl.scheme isEqualToString:self.scheme] && [self.hosts containsObject:baseUrl.host]){
        //先判断url是否符合协议规则
         TRouter *router = [[TRouter alloc] init];
         router.routeName = baseUrl.path;
         Class class = [self findClassForRouter:router];
         //再查找当前是否有实现该路由path的类
         if (class) {
             return YES;
         }else{
             return NO;
         }
    }else{
         return NO;
    }
   
}
@end
