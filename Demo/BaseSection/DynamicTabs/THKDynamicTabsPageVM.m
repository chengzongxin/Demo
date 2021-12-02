//
//  THKDynamicTabsPageVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import "THKDynamicTabsPageVM.h"

@interface THKDynamicTabsPageVM ()

@end

@implementation THKDynamicTabsPageVM

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageScrollEnabled = YES;
        _isEnableInfiniteScroll = NO;
    }
    return self;
}

- (void)setIsEnableInfiniteScroll:(BOOL)isEnableInfiniteScroll{
    _isEnableInfiniteScroll = isEnableInfiniteScroll;
}

@end
