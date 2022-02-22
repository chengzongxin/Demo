//
//  THKNewcomerHomeViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKNewcomerHomeViewModel.h"

@interface THKNewcomerHomeViewModel ()

@property (nonatomic, strong) RACSubject *skipSignal;

@end

@implementation THKNewcomerHomeViewModel


TMUI_PropertyLazyLoad(RACSubject, skipSignal)

@end
