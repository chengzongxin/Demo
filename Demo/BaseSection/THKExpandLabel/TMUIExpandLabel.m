//
//  TMUIExpandLabel.m
//  Demo
//
//  Created by Joe.cheng on 2022/1/7.
//

#import "TMUIExpandLabel.h"

@interface TMUIExpandLabel (){
    CGFloat _lineHeightErrorDimension; //误差值 默认为0.5
}
@property(nonatomic)BOOL isExpanded;
@property (nonatomic, assign) BOOL isNewLine;
@property(nonatomic)CGRect clickArea;


//@property(nonatomic,copy)void(^action)(XYExpandableLabelActionType type, id info);
/** 行间距  默认为0 */
@property (nonatomic, assign) CGFloat lineSpace;
/** text的颜色  默认blackColor*/
//@property (nonatomic, strong) UIColor *textColor;
/** 收起/展开颜色 默认blueColor*/
@property (nonatomic, strong) UIColor *expandColor;
/** 字体大小 默认14*/
@property (nonatomic, assign) CGFloat fontSize;



@property (nonatomic, strong) NSAttributedString *originAttr;

@end


@implementation TMUIExpandLabel

- (void)dealloc{
    NSLog(@"TMUIExpandLabel delloc");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(actionNotificationReceived:) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGestureTapped:)]];
        self.numberOfLines = 0;
    }
    return self;
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    
    
    if (self.originAttr == nil) {
        self.originAttr = attributedText;
    }
}

- (void)setIsExpanded:(BOOL)isExpanded{
    _isExpanded = isExpanded;
    
    self.numberOfLines = 0;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self drawText];
}

- (void)drawText{
//    self.originAttr = self.attributedText;
//    self.maximumLines = self.numberOfLines;
    self.fontSize = [self.attributedText tmui_font].pointSize;
    self.expandColor = UIColor.redColor;
    self.lineSpace = 20;
    if (self.isExpanded) {
        [self drawExpandText];
    }else{
        [self drawShrinkText];
    }
    
    [self setNeedsDisplay];
}

// 显示全部
- (void)drawExpandText{
    
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.bounds.size.width, UIScreen.mainScreen.bounds.size.height), nil);
    //加了 "收起>"的Text
    NSMutableAttributedString *drawAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:_originAttr];
    [drawAttributedText appendAttributedString:self.clickAttributedText];
    //没加加了 "收起>"的Text
    NSMutableAttributedString *drawAttributedText1 = [[NSMutableAttributedString alloc] initWithAttributedString:_originAttr];
    NSInteger line1Count = [self numberOfLinesForAttributtedText:drawAttributedText1];
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)drawAttributedText);
    // CTFrameRef
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, drawAttributedText.length), path, NULL);
    // CTLines
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    CGFloat totalHeight = 0;
    if (lines.count > line1Count) {
        self.isNewLine = YES;
        drawAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:_originAttr];
        [drawAttributedText appendAttributedString:self.clickAttributedText];
        setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)drawAttributedText);
        ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, drawAttributedText.length), path, NULL);
        
        // CTLines
        lines = (NSArray*)CTFrameGetLines(ctFrame);
        
    } else {
        self.isNewLine = NO;
    }
    
    for (int i=0; i<lines.count; i++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        totalHeight += [self heightForCTLine:line];
        
        if (i == lines.count - 1) {
            CTLineRef moreLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.clickAttributedText);
            
            NSArray *runs = (NSArray*)CTLineGetGlyphRuns(line);
            CGFloat w = 0;
            for (int i=0; i<runs.count; i++) {
                if (i == runs.count - 1) {
                    break;
                }
                CTRunRef run = (__bridge CTRunRef)runs[i];
                w += CTRunGetTypographicBounds(run, CFRangeMake(0, 0), NULL, NULL, NULL);
            }
            
            CGSize moreSize = CTLineGetBoundsWithOptions(moreLine, 0).size;
            CGFloat h = moreSize.height ;
            self.clickArea = CGRectMake(w, totalHeight - h, moreSize.width, h);

            CFRelease(moreLine);
        }
       
    }
    self.attributedText = drawAttributedText;
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(setter);
}

