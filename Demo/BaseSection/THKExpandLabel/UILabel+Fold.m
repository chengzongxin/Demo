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
//
//
//+ (void)load{
//    
//    [TMUIHelper executeBlock:^{
//            
////        ExtendImplementationOfVoidMethodWithoutArguments(self, @selector(drawRect:), ^(__kindof UILabel * _Nonnull selfObject) {
////            NSLog(@"%@",selfObject);
////        });
//        ExchangeImplementations(self, @selector(drawTextInRect:), @selector(unfold_drawTextInRect:));
//        ExchangeImplementations(self, @selector(textRectForBounds:limitedToNumberOfLines:), @selector(unfold_textRectForBounds:limitedToNumberOfLines:));
//    } oncePerIdentifier:@"UILabel fold"];
//    
//    
//}
//
//- (void)unfold_drawTextInRect:(CGRect)rect{
//    [self unfold_drawTextInRect:rect];
//    
////    NSLog(@"%@",self);
//    
////    - (void)drawTextInRect:(CGRect)rect
//    
//    {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        //将当前context的坐标系进行flip,否则上下颠倒
//        CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
//        CGContextConcatCTM(context, flipVertical);
//        //设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
//        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//        NSString *attrStr = self.attributedText.string;
//        NSRange range = NSMakeRange(0, attrStr.length);
//        NSDictionary *dic = [self.attributedText attributesAtIndex:0 effectiveRange:&range];
//        NSMutableParagraphStyle *ps =  [dic objectForKey:NSParagraphStyleAttributeName];
//        BOOL truncatTail = NO;
//        if(ps.lineBreakMode == NSLineBreakByTruncatingTail)
//        {
//            truncatTail = YES;
//        }
//        
//        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGPathAddRect(pathRef,NULL , CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
//         _textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef,NULL );
//        NSInteger numberOfLines = [self numberOfDisplayedLines];
//        
//        CGSize tempSize = self.frame.size;
//        CGSize trueSize = [self getLLLLabelSize];
//       
//        if (_textFrame)
//        {
//            if (numberOfLines > 0 && tempSize.height < trueSize.height)
//            {
//                CFArrayRef lines = CTFrameGetLines(_textFrame);
//                
//                CGPoint lineOrigins[numberOfLines];
//                CTFrameGetLineOrigins(_textFrame, CFRangeMake(0, numberOfLines), lineOrigins);
//                NSAttributedString *attributedString = self.resultAttributedString;
//                for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++)
//                {
//                    CGPoint lineOrigin = lineOrigins[lineIndex];
//                    CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
//                    CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
//                    
//                    BOOL shouldDrawLine = YES;
//                    if (lineIndex == numberOfLines - 1 )
//                    {
//                        // Does the last line need truncation?
//                        CFRange lastLineRange = CTLineGetStringRange(line);
//                        if (lastLineRange.location + lastLineRange.length < attributedString.length)
//                        {
//                            CTLineTruncationType truncationType = kCTLineTruncationEnd;
//                            //加省略号的位置
//                            NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
//                            //获取省略号位置的字符串属性
//                            NSDictionary *tokenAttributes = [attributedString attributesAtIndex:truncationAttributePosition
//                                                                                 effectiveRange:NULL];
//                            //初始化省略号的属性字符串
//                            NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:kEllipsesCharacter
//                                                                                              attributes:tokenAttributes];
//                            //创建一行
//                            CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
//                            NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
//                            
//                            if (lastLineRange.length > 0)
//                            {
//                                // Remove last token
//                                [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
//                            }
//                            [truncationString appendAttributedString:tokenString];
//                            
//                            //创建省略号的行
//                            CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)truncationString);
//                            // 在省略号行的末尾加上省略号
//                            CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
//                            if (!truncatedLine)
//                            {
//                                // If the line is not as wide as the truncationToken, truncatedLine is NULL
//                                truncatedLine = CFRetain(truncationToken);
//                            }
//                            CFRelease(truncationLine);//CF得自己释放，ARC的不会释放
//                            CFRelease(truncationToken);
//                            
//                            CTLineDraw(truncatedLine, context);
//                            CFRelease(truncatedLine);
//                            
//                            shouldDrawLine = NO;
//                        }
//                    }
//                    if(shouldDrawLine)
//                    {
//                        CTLineDraw(line, context);
//                    }
//                }
//            }
//            else
//            {
//                CTFrameDraw(_textFrame,context);
//            }
//        }
//        
//        CGContextRestoreGState(context);
//    }
//
//    
//}
//
//- (CGRect)unfold_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
//    CGRect rect = [self unfold_textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
//    return rect;
//}
//
//- (void)createFoldString{
////    NSAttributedString *showStr = nil;
////    CGFloat maxWidth = (TMUI_SCREEN_WIDTH - 40);
////    NSAttributedString *unfoldStr = self.unfoldString;
////    UIFont *font = [unfoldStr tmui_font];
////    CGFloat lineGap = [unfoldStr tmui_paragraphStyle].lineSpacing;
////    // 每一行字符数组
////    NSArray *lineStrs = [unfoldStr.string tmui_linesArrayForFont:font maxWidth:maxWidth];
////    
////    NSMutableAttributedString* (^setLineGap)(NSMutableAttributedString*) = ^NSMutableAttributedString *(NSMutableAttributedString *attr) {
////        if (lineStrs.count > 1) {
////            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
////            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
////            [paragraphStyle setLineSpacing:lineGap];// 调整行间距
//////                [attr tmui_setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
////            [attr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attr.string.length)];
////        }
////        return attr;
////    };
////    
////    NSInteger limitLine = self.numberOfLines;
////    if (limitLine <= 0 || limitLine >= lineStrs.count) {
////        // 未折叠
////        self.isFold = NO;
////        showStr = unfoldStr;
////    }else{
////        // 当前是折叠状态，需要在最后一行拼接。。。
////        self.isFold = YES;
////        NSString *dotStr = @"...     ";
//////        NSArray *lineStrs = [self getLineTextsFromLines:lines str:calcAttr];
////        NSMutableString *foldStr = [NSMutableString string];
////        for (int i = 0; i < limitLine; i++) {
////            NSString *lineStr = lineStrs[i];
////            if (i == limitLine - 1) {
////                NSString *replaceStr = [NSString stringWithFormat:@"%@%@",dotStr,@"展开"];
////            }else{
////                [foldStr appendString:lineStr];
////            }
////        }
////        
////        NSMutableAttributedString *attr = nil;
////       
////        
////        if (!tmui_isNullString(foldStr) && contentAttrDict) {
////            attr = [[NSMutableAttributedString alloc] initWithString:foldStr attributes:self.contentAttrDict];
////        }
////        
////        if (!tmui_isNullString(tagStr) && tagAttrDict) {
////            NSRange tagR = [foldStr rangeOfString:tagStr];
////            [attr addAttributes:self.tagAttrDict range:tagR];
////        }
////        
////        setLineGap(attr);
////        _contentAttrString = attr;
////    }
//    
//}
//
//
//
//
//
//
//
//
//- (NSArray <NSString *>*)getLineTextsFromLines:(NSArray *)lines str:(NSAttributedString *)attr{
//    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
//    for (id line in lines) {
//        CTLineRef lineRef = (__bridge  CTLineRef )line;
//        CFRange lineRange = CTLineGetStringRange(lineRef);
//        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
//        NSString *lineString = [attr.string substringWithRange:range];
//        [linesArray addObject:lineString];
//    }
//    return linesArray;
//}
//
//
//- (NSAttributedString *)unfoldString{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setUnfoldString:(NSAttributedString *)unfoldString{
//    objc_setAssociatedObject(self, @selector(unfoldString), unfoldString, OBJC_ASSOCIATION_RETAIN);
//    
//    [self createFoldString];
//}
//
//
//TMUISynthesizeBOOLProperty(isFold, setIsFold)

@end
