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
    m1.decIcon = @"https://pic.to8to.com/live/day_211008/20211008_449e6f68fd7c5501365a307Bg24AJYBH.jpg";
    m1.decName = @"居众装饰";
    m1.score = 40;
    m1.consultNum = 70;
    m1.caseNum = 60;
    m1.scoreText = @"评分";
    m1.caseNumText = @"发布\n案例数";
    m1.consultNumText = @"近半年\n咨询人数";
    
    THKDecPKCompanyModel *m2 = [THKDecPKCompanyModel new];
    m2.decIcon = @"https://pic.to8to.com/live/day_211008/20211008_449e6f68fd7c5501365a307Bg24AJYBH.jpg";
    m2.decName = @"东易日盛";
    m2.score = 60;
    m2.consultNum = 50;
    m2.caseNum = 80;
    m2.scoreText = @"评分";
    m2.caseNumText = @"发布\n案例数";
    m2.consultNumText = @"近半年\n咨询人数";
    
    THKDecPKCompanyModel *m3 = [THKDecPKCompanyModel new];
    m3.decIcon = @"https://img.to8to.com/newheadphoto/v2/100/176.jpg?1654855200";
    m3.decName = @"星艺装饰";
    m3.score = 20;
    m3.consultNum = 30;
    m3.caseNum = 80;
    m3.scoreText = @"评分";
    m3.caseNumText = @"发布\n案例数";
    m3.consultNumText = @"近半年\n咨询人数";
    
    self.secondContent = @[m1,m2,m3];
}

@end


@implementation THKDecPKCompanyModel

@end
