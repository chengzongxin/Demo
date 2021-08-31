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

@property (nonatomic, strong) UIButton *foldBtn;

@end

@implementation ExpandLabel

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
        make.bottom.equalTo(self).inset(10);
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
        NSString *tagStr = self.tagStr;
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
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSForegroundColorAttributeName:UIColorHex(#1A1C1A),NSFontAttributeName:UIFont(20),NSParagraphStyleAttributeName:paragraphStyle}];
        [attr addAttributes:@{NSForegroundColorAttributeName:THKColor_999999,NSFontAttributeName:UIFontMedium(20)} range:[allStr rangeOfString:tagStr]];
        _contentAttrString = attr;
    }
    return _contentAttrString;
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

