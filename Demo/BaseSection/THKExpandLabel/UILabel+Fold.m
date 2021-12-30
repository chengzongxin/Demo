//
//  UILabel+Fold.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/27.
//

#import "UILabel+Fold.h"

@interface UILabel (Fold)

@property (nonatomic, assign) BOOL isFold;

@end

@implementation UILabel (Fold)


- (void)createFoldString{
//    NSAttributedString *showStr = nil;
//    CGFloat maxWidth = (TMUI_SCREEN_WIDTH - 40);
//    NSAttributedString *unfoldStr = self.unfoldString;
//    UIFont *font = [unfoldStr tmui_font];
//    CGFloat lineGap = [unfoldStr tmui_paragraphStyle].lineSpacing;
//    // 每一行字符数组
//    NSArray *lineStrs = [unfoldStr.string tmui_linesArrayForFont:font maxWidth:maxWidth];
//    
//    NSMutableAttributedString* (^setLineGap)(NSMutableAttributedString*) = ^NSMutableAttributedString *(NSMutableAttributedString *attr) {
//        if (lineStrs.count > 1) {
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//            [paragraphStyle setLineSpacing:lineGap];// 调整行间距
////                [attr tmui_setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
//            [attr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attr.string.length)];
//        }
//        return attr;
//    };
//    
//    NSInteger limitLine = self.numberOfLines;
//    if (limitLine <= 0 || limitLine >= lineStrs.count) {
//        // 未折叠
//        self.isFold = NO;
//        showStr = unfoldStr;
//    }else{
//        // 当前是折叠状态，需要在最后一行拼接。。。
//        self.isFold = YES;
//        NSString *dotStr = @"...     ";
////        NSArray *lineStrs = [self getLineTextsFromLines:lines str:calcAttr];
//        NSMutableString *foldStr = [NSMutableString string];
//        for (int i = 0; i < limitLine; i++) {
//            NSString *lineStr = lineStrs[i];
//            if (i == limitLine - 1) {
//                NSString *replaceStr = [NSString stringWithFormat:@"%@%@",dotStr,@"展开"];
//            }else{
//                [foldStr appendString:lineStr];
//            }
//        }
//        
//        NSMutableAttributedString *attr = nil;
//       
//        
//        if (!tmui_isNullString(foldStr) && contentAttrDict) {
//            attr = [[NSMutableAttributedString alloc] initWithString:foldStr attributes:self.contentAttrDict];
//        }
//        
//        if (!tmui_isNullString(tagStr) && tagAttrDict) {
//            NSRange tagR = [foldStr rangeOfString:tagStr];
//            [attr addAttributes:self.tagAttrDict range:tagR];
//        }
//        
//        setLineGap(attr);
//        _contentAttrString = attr;
//    }
    
}








- (NSArray <NSString *>*)getLineTextsFromLines:(NSArray *)lines str:(NSAttributedString *)attr{
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [attr.string substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return linesArray;
}


- (NSAttributedString *)unfoldString{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnfoldString:(NSAttributedString *)unfoldString{
    objc_setAssociatedObject(self, @selector(unfoldString), unfoldString, OBJC_ASSOCIATION_RETAIN);
    
    [self createFoldString];
}


TMUISynthesizeBOOLProperty(isFold, setIsFold)

@end
