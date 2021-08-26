//
//  THKDiaryBookCellVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import "THKDiaryBookCellVM.h"

@interface THKDiaryBookCellVM ()

@property (nonatomic, strong) NSString *model;

@end

@implementation THKDiaryBookCellVM
@dynamic model;
- (void)initialize{
    
    NSLog(@"ddd %@",self.model);
}

@end