// 显示裁剪
- (void)drawShrinkText{
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.bounds.size.width, UIScreen.mainScreen.bounds.size.height), nil);
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:_originAttr];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.lineSpacing = self.lineSpace;
    [attributed tmui_setAttribute:NSParagraphStyleAttributeName value:style];
    // CTFrameRef
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributed);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attributed.length), path, NULL);
    
    // CTLines
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    
    // CTLine Origins
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    CGFloat totalHeight = 0;
    
    NSMutableAttributedString *drawAttributedText = [NSMutableAttributedString new];
    
    for (int i=0; i<lines.count; i++) {
        if (lines.count > _maximumLines && i == _maximumLines) {
            break;
        }
        //获取行
        CTLineRef line = (__bridge CTLineRef)lines[i];
        //获取该行的在整个attributed的范围
        CFRange range = CTLineGetStringRange(line);
        //截取这一行的text
        NSAttributedString *subAttr = [attributed attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
        //当是限制的最多行数时
        if (lines.count > _maximumLines && i == _maximumLines - 1) {
            NSMutableAttributedString *drawAttr = (NSMutableAttributedString*)subAttr;
            for (int j=0; j<drawAttr.length; j++) {
                //所限制的最后一行的内容 + "展开>" 处理刚刚只显示成一行内容 如果不只一行 一个一个字符的减掉到只有一行为止
                NSMutableAttributedString *lastLineAttr = [[NSMutableAttributedString alloc] initWithAttributedString:[drawAttr attributedSubstringFromRange:NSMakeRange(0, drawAttr.length-j)]];
                if ([lastLineAttr.string hasSuffix:@"\n"]) {
                    [lastLineAttr deleteCharactersInRange:NSMakeRange(lastLineAttr.string.length - 1, 1)];
                }
                [lastLineAttr appendAttributedString:self.clickAttributedText];
                //内容是否是只有一行
                NSInteger number = [self numberOfLinesForAttributtedText:lastLineAttr];
                if (number == 1) {
                    [drawAttributedText appendAttributedString:lastLineAttr];
                    CTLineRef moreLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.clickAttributedText);
                    CGSize moreSize = CTLineGetBoundsWithOptions(moreLine, 0).size;
                    
                    self.clickArea = CGRectMake(self.bounds.size.width-moreSize.width, totalHeight, moreSize.width, moreSize.height);
                    
                    totalHeight += [self heightForCTLine:line];
                    CFRelease(moreLine);
                    break;
                }
            }
            CFRelease(line);
            
        } else {
            [drawAttributedText appendAttributedString:subAttr];
            
            totalHeight += [self heightForCTLine:line];
        }
    }
//    completion(totalHeight, drawAttributedText);
    self.attributedText = drawAttributedText;
//    CFRelease(ctFrame);  // 释放会crash
    CFRelease(setter);
    CFRelease(path);
}




#pragma mark - Action Method
-(void)actionNotificationReceived: (NSNotification*)sender{
    if ([sender.name isEqualToString:UIDeviceOrientationDidChangeNotification]) {
        self.isExpanded = self.isExpanded;
    }
}

-(void)actionGestureTapped: (UITapGestureRecognizer*)sender{
    if (CGRectContainsPoint(_clickArea, [sender locationInView:self])) {
        self.isExpanded = !self.isExpanded;
//        self.action ? self.action(0, @(self.contentView.frame.size.height)) : nil;
    }
}



-(NSAttributedString *)clickAttributedText{
    if (_isExpanded) {
        if (_isNewLine) {
            return [[NSAttributedString alloc] initWithString:@"\n收起＞" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize], NSForegroundColorAttributeName: self.expandColor}];
        } else {
            return [[NSAttributedString alloc] initWithString:@" 收起＞" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize], NSForegroundColorAttributeName: self.expandColor}];
        }
        
    }
    
   NSMutableAttributedString *moreString = [[NSMutableAttributedString alloc] initWithString:@"......" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize], NSForegroundColorAttributeName: self.textColor}];
    NSAttributedString  *foldString = [[NSAttributedString alloc] initWithString:@"展开1212 ＞" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize], NSForegroundColorAttributeName: self.expandColor}];
    [moreString appendAttributedString:foldString];
    return moreString;
}

/** 计算text的行数 */
-(NSInteger)numberOfLinesForAttributtedText: (NSAttributedString*)text {
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.bounds.size.width, UIScreen.mainScreen.bounds.size.height), nil);
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, text.length), path, nil);
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    CFRelease(ctFrame);
    CFRelease(setter);
    CFRelease(path);
    return lines.count;
}

-(CGFloat)heightForCTLine: (CTLineRef)line{
    CGFloat h = 0;
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    h = MAX(h, ascent + descent + leading);
    return h + _lineHeightErrorDimension + self.lineSpace;
}


@end
