//
//  TMCardComponentNormalStyleCell.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentNormalStyleCell.h"
#import "TMCardComponentCellSizeTool.h"
#import "TMCardComponentTool.h"
#import "THKTextTagLabel.h"

@interface TMCardComponentNormalStyleCell()
@property (nonatomic, strong) UIView *titleBoxView;///< 标题信息块视图，包含距离上部10pt间距及最多两行文本的高度和

@property (nonatomic, strong) THKTextTagLabel *titleLbl;///< 标题文本视图

@property (nonatomic, strong) UIView *subTitleBoxView;///< 描述信息块视图，包含距离上部8pt间距及一行文本的高度和，若有副标题显示则固定高度为8 + 16，若无则为0
@property (nonatomic, strong) UILabel *subTitleLbl;///< 副标题文本视图

@property (nonatomic, strong, readonly)NSDictionary<NSNumber *, UIImageView *> *subIconPositionMapIconViews;///< 显示在图片的小类型或其它修饰icon视图

@end

@implementation TMCardComponentNormalStyleCell
@synthesize subIconPositionMapIconViews = _subIconPositionMapIconViews;

TMCardComponentPropertyLazyLoad(UIView, titleBoxView);
TMCardComponentPropertyLazyLoad(THKTextTagLabel, titleLbl);
TMCardComponentPropertyLazyLoad(UIView, subTitleBoxView);
TMCardComponentPropertyLazyLoad(UILabel, subTitleLbl);



- (void)loadSubUIElement {
    [super loadSubUIElement];
    
    [self.contentView addSubview:self.titleBoxView];
    [self.contentView addSubview:self.subTitleBoxView];
    self.titleBoxView.clipsToBounds = YES;
    self.subTitleBoxView.clipsToBounds = YES;
    [self.titleBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImgView.mas_bottom);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    [self.subTitleBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.titleBoxView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
            
    [self.titleBoxView addSubview:self.titleLbl];
    [self.subTitleBoxView addSubview:self.subTitleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TMCardUIConfigConst_firstLabelTopMargin);
        make.leading.mas_equalTo(TMCardUIConfigConst_contentLeftRightMargin);
        make.trailing.mas_equalTo(-TMCardUIConfigConst_contentLeftRightMargin);
    }];
    [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(TMCardUIConfigConst_contentLeftRightMargin);
        make.trailing.mas_equalTo(-TMCardUIConfigConst_contentLeftRightMargin);
        make.height.mas_equalTo(TMCardUIConfigConst_singleLineLabelHeight);
    }];
    //加载初始化相关装修icons，默认为隐藏状态
    [self loadSubIcons];
    
    //
    self.titleLbl.numberOfLines = 2;
    self.titleLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLbl.font = [TMCardComponentCellSizeTool NormalStyleCellTitleFont];
    self.titleLbl.textColor = [TMCardComponentCellSizeTool NormalStyleCellTitleColor];
    self.subTitleLbl.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    self.subTitleLbl.textColor = UIColorHexString(@"999999");
    
#if DEBUG
    MASAttachKeys(self.titleBoxView, self.titleLbl, self.subTitleBoxView, self.subTitleLbl);
