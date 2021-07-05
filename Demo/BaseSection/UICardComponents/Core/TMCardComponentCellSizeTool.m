//
//  TMCardComponentCellSizeTool.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentCellSizeTool.h"
#import "TMCardComponentUIConfigDefine.h"
#import "TMCardcomponentRecommendTagsCell.h"
#import "TMCardComponentTool.h"

@implementation TMCardComponentCellSizeTool

extern CGFloat CHTFloorCGFloat(CGFloat value);

+ (void)loadCellSizeToCellDataIfNeed:(NSObject<TMCardComponentCellDataProtocol> *)data layout:(__kindof CHTCollectionViewWaterfallLayout*)layout {
    [self loadCellSizeToCellDataIfNeed:data layout:layout sectionInset:UIEdgeInsetsZero];
}

+ (void)loadCellSizeToCellDataIfNeed:(NSObject<TMCardComponentCellDataProtocol> *)data layout:(__kindof CHTCollectionViewWaterfallLayout*)layout sectionInset:(UIEdgeInsets )sectionInset {
    if (data.style != TMCardComponentCellStyleCustom) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        if (!UIEdgeInsetsEqualToEdgeInsets(sectionInset, UIEdgeInsetsZero)) {
            size.width = CHTFloorCGFloat((size.width - layout.minimumColumnSpacing - sectionInset.left - sectionInset.right)/2);
        }
        else {
            size.width = CHTFloorCGFloat((size.width - layout.minimumColumnSpacing - layout.sectionInset.left - layout.sectionInset.right)/2);
        }
        
        if (data.style >= TMCardComponentCellStyleNotSupport) {
            size.height = size.width;
            data.layout_cellSize = size;
            return;
        }
        
        if (data.style == TMCardComponentCellStyleRecommendTags) {
            //推荐标签卡片样式尺寸单独处理
            data.layout_cellSize = [TMCardComponentRecommendTagsCell tagsCellLayoutSizeWithCellWidth:size.width];
            return;
        }
    
        //coverHeight
        if (data.cover.width == 0) {
            data.cover.width = 1;
        }
        if (data.cover.height == 0) {
            data.cover.height = 1;
        }
        float width = data.cover.width;
        float height = data.cover.height;
        float heightToWidthRatio = 1.0f;
        if(!isnan(width) && !isnan(height)) {
            heightToWidthRatio = height/width;
            //若外部未放开封面宽高比的限制则将其限定在指定的范围值内 | 此值默认为NO，即默认会按统一限制逻辑处理
            if (!data.cover.isFreeCoverSizeLimit) {
//                float maxRatio = 4.0f/3.0f;
//                float minRatio = 3.0f/4.0f;
                //v8.10 调整封面图比例裁剪范围
                float maxRatio = 3.0f/2.0f;
                float minRatio = 1.0f/1.0f;
                heightToWidthRatio = MIN(heightToWidthRatio, maxRatio);
                heightToWidthRatio = MAX(heightToWidthRatio, minRatio);
            }
        }
        data.layout_coverShowHeight = ceilf(size.width * heightToWidthRatio);
        
        //中间的标题、副标题文本显示的高度,标题最多显示两行需要单独计算，副标题若有则显示一行固定高度
        float titleBoxViewHeight = 0;
        float subTitleBoxViewHeight = 0;
        
        //bottomViewHeight
        data.layout_bottomViewHeight = 0;//初始值0
        BOOL needShowBottom = NO;
        if (data.bottom.title.length > 0 ||
            data.interaction.text.length > 0 ||
            data.bottom.imgUrl.length > 0) {
            needShowBottom = YES;
        }
        
        if (data.style == TMCardComponentCellStyleQa ||
            data.style == TMCardComponentCellStyleTopic ||
            data.style == TMCardComponentCellStyleVideoSets ||
            data.style == TMCardComponentCellStyleLive) {
            //8.6 新的话题样式底部没有公共的底部视图
            //8.6 新的问答样式底部没有公共的底部视图
            //8.8 增加的视频集底部没有公共的底部视图
            //8.13 调整直播卡片样式，底部没有公共的底部视图
            needShowBottom = NO;
        }
        
        if (needShowBottom) {
            data.layout_bottomViewHeight = TMCardUIConfigConst_bottomBoxViewShowHeight;
        }
        
        //其它非通用的区域额外的高度
        //底部标题、副标题区域(根据实际UI样式)
        float plusAreaHeight = 0;
        if (data.style == TMCardComponentCellStyleVideoSets) {
            //8.8 add 视频集 封面图片宽高比固定为1：1
            data.layout_coverShowHeight = ceilf(size.width);
            plusAreaHeight += 4*2;//图片下方叠加的两张图多出的高度和
            //title上方10边距、title和subTitle间距8,subTitle下方留出12的边距
            //title一定会有值且显示一行所以UI布局按从上往下布局显示即可，不需要添加额外的titleBoxview等辅助视图
            plusAreaHeight += TMCardUIConfigConst_firstLabelTopMargin;
            
            //title height
            float txtHeight = [NSAttributedString tmui_heightForString:kUnNilStr(data.cover.title)
                                                                  font:[self NormalStyleCellTitleFont]
                                                                 width:size.width - TMCardUIConfigConst_contentLeftRightMargin*2
                                                           lineSpacing:[self NormalStyleCellTitleLineGap]
                                                          maxLine:2];
            plusAreaHeight += ceilf(txtHeight);
            
            if (data.cover.subTitle.length > 0) {
                plusAreaHeight += TMCardUIConfigConst_secondLabelTopMargin;
                plusAreaHeight += TMCardUIConfigConst_singleLineLabelHeight;
            }
            plusAreaHeight += TMCardUIConfigConst_bottomMargin;//底部边距
                        
        }else if (data.style == TMCardComponentCellStyleTopic) {
            //v8.10 话题样式重新调整-封面铺满 | 设计稿宽高：174x232，定义为卡片高度固定:232
            //8.7调整规则：话题时图片宽高比固定为1：1            
            data.layout_coverShowHeight = 232;
        }else if (data.style == TMCardComponentCellStyleQa) {
            //问答整体高度单独处理，根据实际是否显示回答内容分别对应两种高度的样式
            BOOL hasAnswersShow = data.cover.contents.count > 0;
            if (hasAnswersShow) {
                data.layout_coverShowHeight = 234;
            }else {
                data.layout_coverShowHeight = 193;
            }
            
        }else if (data.style == TMCardComponentCellStyleNormal ||
                  data.style == TMCardComponentCellStyleLive) {
            //图文样式因有标题、副标题在图片与底部视图中间，需要单独判断处理
            //标题、副标题上下位置显示的样式
            BOOL hasTitle = data.cover.title.length > 0;
            BOOL hasSubTitle = data.cover.subTitle.length > 0;
            
            if (!needShowBottom) {
                //无bottom视图显示但有标题或副标题显示时，底部留出安全的空白高度
                if (hasTitle || hasSubTitle) {
                    data.layout_bottomViewHeight = TMCardUIConfigConst_bottomMargin;
                }
            }
            
            //副标题显示区域整体高度，包含距离上方文本视图的间距
            subTitleBoxViewHeight = hasSubTitle ? (TMCardUIConfigConst_secondLabelTopMargin + TMCardUIConfigConst_singleLineLabelHeight) : 0;
            //计算标题显示区域块整体高度，包含上面10pt的间距
            if (hasTitle) {
                titleBoxViewHeight = TMCardUIConfigConst_firstLabelTopMargin;
                if (hasTitle) {
                    float txtHeight = 0;
                    if (data.content.textTag.tag.length > 0) {
                        //标题串前显示标签文本，相关高度重新计算
                        txtHeight = [self showHeightOfStorageAttributedTitleFromData:data inCellSize:size];
                    }else {
                        //无标签文本时，按原有标题串计算显示高度
                        txtHeight = [NSAttributedString tmui_heightForString:data.cover.title
                                                                         font:[self NormalStyleCellTitleFont]
                                                                        width:size.width - TMCardUIConfigConst_contentLeftRightMargin*2
                                                                 lineSpacing:[self NormalStyleCellTitleLineGap]
                                                                      maxLine:2];
                    }
                    
                    titleBoxViewHeight += ceilf(txtHeight);
                }
            } else {
                if (hasSubTitle) {
                    // 若无标题但有副标题则标题区域块视图需要额外2pt的高度以保证单独显示的副标题距离顶部间距为10pt的效果
                    titleBoxViewHeight = (TMCardUIConfigConst_firstLabelTopMargin - TMCardUIConfigConst_secondLabelTopMargin);
                }
            }
            
            if (!hasTitle &&
                !hasSubTitle) {
                //无文本数据，仅有一个底部视图显示时，需要微调高度修正一下显示的视觉效果
                if (needShowBottom) {
                    data.layout_bottomViewHeight += TMCardUIConfigConst_bottomBoxViewShowHeightFixTopMarginPlus;
                }
            }
        }else if (data.style == TMCardComponentCellStyleTitleAndSubTitleUpSideDown) {
            //副标题、标题位置颠倒效果
            //案例、日记可能用到(副标题可用于显示标签串)
            BOOL hasTitle = data.cover.title.length > 0;
            BOOL hasSubTitle = data.cover.subTitle.length > 0;
                        
            if (!needShowBottom) {
                //无bottom视图显示但有标题或副标题显示时，底部留出12pt的空白高度
                if (hasTitle || hasSubTitle) {
                    data.layout_bottomViewHeight = TMCardUIConfigConst_bottomMargin;
                }
            }
                        
            //计算标题显示区域块整体高度，包含上面8pt的间距
            if (hasTitle) {
                float txtHeight = 0;
                if (data.content.textTag.tag.length > 0) {
                    //标题串前显示标签文本，相关高度重新计算
                    txtHeight = [self showHeightOfStorageAttributedTitleFromData:data inCellSize:size];
                }else {
                    //无标签文本时，按原有标题串计算显示高度
                    
                    txtHeight = [NSAttributedString tmui_heightForString:data.cover.title
                                                                     font:[self NormalStyleCellTitleFont]
                                                                    width:size.width - TMCardUIConfigConst_contentLeftRightMargin*2
                                                             lineSpacing:[self NormalStyleCellTitleLineGap]
                                                                  maxLine:2];
                }
                
                titleBoxViewHeight = TMCardUIConfigConst_secondLabelTopMargin + ceilf(txtHeight);
            }
            
            //副标题显示区域整体高度，包含上面10pt的间距
            if (hasSubTitle) {
                subTitleBoxViewHeight = TMCardUIConfigConst_firstLabelTopMargin + TMCardUIConfigConst_singleLineLabelHeight;
            }else {
                // 若无副标题但有标题则副标题区域块视图需要额外2pt的高度以保证单独显示的标题距离顶部间距为10pt的效果
                if (hasTitle) {
                    subTitleBoxViewHeight = (TMCardUIConfigConst_firstLabelTopMargin - TMCardUIConfigConst_secondLabelTopMargin);
                }
            }
            
            if (!hasTitle &&
                !hasSubTitle) {
                //无文本数据，仅有一个底部视图显示时，需要微调高度修正一下显示的视觉效果
                if (needShowBottom) {
                    data.layout_bottomViewHeight += TMCardUIConfigConst_bottomBoxViewShowHeightFixTopMarginPlus;
                }
            }
        }
        
        data.layout_titleBoxViewHeight = titleBoxViewHeight;
        data.layout_subTitleBoxViewHeight = subTitleBoxViewHeight;
        
        //cellSizeHeight
        size.height = data.layout_coverShowHeight + data.layout_bottomViewHeight + plusAreaHeight;
        if (data.style == TMCardComponentCellStyleNormal ||
            data.style == TMCardComponentCellStyleLive ||
            data.style == TMCardComponentCellStyleTitleAndSubTitleUpSideDown) {
            size.height += data.layout_titleBoxViewHeight;
            size.height += data.layout_subTitleBoxViewHeight;
        }
        data.layout_cellSize = size;
        
        NSString *errorStr = [NSString stringWithFormat:@"TMCardComponentCellSizeTool loadCellSizeToCellDataIfNeed logic err\ndataclass:%@, style:%@ CoverTitle:%@",NSStringFromClass([data class]),@(data.style),data.cover.title];
        NSAssert(data.layout_cellSize.height >= data.layout_coverShowHeight, errorStr);
    }
}

