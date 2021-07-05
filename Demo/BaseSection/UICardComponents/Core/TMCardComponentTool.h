//
//  TMCardComponentTool.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/4/8.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TMCardComponentCellSizeTool.h"
#import "TMCardComponentCellDataProtocol.h"
#import "NSAttributedString+THKTextTagLabel.h"

NS_ASSUME_NONNULL_BEGIN

@class TMCardComponentDataCoverSubIcon;

/**
 卡片组件内部相关逻辑会用到的辅助方法
 */
@interface TMCardComponentTool : NSObject

/**
 加载网络图片
 @note 若指定placeHolderImage有值则在加载成功回调后若无图片数据则会赋值此占位图片
 */
+ (void)loadNetImageInImageView:(UIImageView *)imgView imUrl:(NSString * _Nullable)imgUrl finishPlaceHolderImage:(UIImage *_Nullable)placeHolderImage;

/**作者类型时，头像若加载不出现则显示的默认图*/
+ (UIImage *_Nullable)authorAvatarPlaceHolderImage;

/**图片上显示相关标签icon或其它装饰icon刷新显示的统一方法
 @note 内部统一加载本地icon或网络icon的处理逻辑，并会自动用subIcon数据的layout数据更新iconView的宽高约束
 @warning 调用此方法前iconView的宽高约束应该已经初始化过，否则会crash
 @warning 内部会根据数据控制调整iconView的hidden值
 */
+ (void)updateSubIconView:(UIImageView *)iconView subIcon:(TMCardComponentDataCoverSubIcon *)subIcon;

@end


NS_INLINE NSAttributedString *TMCardTool_generateShowTitleAttributedStringFromData(NSObject<TMCardComponentCellDataProtocol> *data, BOOL forCompute) {
    
    NSString *title = data.cover.title;
    if (title.length == 0) {return nil;}
    
    TMCardComponentDataContentTextTag *tag = data.content.textTag;
    NSString *textTagStr = tag.tag;
    
    NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    pStyle.lineSpacing = [TMCardComponentCellSizeTool NormalStyleCellTitleLineGap];
    pStyle.lineBreakMode = forCompute ? NSLineBreakByWordWrapping : NSLineBreakByTruncatingTail;
    
    if (textTagStr.length == 0) {
        NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:title attributes:@{NSParagraphStyleAttributeName: pStyle,
                        NSForegroundColorAttributeName: [TMCardComponentCellSizeTool NormalStyleCellTitleColor],
                        NSFontAttributeName: [TMCardComponentCellSizeTool NormalStyleCellTitleFont]
        }];
        return attributedStr;
    }else {
        
        UIColor *foreColor = [TMCardComponentCellSizeTool NormalStyleCellTitlTextTagForegroundColor];
        UIColor *backColor = [TMCardComponentCellSizeTool NormalStyleCellTitlTextTagBackgroundColor];
        UIFont *tagFont = [TMCardComponentCellSizeTool NormalStyleCellTitlTextTagFont];
        UIFont *titleFont = [TMCardComponentCellSizeTool NormalStyleCellTitleFont];
        if (tag.foregroundColor.length > 0) {
            foreColor = UIColorHexString(tag.foregroundColor) ?: foreColor;
        }
        if (tag.backgroundColor.length > 0) {
            backColor = UIColorHexString(tag.backgroundColor) ?: backColor;
        }
        
        NSDictionary *tagAttributes = @{
            NSForegroundColorAttributeName: [UIColor clearColor],//给透明色，相关文本标签的显示由子lbl负责显示，此原串透明用作布局占位合理的宽度
            NSFontAttributeName: tagFont,
            NSBaselineOffsetAttributeName: @(0.36 * (titleFont.pointSize - tagFont.pointSize)),
        };
        
        NSDictionary *titleAttributes = @{
            NSParagraphStyleAttributeName: pStyle,
            NSForegroundColorAttributeName: [TMCardComponentCellSizeTool NormalStyleCellTitleColor],
            NSFontAttributeName: titleFont,
        };
        //注意：UILabel显示text时，会自动将text末尾的空格trim掉，所以这里前面的文本标签与后面的title之间加一些空格以调整具体的UI显示效果
        NSString *tagShowStr = [NSString stringWithFormat:@" %@", textTagStr];
        NSString *titleShowStr = [NSString stringWithFormat:@"   %@", title];
        
        NSMutableAttributedString *mAttri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", tagShowStr, titleShowStr]];
        [mAttri setAttributes:tagAttributes range:NSMakeRange(0, tagShowStr.length)];
        [mAttri setAttributes:titleAttributes range:NSMakeRange(tagShowStr.length, titleShowStr.length)];
        [mAttri addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, mAttri.length)];
        
        THKTextTagLabelAttributedString *textTagAttributedString = [[THKTextTagLabelAttributedString alloc] initWithAttributedString:mAttri];
        textTagAttributedString.thk_drawBackgroundRange = NSMakeRange(0, tagShowStr.length);
        textTagAttributedString.thk_drawBackgroundColor = backColor;
        textTagAttributedString.thk_drawRangeTextColor = foreColor;
        
        return textTagAttributedString;
    }
    
}

NS_ASSUME_NONNULL_END
