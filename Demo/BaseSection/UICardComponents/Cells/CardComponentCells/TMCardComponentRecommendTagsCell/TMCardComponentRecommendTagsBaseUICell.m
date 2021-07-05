//
//  TMCardComponentRecommendTagsBaseUICell.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/9/12.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentRecommendTagsBaseUICell.h"
#import "TMCardComponentUIConfigDefine.h"

@interface TMCardComponentRecommendTagsBaseUICell()

@end

@implementation TMCardComponentRecommendTagsBaseUICell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _defaultTitleLabelText = @"你可能在找";
        [self thk_setupViews];
    }
    return self;
}

- (void)thk_setupViews {
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = TMCardUIConfigConst_cardCornerRadius;
    [self.contentView addSubview:self.backgroundImageView];
    [self.contentView addSubview:self.searchIconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.tagImgViews enumerateObjectsUsingBlock:^(YYAnimatedImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    [self.tagNameLbls enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    [self.tagControls enumerateObjectsUsingBlock:^(UIControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    [self setupViewConstraints];
    [self configUIElement];
}

- (void)setupViewConstraints {
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.searchIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(16.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchIconImageView.mas_right).mas_offset(5.0);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-10.0);
        make.centerY.mas_equalTo(self.searchIconImageView);
    }];
    
    [self.tagControls[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(self.tagControls[0].mas_width).mas_offset(32 - 7);
    }];
    [self.tagControls[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagControls[0].mas_top);
        make.right.mas_equalTo(-12);
        make.left.mas_equalTo(self.tagControls[0].mas_right).mas_offset(10);
        make.bottom.mas_equalTo(self.tagControls[0].mas_bottom);
        make.width.mas_equalTo(self.tagControls[0].mas_width);
    }];
    [self.tagControls[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagControls[0].mas_left);
        make.right.mas_equalTo(self.tagControls[0].mas_right);
        make.top.mas_equalTo(self.tagControls[0].mas_bottom).mas_offset(7);
        make.height.mas_equalTo(self.tagControls[0].mas_height);
    }];
    [self.tagControls[3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.tagControls[1].mas_right);
        make.left.mas_equalTo(self.tagControls[1].mas_left);
        make.top.mas_equalTo(self.tagControls[2].mas_top);
        make.bottom.mas_equalTo(self.tagControls[2].mas_bottom);
    }];
    
    [self.tagImgViews enumerateObjectsUsingBlock:^(YYAnimatedImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tagControls[idx].mas_left);
            make.right.mas_equalTo(self.tagControls[idx].mas_right);
            make.top.mas_equalTo(self.tagControls[idx].mas_top);
            make.height.mas_equalTo(obj.mas_width);
        }];
    }];
    [self.tagNameLbls enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tagControls[idx].mas_left);
            make.right.mas_equalTo(self.tagControls[idx].mas_right);
            make.top.mas_equalTo(self.tagImgViews[idx].mas_bottom).mas_offset(5);
        }];
    }];
}

- (void)configUIElement {
    self.contentView.clipsToBounds = YES;
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.image = kImgAtBundle(@"search_recommendCard_backgroundImg");
    
    self.searchIconImageView.clipsToBounds = YES;
    self.searchIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.searchIconImageView.image = kImgAtBundle(@"search_recommendCard_searchIcon");
    
    self.titleLabel.font = UIFontMedium(14);
    self.titleLabel.textColor = UIColorHexString(@"333333");
    self.titleLabel.text = self.defaultTitleLabelText;
}

/**
 标签内容整体块视图点击的回调，子类实现具体的点击处理逻辑
 */
- (void)tagControlClick:(UIControl *)tagControl{ }

/**
 返回此卡片样式在瀑布流中显示时对应显示的尺寸。基础类会适配相关尺寸后返回
 */
+ (CGSize)tagsCellLayoutSize {
    static CGSize s_tagsCell_LayoutSize = {0, 0};
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat cellWidth = (kScreenWidth - 10.0 * 2.0 - 7.0) / 2.0;
        s_tagsCell_LayoutSize = [self tagsCellLayoutSizeWithCellWidth:cellWidth];
    });
    return s_tagsCell_LayoutSize;
}

+ (CGSize)tagsCellLayoutSizeWithCellWidth:(CGFloat)cellWidth {
    CGFloat height = 44;
    CGFloat tagBlockUI_height = (cellWidth - 12.0 * 2.0 - 10.0) / 2.0 + 32;
    height += (2 * tagBlockUI_height);
    return CGSizeMake(cellWidth, height);
}

#pragma mark - synthesize and lazy load properties

TMUI_PropertySyntheSize(defaultTitleLabelText);

TMUI_PropertySyntheSize(backgroundImageView);
TMUI_PropertySyntheSize(searchIconImageView);
TMUI_PropertySyntheSize(titleLabel);

TMUI_PropertySyntheSize(tagImgViews);
TMUI_PropertySyntheSize(tagNameLbls);
TMUI_PropertySyntheSize(tagControls);

TMUI_PropertyLazyLoad(UIImageView, backgroundImageView);
TMUI_PropertyLazyLoad(UIImageView, searchIconImageView);
TMUI_PropertyLazyLoad(UILabel, titleLabel);

- (NSArray<YYAnimatedImageView *> *)tagImgViews {
    if (!_tagImgViews) {
        NSMutableArray *ls = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; ++i) {
            YYAnimatedImageView *imgView = [[YYAnimatedImageView alloc] init];
            imgView.backgroundColor = UIColorHexString(@"F0F1F5");
            imgView.clipsToBounds = YES;
            imgView.layer.cornerRadius = 4;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [ls addObject:imgView];
        }
        _tagImgViews = ls;
    }
    return _tagImgViews;
}

- (NSArray<UILabel *> *)tagNameLbls {
    if (!_tagNameLbls) {
        NSMutableArray *ls = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; ++i) {
            UILabel *lbl = [[UILabel alloc] init];
            lbl.clipsToBounds = YES;
            lbl.font = UIFontRegular(10);
            lbl.textColor = UIColorHexString(@"333333");
            lbl.textAlignment = NSTextAlignmentLeft;
            [ls addObject:lbl];
        }
        _tagNameLbls = ls;
    }
    return _tagNameLbls;
}

- (NSArray<UIControl *> *)tagControls {
    if (!_tagControls) {
        NSMutableArray *ls = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; ++i) {
            UIButton *control = [[UIButton alloc] init];
            control.tag = i;
            control.clipsToBounds = YES;
            [control addTarget:self action:@selector(tagControlClick:) forControlEvents:UIControlEventTouchUpInside];
            [ls addObject:control];
        }
        _tagControls = ls;
    }
    return _tagControls;
}

@end
