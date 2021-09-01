//
//  ExpandLabel.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/31.
//

#import "THKExpandLabel.h"

@interface THKExpandLabel ()

@property (nonatomic, strong) NSAttributedString *contentAttrString;

@property (nonatomic, strong) UIButton *foldBtn;


// local var
@property (nonatomic, strong) NSString *tagStr;
@property (nonatomic, strong) NSDictionary *tagAttrDict;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSDictionary *contentAttrDict;

@end

@implementation THKExpandLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.userInteractionEnabled = YES;
    [self addSubview:self.foldBtn];
    [self.foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).inset(10);
        make.bottom.equalTo(self).inset(0);
    }];
}

- (void)setPreferFont:(UIFont *)preferFont{
    _preferFont = preferFont;
    self.foldBtn.tmui_font = preferFont;
    CGFloat width = [self.foldBtn.tmui_text tmui_sizeForFont:preferFont size:CGSizeMax lineHeight:0 mode:NSLineBreakByWordWrapping].width;
    [self.foldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(preferFont.lineHeight);
        make.width.mas_equalTo(width);
    }];
}

- (void)setTagStr:(NSString *)tagStr contentStr:(NSString *)contentStr{
    _tagStr = tagStr;
    _contentStr = contentStr;
    
    [self drawText];
}

- (void)setTagStr:(NSString *)tagStr tagAttrDict:(NSDictionary *)tagAttrDict contentStr:(NSString *)contentStr contentAttrDict:(NSDictionary *)contentAttrDict{
    _tagStr = tagStr;
    _contentStr = contentStr;
    _tagAttrDict = tagAttrDict;
    _contentAttrDict = contentAttrDict;
    
    [self drawText];
}


- (void)unfoldBtnClick{
    if (self.unfoldClick) {
        self.unfoldClick();
    }
    self.numberOfLines = 0;
    
    [self drawText];
}

- (void)drawText{
    _contentAttrString = nil;
    self.attributedText = [self contentAttrString];
    self.foldBtn.hidden = !self.isFold;
}

- (NSAttributedString *)contentAttrString{
    if (_contentAttrString == nil) {
        CGFloat contentWidth = _maxWidth;
        NSString *tagStr = self.tagStr?:@"";
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
        
        NSMutableAttributedString *calcAttr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:self.contentAttrDict];
        [calcAttr addAttributes:self.tagAttrDict range:[allStr rangeOfString:tagStr]];
        
        NSArray *lines = [self getLinesForAttrStr:calcAttr maxWidth:_maxWidth];
        
        NSLog(@"111 %@",lines);
//        [allStr tmui_linesArrayForFont:nil maxWidth:0];
        if (self.numberOfLines > 0) {
            // 只显示3行文字
            NSInteger limitLine = self.numberOfLines;
            NSString *dotStr = @"...     ";
            if (lines.count > limitLine) {
                
                NSArray *lineStrs = [self getLineTextsFromLines:lines str:calcAttr];
                self.isFold = YES;
                NSMutableString *foldStr = [NSMutableString string];
                for (int i = 0; i < limitLine; i++) {
                    NSString *lineStr = lineStrs[i];
                    if (i == limitLine - 1) {
                        // 最后一行，铺满需要截取
                        // 最后一行宽度
                        CGFloat width = [lineStr tmui_widthForFont:font];
                        // 拼接文本
                        NSString *appendStr = [NSString stringWithFormat:@"%@%@",dotStr,self.foldBtn.tmui_text];
                        CGFloat appendWidth = [appendStr tmui_sizeWithFont:_preferFont width:_maxWidth].width;
                        CGFloat padding = 10;
                        CGFloat addtionGap = 4;
                        if (width > contentWidth - appendWidth - padding) {
                            lineStr = [lineStr substringToIndex:lineStr.length - appendStr.tmui_lengthWhenCountingNonASCIICharacterAsTwo - addtionGap];
                        }
                        lineStr = [[lineStr tmui_trim] stringByAppendingString:dotStr];
                        
                    }
                    [foldStr appendString:lineStr];
                }
                allStr = [foldStr tmui_trim]; // 去掉尾部换行符
            }
        }else{
            self.isFold = NO;
        }
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:self.contentAttrDict];
        [attr addAttributes:self.tagAttrDict range:[allStr rangeOfString:tagStr]];
        
        if (lines.count >= 1) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            [paragraphStyle setLineSpacing:self.lineGap];// 调整行间距
            [attr tmui_setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
        }
        
        _contentAttrString = attr;
    }
    return _contentAttrString;
}

/// 获取富文本占据行数 CTLine
- (NSArray *)getLinesForAttrStr:(NSAttributedString *)attrStr maxWidth:(CGFloat)maxWidth{
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(maxWidth, CGFLOAT_MAX) text:attrStr];
    NSArray *lines = (NSArray *)CTFrameGetLines(layout.frame);
    return lines;
}

/// 获取每一行富文本内容,lines为 (NSArray *)CTFrameGetLines类型
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

- (UIButton *)foldBtn{
    if (!_foldBtn) {
        _foldBtn = [[UIButton alloc] init];
        _foldBtn.tmui_text = @"展开";
        _foldBtn.tmui_titleColor = UIColorHex(5B6F9C);
        _foldBtn.hidden = YES;
        [_foldBtn tmui_addTarget:self action:@selector(unfoldBtnClick)];
    }
    return _foldBtn;
}


@end
