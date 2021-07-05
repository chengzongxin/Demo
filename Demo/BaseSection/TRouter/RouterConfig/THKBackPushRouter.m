//
//  THKBackPushRouter.m
//  HouseKeeper
//
//  Created by 彭军 on 2019/11/7.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKBackPushRouter.h"

@implementation THKBackPushRouter
- (NSNumber *)transitionStyle {
    return @(TransitionStylePopOrPushIsExist);
}

@end
