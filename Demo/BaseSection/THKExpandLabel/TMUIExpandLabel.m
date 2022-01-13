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
/// 展开
@property (nonatomic, assign ) BOOL isExpanded;
/// 是否换行
@property (nonatomic, assign ) BOOL isNewLine;
/// 展开区域
@property (nonatomic, assign) CGRect clickArea;
/** 收起/展开颜色 默认blueColor*/
@property (nonatomic, strong) UIColor *expandColor;
/** 字体大小 默认14*/
@property (nonatomic, assign) CGFloat fontSize;
/// 段落样式
@property (nonatomic, strong) NSMutableParagraphStyle *style;
/// 原始文本
@property (nonatomic, strong) NSAttributedString *originAttr;
/// 收起文本
@property (nonatomic, strong) NSAttributedString *shrinkAttr;
/// 展开文本
@property (nonatomic, strong) NSAttributedString *expandAttr;

@property (nonatomic, strong) UIView *debugView;
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
        self.maxLine = NSIntegerMax;
        
        self.debugView = [UIView new];
        [self addSubview:self.debugView];
        self.debugView.backgroundColor = [UIColor.tmui_randomColor colorWithAlphaComponent:0.3];
    }
    return self;
}

// 设置后，系统会自动调drawRect
- (void)setAttributedText:(NSAttributedString *)attributedText{
    self.fontSize = attributedText.tmui_font.pointSize;
    self.style = attributedText.tmui_paragraphStyle;
    self.expandColor = UIColor.redColor;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    attr.tmui_paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    self.originAttr = attr;
    
    [super setAttributedText:attr];
}

- (void)setIsExpanded:(BOOL)isExpanded{
    _isExpanded = isExpanded;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    [self drawText];
}

- (void)drawText{
    if (self.isExpanded) {
        [self drawExpandText];
    }else{
        [self drawShrinkText];
    }
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
    
    for (int i = 0; i < lines.count; i++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        if (i < lines.count - 1) {
            // 前面几行
            totalHeight += [self heightForCTLine:line];
        }else if (i == lines.count - 1) {
            // 最后一行
            NSArray *runs = (NSArray*)CTLineGetGlyphRuns(line);
            CGFloat x = 0;
            for (int i = 0; i < runs.count - 1; i++) {
                CTRunRef run = (__bridge CTRunRef)runs[i];
                x += CTRunGetTypographicBounds(run, CFRangeMake(0, 0), NULL, NULL, NULL);
            }
            
            CTLineRef moreLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.clickAttributedText);
            CGSize moreSize = CTLineGetBoundsWithOptions(moreLine, 0).size;
            self.clickArea = CGRectMake(x, totalHeight, moreSize.width, moreSize.height);
            
            CFRelease(moreLine);
        }
    }
    self.expandAttr = drawAttributedText;
    // 避免重复走一遍逻辑
    [super setAttributedText:drawAttributedText];
    !_sizeChangeBlock?:_sizeChangeBlock(CGSizeMake(self.width, totalHeight));
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(setter);
}

// 显示裁剪
- (void)drawShrinkText{
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.bounds.size.width, UIScreen.mainScreen.bounds.size.height), nil);
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:_originAttr];
    [attributed tmui_setAttribute:NSParagraphStyleAttributeName value:self.style];
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
    
    NSInteger maxLine = self.maxLine;
    for (int i=0; i<lines.count; i++) {
        if (lines.count > maxLine && i == maxLine) {
            break;
        }
        //获取行
        CTLineRef line = (__bridge CTLineRef)lines[i];
        //获取该行的在整个attributed的范围
        CFRange range = CTLineGetStringRange(line);
        //截取这一行的text
        NSAttributedString *subAttr = [attributed attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
        //当是限制的最多行数时
        if (lines.count > maxLine && i == maxLine - 1) {
            NSMutableAttributedString *drawAttr = (NSMutableAttributedString*)subAttr;
//            if ([drawAttr.string hasSuffix:@"\n"]) { // 剔除结尾有换行的情况
//                [drawAttr deleteCharactersInRange:NSMakeRange(drawAttr.string.length - 1, 1)];
//            }
            for (int j = 0; j < drawAttr.length; j++) {
                //所限制的最后一行的内容 + "展开>" 处理刚刚只显示成一行内容 如果不只一行 一个一个字符的减掉到只有一行为止
                NSMutableAttributedString *lastLineAttr = [[NSMutableAttributedString alloc] initWithAttributedString:[drawAttr attributedSubstringFromRange:NSMakeRange(0, drawAttr.length-j)]];
                
                [lastLineAttr appendAttributedString:self.clickAttributedText];
                //内容是否是只有一行
                NSInteger number = [self numberOfLinesForAttributtedText:lastLineAttr];
                if (number == 1) {
                    [drawAttributedText appendAttributedString:lastLineAttr];
                    
                    CTLineRef lastLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)lastLineAttr);
                    CGSize lastLineSize = CTLineGetBoundsWithOptions(lastLine, 0).size;
                    
                    CTLineRef expandLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.clickAttributedText);
                    CGSize expandSize = CTLineGetBoundsWithOptions(expandLine, 0).size;
                    
                    
                    self.clickArea = CGRectMake(lastLineSize.width - expandSize.width, totalHeight, expandSize.width, expandSize.height);
                    
                    totalHeight += [self heightForCTLine:line];
                    CFRelease(expandLine);
                    break;
                }
            }
            CFRelease(line);
            
        } else {
            [drawAttributedText appendAttributedString:subAttr];
            
            totalHeight += [self heightForCTLine:line];
        }
    }
    self.shrinkAttr = drawAttributedText;
    // 避免重复走一遍逻辑
    [super setAttributedText:drawAttributedText];
    !_sizeChangeBlock?:_sizeChangeBlock(CGSizeMake(self.width, totalHeight));
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
        TMUIExpandLabelClickActionType type = self.isExpanded ? TMUIExpandLabelClickActionType_Expand : TMUIExpandLabelClickActionType_Shrink;
        !_clickActionBlock?:_clickActionBlock(type);
    }else{
        !_clickActionBlock?:_clickActionBlock(TMUIExpandLabelClickActionType_Label);
    }
}

- (void)setClickArea:(CGRect)clickArea{
    _clickArea = clickArea;
    _debugView.frame = clickArea;
}


-(NSAttributedString *)clickAttributedText{
    if (_isExpanded) {
        if (_isNewLine) {
            return [[NSAttributedString alloc] initWithString:@"\n收起" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize], NSForegroundColorAttributeName: self.expandColor}];
        } else {
            return [[NSAttributedString alloc] initWithString:@" 收起" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize], NSForegroundColorAttributeName: self.expandColor}];
        }
        
    }
    
   NSMutableAttributedString *moreString = [[NSMutableAttributedString alloc] initWithString:@"..." attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize], NSForegroundColorAttributeName: self.textColor}];
    NSAttributedString  *foldString = [[NSAttributedString alloc] initWithString:@"展开" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize], NSForegroundColorAttributeName: self.expandColor}];
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
    return h + _lineHeightErrorDimension + self.style.lineSpacing;
}


@end
