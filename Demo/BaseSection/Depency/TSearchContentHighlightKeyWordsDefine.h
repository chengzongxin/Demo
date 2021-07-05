//
//  TSearchContentHighlightKeyWordsDefine.h
//  HouseKeeper
//
//  Created by nigel.ning on 2019/9/25.
//  Copyright © 2019 binxun. All rights reserved.
//

#ifndef TSearchContentHighlightKeyWordsDefine_h
#define TSearchContentHighlightKeyWordsDefine_h

///< 搜索全部的内容里关于高亮词的解析及拆分读取规则可以保持一致，只需在对应的数据模型类添加以下便捷宏定义即可保持相关数据处理的一致性
///< 相关属性数据的赋值，完全与数据返回Key保持一致

///< 属性申明添加以下宏 .h文件申明里  TSearchContentHighlightKeyWordsProperties_Interface
#define TSearchContentHighlightKeyWordsProperties_Interface \
/** 高亮分词信息字典数据 @[@{@"field": @"对应高亮分词的位置 ep:description", @"fragments": @[@"高亮词1", @"高亮词2"]}, ...] */ \
@property (nonatomic, strong, nullable)NSArray<NSDictionary *> *highlightList; \
/** 从highlightList列表数据中取出所有的fragments对应的高亮分词组装成唯一的一个高亮分词列表 */ \
@property (nonatomic, strong, readonly, nullable)NSArray<NSString *> *highlightKeyWordsList; \
/** 高亮词显示的颜色 */ \
@property (nonatomic, strong, readonly)UIColor *highlightKeyWordColor; \
\
/** 方法申明 传入一个串，返回一个高亮分词的属性串，若str为无效类型或无效值或无高亮词则返回nil */ \
- (NSAttributedString *)highlightKeyworsAttributedStringFromString:(NSString *)str;\
/** 功能同上，注意参数必需为可变的类型实例*/ \
- (void)makeHighlightKeyworsInAttributedString:(NSMutableAttributedString *)attr; \

///< 相关方法实现添加以下宏 .m文件实现里  TSearchContentHighlightKeyWordsProperties_Implementation
#define TSearchContentHighlightKeyWordsProperties_Implementation    \
@synthesize highlightKeyWordsList = _highlightKeyWordsList;         \
@synthesize highlightKeyWordColor = _highlightKeyWordColor;         \
    \
- (NSArray<NSString *> *)highlightKeyWordsList {     \
    if (!_highlightKeyWordsList) {  \
        if (self.highlightList.count > 0) { \
            NSMutableSet *mSet = [NSMutableSet set];    \
            for (NSDictionary *dic in self.highlightList) { \
                NSArray *keyList = dic[@"fragments"];   \
                if (keyList && [keyList isKindOfClass:[NSArray class]] && keyList.count > 0) {  \
                    [mSet addObjectsFromArray:keyList]; \
                }   \
            }   \
            if (mSet.count > 0) {   \
                _highlightKeyWordsList = [NSArray arrayWithArray:mSet.allObjects];  \
            }   \
        }   \
    }   \
    return _highlightKeyWordsList;  \
}   \
\
- (UIColor *)highlightKeyWordColor {    \
    if (!_highlightKeyWordColor) {  \
        _highlightKeyWordColor = kTo8toGreen;   \
    }   \
    return _highlightKeyWordColor;  \
}   \
    \
/** 传入一个串，返回一个高亮分词的属性串，若str为无效类型或无效值则返回nil */ \
- (NSAttributedString *)highlightKeyworsAttributedStringFromString:(NSString *)str {    \
    if (![str isKindOfClass:[NSString class]] || str.length == 0) { \
        return nil; \
    }   \
    if (self.highlightKeyWordsList.count == 0) { \
        return nil; \
    }   \
    \
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];   \
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];   \
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail; \
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];  \
    [self makeHighlightKeyworsInAttributedString:attr]; \
    return attr;    \
}   \
    \
- (void)makeHighlightKeyworsInAttributedString:(NSMutableAttributedString *)attr {    \
    [self.highlightKeyWordsList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {   \
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:obj options:0 error:nil];  \
        NSArray<NSTextCheckingResult *> *ls = [reg matchesInString:attr.string options:0 range:NSMakeRange(0, attr.string.length)]; \
        [ls enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {   \
            if (obj.range.location != NSNotFound && obj.range.length > 0) { \
                [attr addAttributes:@{NSForegroundColorAttributeName: kTo8toGreen} range:obj.range];   \
            }   \
        }]; \
    }]; \
}  \

///< 使lbl上显示的原文本，若存在高亮词则调整为高亮显示. 注意：调用前lbl.text或attributedText一定要有值，否则此调用无任何效果
///< 参数model为符合上面宏定义的数据实例对象
#define TSearchContentMakeKeywordsShowHighlightInLabelIfNeed(lbl, model) \
    if (lbl.text.length > 0 && model.highlightKeyWordsList.count > 0) { \
        NSAttributedString *attr = lbl.attributedText;  \
        NSMutableAttributedString *mAttr = nil; \
        if (attr.length > 0) {  \
            mAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];  \
        }   \
        if (mAttr) {    \
            [model makeHighlightKeyworsInAttributedString:mAttr];  \
            lbl.attributedText = mAttr; \
        }else { \
            NSAttributedString *t_attr = [model highlightKeyworsAttributedStringFromString:lbl.text];  \
            if (t_attr) { \
                lbl.attributedText = t_attr;  \
            }   \
        }   \
    }   \
    \




#endif /* TSearchContentHighlightKeyWordsDefine_h */