#endif
    
}

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {
    [super updateUIElement:data];
    
    [self.titleBoxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(data.layout_titleBoxViewHeight);
    }];
    [self.subTitleBoxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(data.layout_subTitleBoxViewHeight);
    }];
    
    if (data.cover.title.length > 0) {
        self.titleLbl.attributedText = TMCardTool_generateShowTitleAttributedStringFromData(data, NO);
        
        NSAttributedString *copyStr = self.titleLbl.attributedText.copy;
        copyStr.thk_drawBackgroundCornerRadius = self.titleLbl.attributedText.thk_drawBackgroundCornerRadius;
        copyStr.thk_drawBackgroundRange = self.titleLbl.attributedText.thk_drawBackgroundRange;
        copyStr.thk_drawBackgroundColor = self.titleLbl.attributedText.thk_drawBackgroundColor;
        copyStr.thk_drawRangeTextColor = self.titleLbl.attributedText.thk_drawRangeTextColor;
        
        // 使搜索分词高亮
        TSearchContentMakeKeywordsShowHighlightInLabelIfNeed(self.titleLbl, data);
        
        //恢复文本标签可能的相关数据赋值
        self.titleLbl.attributedText.thk_drawBackgroundCornerRadius = copyStr.thk_drawBackgroundCornerRadius;
        self.titleLbl.attributedText.thk_drawBackgroundRange = copyStr.thk_drawBackgroundRange;
        self.titleLbl.attributedText.thk_drawRangeTextColor = copyStr.thk_drawRangeTextColor;
        self.titleLbl.attributedText.thk_drawBackgroundColor = copyStr.thk_drawBackgroundColor;
        
    }else {
        self.titleLbl.text = nil;
    }
    
    self.subTitleLbl.text = data.cover.subTitle.length > 0 ? data.cover.subTitle : nil;
    
    //更新装修icons视图的内容显示或隐藏处理
    [self updateSubIcons];
}

- (void)updateSubIcons {
    //显示相关icon视图
    for (UIImageView *v in self.subIconPositionMapIconViews.allValues) {
        v.hidden = YES;
        v.image = nil;
    }
    for (TMCardComponentDataCoverSubIcon *subIcon in self.data.cover.subIcons) {
        UIImageView *iconView = self.subIconPositionMapIconViews[@(subIcon.position)];
        [TMCardComponentTool updateSubIconView:iconView subIcon:subIcon];        
    }
}

#pragma mark - subIcons
/**初始化相关icons视图,在需要显示时进行相关赋值显示，其它不显示的隐藏即可*/
- (void)loadSubIcons {
    float safeGap = TMCardUIConfigConst_floatingIconSafeMargin;
    //
    UIImageView *iconView = self.subIconPositionMapIconViews[@(TMCardComponentDataCoverSubIconPositionTopRight)];
    [self.coverImgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.top.mas_equalTo(safeGap);
        make.trailing.mas_equalTo(-safeGap);
    }];
    //
    iconView = self.subIconPositionMapIconViews[@(TMCardComponentDataCoverSubIconPositionTopLeft)];
    [self.coverImgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.top.mas_equalTo(safeGap);
        make.leading.mas_equalTo(safeGap);
    }];
    //
    iconView = self.subIconPositionMapIconViews[@(TMCardComponentDataCoverSubIconPositionBottomRight)];
    [self.coverImgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.bottom.mas_equalTo(-safeGap);
        make.trailing.mas_equalTo(-safeGap);
    }];
    //
    iconView = self.subIconPositionMapIconViews[@(TMCardComponentDataCoverSubIconPositionBottomLeft)];
    [self.coverImgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.bottom.mas_equalTo(-safeGap);
        make.leading.mas_equalTo(safeGap);
    }];
    //
    iconView = self.subIconPositionMapIconViews[@(TMCardComponentDataCoverSubIconPositionCenter)];
    [self.coverImgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.centerX.mas_equalTo(self.coverImgView.mas_centerX);
        make.centerY.mas_equalTo(self.coverImgView.mas_centerY);
    }];
    
    //初始时隐藏
    for (UIView *v in self.subIconPositionMapIconViews.allValues) {
        v.hidden = YES;
    }
}

- (NSDictionary<NSNumber *, UIImageView *> *)subIconPositionMapIconViews {
    if (!_subIconPositionMapIconViews) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSInteger i = TMCardComponentDataCoverSubIconPositionTopRight; i <= TMCardComponentDataCoverSubIconPositionCenter; ++i) {
            dic[@(i)] = ({
                UIImageView *iconView = [[UIImageView alloc] init];
                iconView.contentMode = UIViewContentModeScaleAspectFit;
                iconView.clipsToBounds = YES;
                iconView;
            });
        }
        _subIconPositionMapIconViews = dic.copy;
    }
    return _subIconPositionMapIconViews;
}

@end
