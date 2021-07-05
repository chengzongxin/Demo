//
//  THKStorageLabel.m
//  Example
//
//  Created by nigel.ning on 2020/11/12.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "THKTextTagLabel.h"

@interface THKTextTagLabel()
@property (nonatomic, strong)UIView *textTagBgView;
@property (nonatomic, strong)UILabel *textTagLabel;
@end

@implementation THKTextTagLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadTextTagSubLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self loadTextTagSubLabel];
    }
    return self;
}

- (void)loadTextTagSubLabel {
    
    if (!self.textTagBgView) {
        self.textTagBgView = [[UIView alloc] init];
        self.textTagBgView.clipsToBounds = YES;
        [self addSubview:self.textTagBgView];
        [self.textTagBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.top.mas_equalTo(1);
            make.height.mas_equalTo(15);
        }];
        
        self.textTagLabel = [[UILabel alloc] init];
        self.textTagLabel.clipsToBounds = YES;
        self.textTagLabel.textAlignment = NSTextAlignmentCenter;    
        [self addSubview:self.textTagLabel];
        [self.textTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.textTagBgView.mas_leading).mas_offset(4);
            make.trailing.mas_equalTo(self.textTagBgView.mas_trailing).mas_offset(-4);
            make.centerY.mas_equalTo(self.textTagBgView.mas_centerY);
        }];
        
        self.textTagBgView.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIFont *font = self.font;
    CGFloat lineSpacing = 0;
    if(self.attributedText) {
        font = [self.attributedText attribute:NSFontAttributeName atIndex:self.attributedText.length-1 effectiveRange:nil];
        NSParagraphStyle *pStyle = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:self.attributedText.length-1 effectiveRange:nil];
        lineSpacing = pStyle.lineSpacing;
    }
    CGFloat fontSize = ceilf(font.pointSize);
    CGSize size = self.bounds.size;
    //根据展示的实际文本内容的显示效果微调文本标签的y轴位置
    if (size.height <= (fontSize + lineSpacing) * 2 + 3) {
        [self.textTagBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((fontSize + lineSpacing - 15.0f)/2.0f);
        }];
    }else {
        [self.textTagBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2);
        }];
    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [self resetTagLabel];
    if (attributedText.thk_drawBackgroundRange.location == 0 &&
        attributedText.thk_drawBackgroundRange.length > 0 &&
        attributedText.thk_drawBackgroundRange.location + attributedText.thk_drawBackgroundRange.length <= attributedText.length) {
        NSAttributedString *tagAttributedStr = [attributedText attributedSubstringFromRange:attributedText.thk_drawBackgroundRange];
        if (tagAttributedStr) {
            UIFont *tagFont = [tagAttributedStr attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            
            self.textTagLabel.font = tagFont;
            self.textTagLabel.textColor = attributedText.thk_drawRangeTextColor;
            self.textTagLabel.text = [tagAttributedStr.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.textTagBgView.layer.cornerRadius = attributedText.thk_drawBackgroundCornerRadius;
            self.textTagBgView.backgroundColor = attributedText.thk_drawBackgroundColor;
            self.textTagBgView.hidden = NO;
        }
    }
    [super setAttributedText:attributedText];
}

- (void)setText:(NSString *)text {
    [self resetTagLabel];
    [super setText:text];
}

- (void)resetTagLabel {
    self.textTagLabel.text = nil;
    self.textTagBgView.hidden = YES;
}

@end
