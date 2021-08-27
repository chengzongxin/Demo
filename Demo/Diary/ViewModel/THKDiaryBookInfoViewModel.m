//
//  THKDiaryBookInfoViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import "THKDiaryBookInfoViewModel.h"

@interface THKDiaryBookInfoViewModel ()
/// 封面图
@property (nonatomic, strong) NSString *coverImgUrl;
/// 日记本标题
@property (nonatomic, strong) NSAttributedString *titleAttr;
/// 房屋信息
@property (nonatomic, strong) NSAttributedString *houseInfoAttr;
/// 装修清单
@property (nonatomic, assign) BOOL hasShoppingList;
/// 公司信息
@property (nonatomic, strong) NSAttributedString *companyInfoAttr;

// localData
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *houseCity;
@property (nonatomic, strong) NSString *houseStyle;
@property (nonatomic, assign) double houseBudget;
@property (nonatomic, assign) double houseArea;
@property (nonatomic, strong) NSString *shoppingList;
@property (nonatomic, strong) NSString *companyInfo;

@end

@implementation THKDiaryBookInfoViewModel

- (void)initialize{
    self.coverImgUrl = @"https://img1.baidu.com/it/u=3366246598,2446278796&fm=26&fmt=auto&gp=0.jpg";
    self.title = @"王沫沫现实与梦想的家居改造计划,王沫沫现实与梦想的家居改造计划,王沫沫现实与梦想的家居改造计划";
    self.houseCity = @"深圳";
    self.houseStyle = @"北欧";
    self.houseBudget = 65;
    self.houseArea = 99;
    self.hasShoppingList = YES;
    self.companyInfo = @"圳星装饰";
    
    [self bindWithModel:nil];
}

- (void)bindWithModel:(id)model{
    [super bindWithModel:model];
    
    self.titleAttr = [self generateTitleAttr];
    self.houseInfoAttr = [self generateHouseInfoAttr];
    self.companyInfoAttr = [self generateCompanyInfoAttr];
}

- (NSAttributedString *)generateTitleAttr{
    return [NSAttributedString tmui_attributedStringWithString:self.title font:UIFontMedium(20) color:UIColorHex(111111) lineSpacing:4];
//
//
//    NSMutableAttributedString *attrStr = [[NSAttributedString tmui_attributedStringWithString:self.title font:UIFontMedium(20) color:UIColorHex(111111)] mutableCopy];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 4;
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    [attrStr tmui_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
//    return attrStr;
}

- (NSAttributedString *)generateHouseInfoAttr{
    NSMutableArray *houseInfoArr = [NSMutableArray array];
    
    if (self.houseCity.length) {
        [houseInfoArr addObject:self.houseCity];
    }
    if (self.houseStyle.length) {
        [houseInfoArr addObject:self.houseStyle];
    }
    if (self.houseBudget) {
        [houseInfoArr addObject:[NSString stringWithFormat:@"%.0f万",self.houseBudget]];
    }
    if (self.houseArea) {
        [houseInfoArr addObject:[NSString stringWithFormat:@"%.0fm²",self.houseArea]];
    }
    
//    if (self.detailData.bookInfo.cityName.length > 0) {
//        [tmpLs addObject:self.detailData.bookInfo.cityName];
//    }
//    if (self.detailData.bookInfo.houseTypeName.length > 0) {
//        [tmpLs addObject:self.detailData.bookInfo.houseTypeName];
//    }
//    if (self.detailData.bookInfo.budget > 0) {
//        [tmpLs safeAddObject:[NSString stringWithFormat:@"%.0f万",self.detailData.bookInfo.budget]];
//    }
//    if (self.detailData.bookInfo.styleName.length > 0) {
//        [tmpLs addObject:self.detailData.bookInfo.styleName];
//    }
//    if (self.detailData.bookInfo.area > 0) {
//        [tmpLs addObject:[NSString stringWithFormat:@"%@m²", @(self.detailData.bookInfo.area)]];
//    }
    
    //按设计稿需要文本和分隔线的显示效果需要富文本样式才能支持
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *normalDic = @{NSFontAttributeName: UIFont(12),
                            NSForegroundColorAttributeName: UIColorHexString(@"999999"),
                            NSParagraphStyleAttributeName: paragraphStyle
    };
    NSDictionary *lineDic = @{NSFontAttributeName: UIFont(8),
                            NSForegroundColorAttributeName: [UIColorHexString(@"666666") colorWithAlphaComponent:0.5],
                            NSParagraphStyleAttributeName: paragraphStyle,
                              NSBaselineOffsetAttributeName: @(0.36 * (12-8))
    };
    NSMutableAttributedString *houseInfoAttr = nil;
    if (houseInfoArr.count > 0) {
        houseInfoAttr = [[NSMutableAttributedString alloc] initWithString:@""];
        for (NSInteger i = 0; i < houseInfoArr.count; ++i) {
            if (i != 0) {
                NSAttributedString *lineStr = [[NSAttributedString alloc] initWithString:@"  |  " attributes:lineDic];
                [houseInfoAttr appendAttributedString:lineStr];
            }
            NSAttributedString *normalStr = [[NSAttributedString alloc] initWithString:houseInfoArr[i] attributes:normalDic];
            [houseInfoAttr appendAttributedString:normalStr];
        }
    }
    return houseInfoAttr;
}

- (NSAttributedString *)generateCompanyInfoAttr{
    NSString *companyInfo = self.companyInfo;
    
    NSMutableAttributedString *companyInfoAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *tips = [NSAttributedString tmui_attributedStringWithString:@"设计与施工：" font:UIFont(12) color:UIColorHex(999999)];
    NSAttributedString *company = [NSAttributedString tmui_attributedStringWithString:[NSString stringWithFormat:@"%@",companyInfo] font:UIFont(12) color:UIColorHex(1A1C1A)];
    NSAttributedString *arrow = [NSAttributedString tmui_attributedStringWithImage:UIImageMake(@"diary_arrow_icon")];
    [companyInfoAttr appendAttributedString:tips];
    [companyInfoAttr appendAttributedString:company];
    [companyInfoAttr appendAttributedString:arrow];
    return companyInfoAttr;
}


@end
