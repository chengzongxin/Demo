//
//  THKDecPKViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import "THKDecPKViewModel.h"

@implementation THKDecPKViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self didInitailze];
    }
    return self;
}

- (void)didInitailze{
    self.firstTitle = @"PK出图流程";
    self.firstButtonTip = @"了解详情";
    
    self.secondTitle = @"在线PK装修公司";
    self.secondButtonTip = @"3大项pk对比";
    
    self.bigButtonTip = @"上门量房 PK出效果图";
    self.bottomTip = @"为什么出效果图之前，要先上门量房 >";
    
//    NSMutableArray *arr = [NSMutableArray array];
    
    THKDecPKCompanyModel *m1 = [THKDecPKCompanyModel new];
    m1.decIcon = @"";
    m1.decName = @"居众装饰";
    m1.score = 4;
    m1.consultNum = 100;
    m1.caseNum = 210;
    
    THKDecPKCompanyModel *m2 = [THKDecPKCompanyModel new];
    m2.decIcon = @"";
    m2.decName = @"东易日盛";
    m2.score = 5;
    m2.consultNum = 110;
    m2.caseNum = 230;
    
    THKDecPKCompanyModel *m3 = [THKDecPKCompanyModel new];
    m3.decIcon = @"";
    m3.decName = @"星艺装饰";
    m3.score = 6;
    m3.consultNum = 130;
    m3.caseNum = 220;
    
    self.secondContent = @[m1,m2,m3];
}

@end


@implementation THKDecPKCompanyModel

@end
