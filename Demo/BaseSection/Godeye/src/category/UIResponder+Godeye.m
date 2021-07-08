//
//  UIResponder+Godeye.m
//  Pods
//
//  Created by jerry.jiang on 2018/12/26.
//

#import "UIResponder+Godeye.h"
#import <objc/runtime.h>

@implementation UIResponder (Godeye)

- (NSDictionary *)geResource
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGeResource:(NSDictionary *)geResource
{
    objc_setAssociatedObject(self, @selector(geResource), geResource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
