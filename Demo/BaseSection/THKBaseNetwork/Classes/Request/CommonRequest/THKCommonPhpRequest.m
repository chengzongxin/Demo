//
//  THKCommonPhpRequest.m
//  HouseKeeper
//
//  Created by nigel.ning on 2019/11/8.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKCommonPhpRequest.h"

@implementation THKCommonPhpRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.common_requestType = THKRequestTypeHTTP;
        self.common_parameterType = THKParameterTypeDefault;
    }
    return self;
}

@end
