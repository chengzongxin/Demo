//
//  THKEntranceViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKEntranceViewModel.h"

@implementation THKEntranceViewModel

- (void)bindWithModel:(id)model{
    [super bindWithModel:model];
    
    self.entranceList = model;
}

@end
