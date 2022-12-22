//
//  THKDecPKViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import "THKDecPKViewModel.h"

@interface THKDecPKViewModel ()

@end

@implementation THKDecPKViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self didInitailze];
    }
    return self;
}

- (instancetype)initWithModel:(THKDecPKModel *)model{
    if (self == [super init]) {
        self.model = model;
        [self didInitailze];
    }
    return self;
}

- (void)didInitailze{
//    self.firstTitle = @"PK出图流程";
//    self.firstButtonTip = @"了解详情";
//    
//    self.secondTitle = @"在线PK装修公司";
//    self.secondButtonTip = @"3大项pk对比";
//    
//    self.bigButtonTip = @"上门量房 PK出效果图";
//    self.bottomTip = @"为什么出效果图之前，要先上门量房 >";
//    
////    NSMutableArray *arr = [NSMutableArray array];
//    
//    THKDecPKCompanyModel *m1 = [THKDecPKCompanyModel new];
//    m1.authorAvatar = @"https://pic.to8to.com/live/day_211008/20211008_449e6f68fd7c5501365a307Bg24AJYBH.jpg";
//    m1.authorName = @"居众装饰";
//    m1.goodRate = 40;
//    m1.consultantNum = 70;
//    m1.caseNum = 60;
//    m1.goodRateText = @"评分";
//    m1.caseNumText = @"发布\n案例数";
//    m1.consultantNumText = @"近半年\n咨询人数";
//    
//    THKDecPKCompanyModel *m2 = [THKDecPKCompanyModel new];
//    m2.authorAvatar = @"https://pic.to8to.com/live/day_211008/20211008_449e6f68fd7c5501365a307Bg24AJYBH.jpg";
//    m2.authorName = @"东易日盛";
//    m2.goodRate = 60;
//    m2.consultantNum = 50;
//    m2.caseNum = 80;
//    m2.goodRateText = @"评分";
//    m2.caseNumText = @"发布\n案例数";
//    m2.consultantNumText = @"近半年\n咨询人数";
//    
//    THKDecPKCompanyModel *m3 = [THKDecPKCompanyModel new];
//    m3.authorAvatar = @"https://img.to8to.com/newheadphoto/v2/100/176.jpg?1654855200";
//    m3.authorName = @"星艺装饰";
//    m3.goodRate = 20;
//    m3.consultantNum = 30;
//    m3.caseNum = 80;
//    m3.goodRateText = @"评分";
//    m3.caseNumText = @"发布\n案例数";
//    m3.consultantNumText = @"近半年\n咨询人数";
//    
//    self.secondContent = @[m1,m2,m3];
//    
//    self.companyTexts = @[m1.authorName,m2.authorName,m3.authorName];
    
    

    
#pragma mark - Real Data
    self.firstTitle = self.model.firstTitle;
    self.firstButtonTip = self.model.firstButtonText;
    self.firstButtonTipRouter = self.model.firstButtonRouter;
    self.firstContentImgUrl = self.model.firstImg;
    self.secondTitle = self.model.secondTitle;
    self.secondButtonTip = self.model.secondButtonText;
    self.secondButtonTipRouter = self.model.secondButtonRouter;
    self.bigButtonTip = self.model.bottomButtonText;
    self.bigButtonTipRouter = self.model.bottomTextRouter;
    self.bottomTip = self.model.bottomText;
    
    NSMutableArray *companyInfoList = [NSMutableArray array];
    if (self.model.companyInfoList.count == 2) {
        [companyInfoList addObject:self.model.companyInfoList];
    }else if (self.model.companyInfoList.count == 3) {
        [companyInfoList addObject:@[self.model.companyInfoList[0],self.model.companyInfoList[1]]];
        [companyInfoList addObject:@[self.model.companyInfoList[0],self.model.companyInfoList[2]]];
        [companyInfoList addObject:@[self.model.companyInfoList[1],self.model.companyInfoList[2]]];
    }
    self.secondContent = companyInfoList;
    NSMutableArray *texts = [NSMutableArray array];
    [self.model.companyInfoList enumerateObjectsUsingBlock:^(THKDecPKCompanyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [texts addObject:obj.authorName];
    }];
    self.companyTexts = texts;
    
}

@end