+ (CGFloat)showHeightOfStorageAttributedTitleFromData:(NSObject<TMCardComponentCellDataProtocol> *)data inCellSize:(CGSize)size {
    NSAttributedString *attriStr = TMCardTool_generateShowTitleAttributedStringFromData(data, YES);
    CGSize fitSize = [attriStr boundingRectWithSize:CGSizeMake(size.width - TMCardUIConfigConst_contentLeftRightMargin * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    float attriStrHeight = fitSize.height;
    float limitTwoLineHeight = [NSAttributedString heightForAtsWithStr:attriStr.string
                                                                  font:[self NormalStyleCellTitleFont]
                                                                 width:size.width - TMCardUIConfigConst_contentLeftRightMargin*2
                                                                 lineH:[self NormalStyleCellTitleLineGap]
                                                               maxLine:2];
    float txtHeight = ceilf(MIN(attriStrHeight, limitTwoLineHeight));
    return txtHeight;
}

#pragma mark - 辅助方法字体、行间距等
///MARK: 主要用于NormalStyle样式里的标题文本高度计算
+ (CGFloat)NormalStyleCellTitleLineGap {
    return 3;
}
+ (UIFont *)NormalStyleCellTitleFont {
    return  [UIFont fontWithName:@"PingFangSC-Medium" size:14];//UIFont(14);
}

+ (UIColor *)NormalStyleCellTitleColor {
    return UIColorHexString(@"333333");
}

+ (UIFont *)NormalStyleCellTitlTextTagFont {
    return  UIFontMedium(10);
}

+ (UIColor *)NormalStyleCellTitlTextTagForegroundColor {
    return  UIColor.whiteColor;
}
+ (UIColor *)NormalStyleCellTitlTextTagBackgroundColor {
    return  UIColorHexString(@"878b99");
}

///MARK: 主要用于TopicStyle样式里的标题文本高度计算
+ (UIFont *)TopicStyleCellTitleFont {
    return  UIFont(14);
}
+ (CGFloat)TopicStyleCellTitleLineGap {
    return 3;
}

@end
