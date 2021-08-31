//
//  ExpandLabel.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/31.
//

#import "ExpandLabel.h"

@interface ExpandLabel ()

@property (nonatomic, strong) NSAttributedString *originAttributedText;

@property (nonatomic, strong) NSArray <NSAttributedString *> *originAttributedTexts;

@property (nonatomic, strong) UILabel *foldLabel;

@property (nonatomic, strong) NSAttributedString *contentAttrString;

@end

@implementation ExpandLabel




- (void)setTagStr:(NSString *)tagStr contentStr:(NSString *)contentStr{
    _tagStr = tagStr;
    _contentStr = contentStr;
    
    self.attributedText = [self contentAttrString];
}

- (NSAttributedString *)contentAttrString{
    if (_contentAttrString == nil) {
        CGFloat contentWidth = _maxWidth;
        
        NSString *tagN = self.tagStr;
        NSString *tagStr;
        if ([tagN isKindOfClass:NSString.class] && tagN.length > 0) {
            tagStr = [NSString stringWithFormat:@"#%@#  ",tagN];
        }else{
            tagStr = @"";
        }
        NSString *contentStr = [self.contentStr tmui_trim];
        
        NSString *allStr = [NSString stringWithFormat:@"%@%@",tagStr,contentStr];
        
        UIFont *font = _preferFont;
//        if (!font) {
//            font = [attributedText tmui_font];
//        }
        if (!font) {
            font = self.font?:UIFont(17);
        }
        
        if (_maxWidth == 0) {
            [self layoutIfNeeded];
            _maxWidth = self.width;
        }
        
        NSArray *lines = [allStr tmui_linesArrayForFont:font maxWidth:_maxWidth];
        if (self.numberOfLines > 0) {
            // 只显示3行文字
            NSInteger limitLine = self.numberOfLines;
            NSString *dotStr = @"...    ";
            if (lines.count > limitLine) {
                self.isFold = YES;
                NSMutableString *foldStr = [NSMutableString string];
                for (int i = 0; i < limitLine; i++) {
                    NSString *lineStr = lines[i];
                    if (i == limitLine - 1) {
                        // 最后一行，铺满需要截取
                        CGFloat width = [lineStr tmui_widthForFont:font];
                        if (width > contentWidth - 32) {
                            lineStr = [lineStr stringByReplacingCharactersInRange:NSMakeRange(lineStr.length - dotStr.length, dotStr.length) withString:dotStr];
                        }else{
                            lineStr = [[lineStr tmui_trim] stringByAppendingString:dotStr];
                        }
                    }
                    [foldStr appendString:lineStr];
                }
                allStr = [foldStr tmui_trim]; // 去掉尾部换行符
            }
        }else{
            self.isFold = NO;
        }

        BOOL oneLine = lines.count <= 1;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [paragraphStyle setLineSpacing:oneLine?0:self.lineSpacing];// 调整行间距
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSForegroundColorAttributeName:UIColorHex(#1A1C1A),NSFontAttributeName:UIFont(16),NSParagraphStyleAttributeName:paragraphStyle}];
        [attr addAttributes:@{NSForegroundColorAttributeName:THKColor_999999,NSFontAttributeName:UIFontMedium(16)} range:[allStr rangeOfString:tagStr]];
        _contentAttrString = attr;
    }
    return _contentAttrString;
}


@end

