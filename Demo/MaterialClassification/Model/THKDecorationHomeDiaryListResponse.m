//
//  THKDecorationHomeDiaryListResponse.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/5/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKDecorationHomeDiaryListResponse.h"

@implementation THKDecorationHomeDiaryListResponse
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data": @"THKDecorationDiaryListModel"};
}
@end


@implementation THKDecorationDiaryBookInfo
@end


@implementation THKDecorationDiaryUserInfo
@end


@implementation THKDecorationDiaryCompanyInfo
@end


@implementation THKDecorationDiaryImages
@end


@implementation THKDecorationDiaryDiaryInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"images":@"THKDecorationDiaryImages"};
}
@end


@implementation THKDecorationDiaryListModel

//
//- (NSAttributedString *)houseInfoAttrString{
//    if (_houseInfoAttrString == nil) {//由依次显示城市、户型、预算、风格、面积，无数据的部分则不显示: 深圳/三居/6万/简约/128m²
//        NSMutableArray *items = [NSMutableArray array];
////        if (kUnNilStr(self.cityName).length > 0) {
////            [items safeAddObject:self.cityName];
////        }
//        if (self.bookInfo.budget > 0) {
//            [items safeAddObject:[NSString stringWithFormat:@"%.0ld万",(long)self.bookInfo.budget]];
//        }
//
//        if (kUnNilStr(self.bookInfo.styleName).length > 0) {
//            [items safeAddObject:self.bookInfo.styleName];
//        }
//        if (self.bookInfo.area > 0) {
//            [items safeAddObject:[NSString stringWithFormat:@"%.0ldm²",(long)self.bookInfo.area]];
//        }
//
//        //按设计稿需要文本和分隔线的显示效果需要富文本样式才能支持
//        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
//        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//        paragraphStyle.alignment = NSTextAlignmentCenter;
//        NSDictionary *normalDic = @{NSFontAttributeName: UIFont(12),
//                                    NSForegroundColorAttributeName: UIColorHexString(@"999999"),
//                                    NSParagraphStyleAttributeName: paragraphStyle
//        };
//        NSDictionary *lineDic = @{NSFontAttributeName: UIFont(8),
//                                  NSForegroundColorAttributeName: [UIColorHexString(@"666666") colorWithAlphaComponent:0.5],
//                                  NSParagraphStyleAttributeName: paragraphStyle,
//                                  NSBaselineOffsetAttributeName: @(0.36 * (12-8))
//        };
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@""];;
//        if (items.count > 0) {
//            for (NSInteger i = 0; i < items.count; ++i) {
//                if (i != 0) {
//                    NSAttributedString *lineStr = [[NSAttributedString alloc] initWithString:@"  |  " attributes:lineDic];
//                    [attrStr appendAttributedString:lineStr];
//                }
//                NSAttributedString *contentStr = [[NSAttributedString alloc] initWithString:items[i] attributes:normalDic];
//                [attrStr appendAttributedString:contentStr];
//            }
//        }
//        _houseInfoAttrString =  attrStr;
//    }
//    return _houseInfoAttrString;
//}
//
//- (void)setIsContentAllShow:(BOOL)isContentAllShow{
//    _isContentAllShow = isContentAllShow;
//
//    if (isContentAllShow) {
//        // 清空已有的，以便重新计算
//        _contentAttrString = nil;
//    }
//}
//
//- (NSAttributedString *)contentAttrString{
//    if (_contentAttrString == nil) {
//        CGFloat contentWidth = kMainScreenWidth - 32;
//
//        NSString *tagN = self.diaryInfo.stageBigName;
//        NSString *tagStr;
//        if ([tagN isKindOfClass:NSString.class] && tagN.length > 0) {
//            tagStr = [NSString stringWithFormat:@"#%@#  ",tagN];
//        }else{
//            tagStr = @"";
//        }
//        NSString *contentStr = [self.diaryInfo.content tmui_trim];
//
//        NSString *allStr = [NSString stringWithFormat:@"%@%@",tagStr,contentStr];
//
//        if (self.isContentAllShow == NO) {
//            NSArray *lines = [self getLinesArrayOfStringInLabel:allStr font:UIFont(16) andLableWidth:contentWidth];
//    //        NSLog(@"lines = %@",lines);
//
//            // 只显示3行文字
//            NSInteger limitLine = 3;
//            NSString *dotStr = @"...    ";
//            if (lines.count > limitLine) {
//                self.isFold = YES;
//                NSMutableString *foldStr = [NSMutableString string];
//                for (int i = 0; i < limitLine; i++) {
//                    NSString *lineStr = lines[i];
//                    if (i == limitLine - 1) {
//                        // 最后一行，铺满需要截取
//                        CGFloat width = [lineStr tmui_widthForFont:UIFont(16)];
//                        if (width > contentWidth - 32) {
//                            lineStr = [lineStr stringByReplacingCharactersInRange:NSMakeRange(lineStr.length - dotStr.length, dotStr.length) withString:dotStr];
//                        }
//                    }
//                    [foldStr appendString:lineStr];
//                }
//                allStr = [foldStr tmui_trim]; // 去掉尾部换行符
//            }
//        }else{
//            self.isFold = NO;
//        }
//
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//        [paragraphStyle setLineSpacing:3];// 调整行间距
//
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSForegroundColorAttributeName:UIColorHex(#1A1C1A),NSFontAttributeName:UIFont(16),NSParagraphStyleAttributeName:paragraphStyle}];
//        [attr addAttributes:@{NSForegroundColorAttributeName:THKColor_999999,NSFontAttributeName:UIFontMedium(16)} range:[allStr rangeOfString:tagStr]];
//        _contentAttrString = attr;
//    }
//    return _contentAttrString;
//}
//
//
//- (NSArray *)getLinesArrayOfStringInLabel:(NSString *)string font:(UIFont *)font andLableWidth:(CGFloat)lableWidth{
//
//    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
//    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
//    CFRelease(myFont);
//    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(0,0,lableWidth,100000));
//    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
//    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
//    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
//    for (id line in lines) {
//        CTLineRef lineRef = (__bridge  CTLineRef )line;
//        CFRange lineRange = CTLineGetStringRange(lineRef);
//        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
//        NSString *lineString = [string substringWithRange:range];
//        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
//        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
//        [linesArray addObject:lineString];
//    }
//
//    CGPathRelease(path);
//    CFRelease( frame );
//    CFRelease(frameSetter);
//    return (NSArray *)linesArray;
//}


@end

