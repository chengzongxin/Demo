//
//  TPushRouter.m
//  Example
//
//  Created by 彭军 on 2019/4/29.
//  Copyright © 2019 to8to. All rights reserved.
//

#import "TPushRouter.h"

@implementation TPushRouter

- (NSNumber *)transitionStyle {
    if (!_transitionStyle) {
        _transitionStyle =  @(TransitionStyleNormalPush);
    }
    return _transitionStyle;
}
@end
