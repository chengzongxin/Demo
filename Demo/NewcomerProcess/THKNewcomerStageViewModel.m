//
//  THKNewcomerStageViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKNewcomerStageViewModel.h"

@interface THKNewcomerStageViewModel ()

@property (nonatomic, strong) RACSubject *skipSignal;

@end

@implementation THKNewcomerStageViewModel


TMUI_PropertyLazyLoad(RACSubject, skipSignal)

@end
