//
//  NSObject+TRouter.m
//  Pods
//
//  Created by 彭军 on 2019/8/20.
//

#import "NSObject+TRouter.h"
#import <objc/runtime.h>

static void *kRouterCallback = "routerCallback";

@implementation NSObject (TRouter)

-(TRouterCallback)routerCallback{
    return objc_getAssociatedObject(self, kRouterCallback);
}

-(void)setRouterCallback:(TRouterCallback)routerCallback{
     objc_setAssociatedObject(self, kRouterCallback, routerCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


@implementation TRouterCallbackData



@end
