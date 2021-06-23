//
//  THKCommonJavaRequest.m
//  HouseKeeper
//
//  Created by nigel.ning on 2019/11/8.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKCommonJavaRequest.h"

@implementation THKCommonJavaRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.common_requestType = THKRequestTypeJSON;
        self.common_parameterType = THKParameterTypeArgsWithUrl;
    }
    return self;
}


@end
