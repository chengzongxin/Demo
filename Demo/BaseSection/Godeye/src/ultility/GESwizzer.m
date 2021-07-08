//
//  GESwizzer.m
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import "GESwizzer.h"
#import <objc/runtime.h>

void swizzInstanceMethod(Class class, SEL originSelector, SEL swizzlingSelector)
{
    Method orgMethod = class_getInstanceMethod(class, originSelector);
    Method swzMethod = class_getInstanceMethod(class, swizzlingSelector);
    if (class_addMethod(class, originSelector, method_getImplementation(swzMethod), method_getTypeEncoding(swzMethod))) {
        class_replaceMethod(class, swizzlingSelector, method_getImplementation(orgMethod), method_getTypeEncoding(orgMethod));
    } else {
        method_exchangeImplementations(orgMethod, swzMethod);
    }
}
