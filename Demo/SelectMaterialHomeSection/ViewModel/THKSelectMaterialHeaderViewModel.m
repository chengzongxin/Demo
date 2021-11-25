//
//  THKSelectMaterialHeaderViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialHeaderViewModel.h"


@interface THKSelectMaterialHeaderViewModel ()

@property (nonatomic, strong) THKMaterialTabEntranceModel *model;

@end

@implementation THKSelectMaterialHeaderViewModel
@dynamic model;

- (void)initialize{
    [super initialize];
    
    NSLog(@"%@",self.model);
}

@end
