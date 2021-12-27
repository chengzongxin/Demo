//
//  THKNewcomerStageViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKNewcomerHomeSelectStageViewModel.h"

@interface THKNewcomerHomeSelectStageViewModel ()

@property (nonatomic, strong) RACSubject *skipSignal;

@end

@implementation THKNewcomerHomeSelectStageViewModel


TMUI_PropertyLazyLoad(RACSubject, skipSignal)

@end
