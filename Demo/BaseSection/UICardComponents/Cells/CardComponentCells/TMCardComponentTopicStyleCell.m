//
//  TMCardComponentTopicStyleCell.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/6/11.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentTopicStyleCell.h"
#import "TMCardComponentCellSizeTool.h"
#import "TTagShapeColorView.h"

@interface TMCardComponentTopicStyleCell()

@property (nonatomic)UIImageView *bgMaskImgView;///< 封面图的遮罩，效果为底部往上在一定区域内黑色渐变到透明色 | cardComponent_topic_bgMaskImg

@property (nonatomic, strong)UIImageView *topicIconView;///< 话题样式icon，取bottom.imageUrl字段| 若无此字段则读取本地缓存的默认icon (cardComponent_topic_icon)

@property (nonatomic, strong)UIView *bottomContentView;///< 底部的内容容器视图

@property (nonatomic, strong)UILabel *topicTitleLbl;///< 话题具体名的lbl，取title字段

@property (nonatomic, strong)UIView *avatarListBoxView;///< 多个头像容器视图
@property (nonatomic, strong, readonly)NSArray<UIImageView *> *avatarViews;///< 4个头像视图,实际显示需要根据相关数据. 展示内容对应content.imgs
@property (nonatomic, strong)UILabel *topicOtherLbl;///< 话题样式底部的lbl，固定 "参与话题"，取subTitle字段

@end

@implementation TMCardComponentTopicStyleCell

TMCardComponentPropertyLazyLoad(UIImageView, bgMaskImgView);
TMCardComponentPropertyLazyLoad(UIImageView, topicIconView);

TMCardComponentPropertyLazyLoad(UIView, bottomContentView);
TMCardComponentPropertyLazyLoad(UILabel, topicTitleLbl);

TMCardComponentPropertyLazyLoad(UIView, avatarListBoxView);
TMCardComponentPropertyLazyLoad(UILabel, topicOtherLbl);

TMCardComponentProtocolSyntheSize(avatarViews);
- (NSArray<UIImageView *> *)avatarViews {
    if (!_avatarViews) {
        NSMutableArray *ls = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; ++i) {
            [ls safeAddObject:({
                UIImageView *iView = [[UIImageView alloc] init];
                iView.clipsToBounds = YES;
                iView.layer.borderColor = [UIColor whiteColor].CGColor;
                iView.layer.borderWidth = 1;
                iView.layer.cornerRadius = 8;
                iView.layer.allowsEdgeAntialiasing = YES;
                iView;
            })];
        }
        _avatarViews = ls;
    }
    return _avatarViews;
}

- (void)loadSubUIElement {
    [super loadSubUIElement];
    [self.contentView addSubview:self.bgMaskImgView];
    [self.bgMaskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.contentView addSubview:self.bottomContentView];
    [self.contentView addSubview:self.topicIconView];
    
    [self.bottomContentView addSubview:self.topicTitleLbl];
    [self.bottomContentView addSubview:self.avatarListBoxView];
    [self.bottomContentView addSubview:self.topicOtherLbl];
    
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(5);
        make.trailing.mas_equalTo(-5);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.topicIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.leading.mas_equalTo(self.bottomContentView.mas_leading).mas_offset(10);
        make.centerY.mas_equalTo(self.bottomContentView.mas_top);
    }];
    
    [self.topicTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.top.mas_equalTo(15);
    }];
    
    [self.avatarListBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.bottom.mas_equalTo(self.bottomContentView.mas_bottom).mas_offset(-12);
        make.width.mas_equalTo(0);//n(n>0)个头像显示时宽度应该为(16 - 3) * (n-1) + 16
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(self.topicTitleLbl.mas_bottom).mas_equalTo(6);
    }];
    
    for (NSInteger i = 0; i < self.avatarViews.count; ++i) {
        UIView *v = self.avatarViews[i];
        [self.avatarListBoxView addSubview:v];
        v.alpha = 0;
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(16);
            make.leading.mas_equalTo((16 - 3) * i);
            make.centerY.mas_equalTo(self.avatarListBoxView.mas_centerY);
        }];
    }
    
    [self.topicOtherLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarListBoxView.mas_leading).mas_offset(0);
        make.trailing.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.avatarListBoxView.mas_centerY);
    }];
    
    //
    self.bgMaskImgView.image = [UIImage imageNamed:@"cardComponent_topic_bgMaskImg"];
    
    self.bottomContentView.backgroundColor = [UIColor whiteColor];
    self.bottomContentView.clipsToBounds = YES;
    self.bottomContentView.layer.cornerRadius = 4;
    
    self.topicIconView.clipsToBounds = YES;
    self.topicIconView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.topicTitleLbl.font = [TMCardComponentCellSizeTool TopicStyleCellTitleFont];
    self.topicTitleLbl.textColor = UIColorHexString(@"1A1C1A");//333333
    self.topicTitleLbl.numberOfLines = 2;
    
    self.avatarListBoxView.clipsToBounds = YES;
    
    self.topicOtherLbl.font = UIFont(10);
    self.topicOtherLbl.textColor = UIColorHexString(@"999999");
                
#if DEBUG
    MASAttachKeys(self.bgMaskImgView, self.bottomContentView, self.topicIconView, self.topicTitleLbl, self.avatarListBoxView, self.topicOtherLbl);
#endif
    
}

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {
    [super updateUIElement:data];
    
    if (data.bottom.imgUrl.length > 0) {
        [self.topicIconView loadImageWithUrlStr:data.bottom.imgUrl];
    }else {
        self.topicIconView.image = [UIImage imageNamed:@"cardComponent_topic_icon"];
    }
            
    if (data.cover.title.length > 0) {
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
        pStyle.lineSpacing = [TMCardComponentCellSizeTool TopicStyleCellTitleLineGap];
        pStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.topicTitleLbl.attributedText = [[NSAttributedString alloc] initWithString:data.cover.title
                                                                       attributes:@{NSParagraphStyleAttributeName: pStyle}];
        
        // 使搜索分词高亮
        TSearchContentMakeKeywordsShowHighlightInLabelIfNeed(self.topicTitleLbl, data);
        
    }else {
        self.topicTitleLbl.text = nil;
    }
    
    //最多显示4个头像
    NSInteger imgCount = MIN(4, data.cover.imgs.count);
    NSInteger listBoxViewWidth = imgCount > 0 ? ((16 - 3) * (imgCount - 1) + 16) : 0;
    [self.avatarListBoxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(listBoxViewWidth);
    }];
    [self.topicOtherLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarListBoxView.mas_leading).mas_offset(listBoxViewWidth > 0 ? listBoxViewWidth + 6 : 0);
    }];
    for (NSInteger i = 0; i < self.avatarViews.count; ++i) {
        if (i < imgCount) {
            [self.avatarViews[i] loadImageWithUrlStr:data.cover.imgs[i] placeHolderImage:kDefaultHeadPortrait_60];
            self.avatarViews[i].alpha = 1;
        }else {
            self.avatarViews[i].image = nil;
            self.avatarViews[i].alpha = 0;
        }
    }
    self.topicOtherLbl.text = data.cover.subTitle.length > 0 ? data.cover.subTitle : @"0参与";
}

@end
