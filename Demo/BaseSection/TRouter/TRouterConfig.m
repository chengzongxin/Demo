//
//  TRouterConfig.m
//  Example
//
//  Created by 彭军 on 2019/4/29.
//  Copyright © 2019 to8to. All rights reserved.
//

#import "TRouterConfig.h"
#import "TPushRouter.h"
@implementation TRouterConfig

- (BOOL)isNeedLogin:(nonnull TRouter *)router {
    return NO;
}

- (nonnull Class)routeSubClassForRouteName:(nonnull NSString *)routeName {
    return [TPushRouter class];
}

@end
