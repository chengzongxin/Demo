//
//  TMCardComponentQaStyleCell.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/6/11.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentQaStyleCell.h"
#import "TMCardComponentCellSizeTool.h"

#pragma mark - ========================================================================
#pragma mark - TMCardComponentQaStyleCellContentLabel
@interface TMCardComponentQaStyleCellContentLabel : UIView

@property(nonatomic, strong, readonly)NSMutableArray<UILabel *> *labels;


- (void)makeLabelConfig:(void(^)(UILabel *))lblConfigBlock;
- (void)updateText:(NSAttributedString *_Nullable)nStr;
- (void)updateText:(NSAttributedString *_Nullable)nStr animate:(BOOL)animate;

@end

@implementation TMCardComponentQaStyleCellContentLabel
@synthesize labels = _labels;
- (NSMutableArray<UILabel *> *)labels {
    if (!_labels) {
        _labels = @[({
                        UILabel *lbl = [[UILabel alloc] init];
                        lbl;
                    }),
                    ({
                        UILabel *lbl = [[UILabel alloc] init];
                        lbl;
                    })].mutableCopy;
    }
    return _labels;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    self.clipsToBounds = YES;
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(self.mas_bottom).mas_offset(0);
        }];
    }];
}

- (void)makeLabelConfig:(void(^)(UILabel *))lblConfigBlock {
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        lblConfigBlock(obj);
    }];
}

- (void)updateText:(NSAttributedString *_Nullable)nStr {
    [self updateText:nStr animate:NO];
}

- (void)updateText:(NSAttributedString *_Nullable)nStr animate:(BOOL)animate {
    UILabel *firstLbl = [self.labels firstObject];
    UILabel *secondLbl = self.labels.lastObject;
    firstLbl.alpha = 1;
    secondLbl.alpha = 0;
    if (!animate || firstLbl.text.length == 0) {
        [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.bottom.mas_lessThanOrEqualTo(self.mas_bottom).mas_offset(0);
            }];
        }];
        firstLbl.attributedText = nStr;
        secondLbl.attributedText = nil;
        
        [self setNeedsUpdateConstraints];
        [self updateConstraints];
        [self layoutIfNeeded];
        
        return;
    }
    //
    secondLbl.attributedText = nStr;
    [self.labels removeObject:firstLbl];
    [self.labels addObject:firstLbl];
    
    [secondLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_lessThanOrEqualTo(self.mas_bottom).mas_offset(10);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [firstLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-10);
            make.bottom.mas_lessThanOrEqualTo(self.mas_bottom).mas_offset(-10);
        }];
        firstLbl.alpha = 0;
        [self setNeedsUpdateConstraints];
        [self updateConstraints];
        [self layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:0.16 delay:0.08 options:UIViewAnimationOptionCurveLinear animations:^{
        [secondLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(self.mas_bottom).mas_offset(0);
        }];
        secondLbl.alpha = 1;
        [self setNeedsUpdateConstraints];
        [self updateConstraints];
        [self layoutIfNeeded];
    } completion:nil];
}

@end


#pragma mark - ========================================================================
#pragma mark - TMCardComponentQaStyleCell
@interface TMCardComponentQaStyleCell()
@property (nonatomic, strong)UIView *topLeftTipBgView;
@property (nonatomic, strong)UIImageView *tipIconView;
@property (nonatomic, strong)UILabel *tipLbl;

@property (nonatomic, strong)UILabel *qTitleLbl;

@property (nonatomic, strong)UIView *avatarListBoxView;
@property (nonatomic, strong)NSMutableArray<UIImageView *> *avatarViews;

///以下accessoryView当无回答或回答的头像数量只有1个时不显示，只有多玩1个头像才显示
@property (nonatomic, strong)UIView *rightAccessoryView;
@property (nonatomic, strong)UILabel *rightAccessoryLbl;
@property (nonatomic, strong)UIImageView *rightAccessoryIcon;

///以下视图根据实际回答文本是否有数据来进行显示或隐藏
@property (nonatomic, strong)UIView *answerFrameBgView;
@property (nonatomic, strong)UIView *answerFrameContentBoxView;
@property (nonatomic, strong)UIImageView *answerFrameContentBoxArrowView;
@property (nonatomic, strong)TMCardComponentQaStyleCellContentLabel *answerContentLbl;

@property (nonatomic, assign)NSInteger avatarIdx;
@property (nonatomic, assign)NSInteger contentIdx;
@end

@implementation TMCardComponentQaStyleCell
TMCardComponentPropertyLazyLoad(UIView, topLeftTipBgView);
TMCardComponentPropertyLazyLoad(UIImageView, tipIconView);
TMCardComponentPropertyLazyLoad(UILabel, tipLbl);

TMCardComponentPropertyLazyLoad(UILabel, qTitleLbl);

TMCardComponentPropertyLazyLoad(UIView, avatarListBoxView);

TMCardComponentPropertyLazyLoad(UIView, rightAccessoryView);
TMCardComponentPropertyLazyLoad(UILabel, rightAccessoryLbl);
TMCardComponentPropertyLazyLoad(UIImageView, rightAccessoryIcon);

TMCardComponentPropertyLazyLoad(UIView, answerFrameBgView);
TMCardComponentPropertyLazyLoad(UIView, answerFrameContentBoxView);
TMCardComponentPropertyLazyLoad(UIImageView, answerFrameContentBoxArrowView);
TMCardComponentPropertyLazyLoad(TMCardComponentQaStyleCellContentLabel, answerContentLbl);

- (NSMutableArray<UIImageView *> *)avatarViews {
    if (!_avatarViews) {
        NSMutableArray *ls = [NSMutableArray array];
        for (NSInteger i = 0; i < 4 + 1; ++i) {
            [ls safeAddObject:({
                UIImageView *iView = [[UIImageView alloc] init];
                iView.clipsToBounds = YES;
                iView.layer.borderColor = [UIColor whiteColor].CGColor;
                iView.layer.borderWidth = 1;
                iView.layer.cornerRadius = 10;
                iView.layer.allowsEdgeAntialiasing = YES;
                iView;
            })];
        }
        _avatarViews = [NSMutableArray arrayWithArray:ls];
    }
    return _avatarViews;
}

- (void)loadSubUIElement {
    [super loadSubUIElement];
    
    //左上角视图
    [self.coverImgView addSubview:self.topLeftTipBgView];
    [self.topLeftTipBgView addSubview:self.tipIconView];
    [self.topLeftTipBgView addSubview:self.tipLbl];
    [self.topLeftTipBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    [self.tipIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(3);
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.topLeftTipBgView.mas_centerY);
    }];
    [self.tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.tipIconView.mas_trailing).mas_offset(5);
        make.trailing.mas_equalTo(-8);
        make.centerY.mas_equalTo(self.tipIconView.mas_centerY);
    }];
    
    //提问title
    [self.coverImgView addSubview:self.qTitleLbl];
    [self.qTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.topLeftTipBgView.mas_bottom).mas_offset(20);
    }];
    
    //头像及rightAccessoryView
    self.avatarListBoxView.clipsToBounds = NO;//设置为NO以保正头像前后动画效果时超出的部分不会被截断，显示相关动画过渡更加自然
    [self.coverImgView addSubview:self.avatarListBoxView];
    [self.avatarListBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(4);
        make.top.mas_equalTo(122);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    for (NSInteger i = self.avatarViews.count - 1; i >= 0; --i) {
        UIView *v = self.avatarViews[i];
        [self.avatarListBoxView addSubview:v];
        v.alpha = 0;
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
            make.centerY.mas_equalTo(self.avatarListBoxView.mas_centerY);
            make.leading.mas_equalTo(8 + i * 14);
        }];
    }
    
    //xx个问答 >
    self.rightAccessoryView.hidden = YES;
    [self.coverImgView addSubview:self.rightAccessoryView];
    [self.rightAccessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarListBoxView.mas_trailing).mas_offset(12);
        make.centerY.mas_equalTo(self.avatarListBoxView.mas_centerY);
        make.trailing.mas_equalTo(-12);
        make.height.mas_equalTo(20);
    }];
        
    [self.rightAccessoryView addSubview:self.rightAccessoryLbl];
    [self.rightAccessoryView addSubview:self.rightAccessoryIcon];
    self.rightAccessoryIcon.image = [UIImage imageNamed:@"qaCard_accessoryIcon"];
    self.rightAccessoryIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightAccessoryIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(10);
        make.centerY.mas_equalTo(self.rightAccessoryView.mas_centerY);
    }];
    
    [self.rightAccessoryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.rightAccessoryIcon.mas_leading).mas_offset(-5);
        make.centerY.mas_equalTo(self.rightAccessoryView.mas_centerY);
        make.leading.mas_equalTo(0);
    }];
    
    //回答内容
    self.answerFrameBgView.hidden = YES;
    
    [self.coverImgView addSubview:self.answerFrameBgView];
    [self.answerFrameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.trailing.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(75);
    }];
    
    [self.answerFrameBgView addSubview:self.answerFrameContentBoxArrowView];
    [self.answerFrameBgView addSubview:self.answerFrameContentBoxView];
    [self.answerFrameContentBoxArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(10);
        make.leading.mas_equalTo(8);
    }];
    [self.answerFrameContentBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.answerFrameContentBoxArrowView.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.answerFrameBgView);
    }];
    
    [self.answerFrameContentBoxView addSubview:self.answerContentLbl];
    [self.answerContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {        
        make.leading.top.mas_equalTo(8);
        make.trailing.mas_equalTo(-8);
    }];
    
    //
    self.topLeftTipBgView.clipsToBounds = YES;
    self.topLeftTipBgView.layer.cornerRadius = 10;
    self.topLeftTipBgView.backgroundColor = THKColor_MainColor;
    self.tipLbl.textColor = [UIColor whiteColor];
    self.tipLbl.font = UIFontMedium(12);
    self.tipLbl.text = @"问答";
    
    self.qTitleLbl.font = UIFontSemibold(16);
    self.qTitleLbl.textColor = [UIColor whiteColor];
    self.qTitleLbl.numberOfLines = 2;
    
    self.rightAccessoryLbl.font = UIFontRegular(12);
    self.rightAccessoryLbl.adjustsFontSizeToFitWidth = YES;
    self.rightAccessoryLbl.minimumScaleFactor = 0.7;
    self.rightAccessoryLbl.textColor = [UIColor whiteColor];
    self.rightAccessoryLbl.textAlignment = NSTextAlignmentRight;
    
    [self.answerContentLbl makeLabelConfig:^(UILabel *t_lbl) {
        t_lbl.font = UIFontRegular(12);
        t_lbl.textColor = UIColorHexString(@"37435D");
        t_lbl.numberOfLines = 3;
    }];
    self.answerFrameContentBoxArrowView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.answerFrameContentBoxArrowView.image = [UIImage tmui_imageWithShape:TMUIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.95]];
    self.answerFrameContentBoxView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    self.answerFrameContentBoxView.layer.cornerRadius = 2;
    self.answerFrameContentBoxView.clipsToBounds = YES;
    
#if DEBUG
    MASAttachKeys(self.topLeftTipBgView, self.tipIconView, self.tipLbl, self.qTitleLbl, self.avatarListBoxView, self.rightAccessoryView, self.rightAccessoryLbl, self.rightAccessoryIcon, self.answerFrameBgView, self.answerFrameContentBoxView, self.answerFrameContentBoxArrowView, self.answerContentLbl);
#endif
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self cancelUpdateAnswerUIDelayActionsAndResetIdxs];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) {
        [self cancelUpdateAnswerUIDelayActionsAndResetIdxs];
    }
}

- (void)cancelUpdateAnswerUIDelayActionsAndResetIdxs {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateAnswerLabelAfterAvatarAnimation) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateAnswerAvatars) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateAnswerLabel) object:nil];
    self.contentIdx = 0;
    self.avatarIdx = 0;
}

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {
//    if ([self.data isEqual:data]) {return;}
    
    [self cancelUpdateAnswerUIDelayActionsAndResetIdxs];
    
    [super updateUIElement:data];
    
    //左上角视图
    [self.tipIconView loadImageWithUrlStr:self.data.bottom.imgUrl];
    self.tipLbl.text = self.data.bottom.title.length > 0 ? self.data.bottom.title : @"问答";
    
    //提问的标题
    if (data.cover.title.length > 0) {
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
        pStyle.lineSpacing = 3;
        pStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.qTitleLbl.attributedText = [[NSAttributedString alloc] initWithString:data.cover.title
                                                                       attributes:@{NSParagraphStyleAttributeName: pStyle}];
        
        // 使搜索分词高亮
        TSearchContentMakeKeywordsShowHighlightInLabelIfNeed(self.qTitleLbl, data);
        
    }else {
        self.qTitleLbl.text = nil;
    }
    
    //回答者头像
    NSInteger count = MIN(4, data.cover.imgs.count);
    float imgListBoxWidth = 0;
    if (count > 0 && count <= 4) {
        imgListBoxWidth = 14 * (count-1) + 20 + 8;
    }
    [self.avatarListBoxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(imgListBoxWidth);
    }];
    
    //尝试在刷新时还原更正头像初始显示位置，并尝试中止当前的动画(若有正在执行的动画，不确定此处理是否能马上停止之前还未完成的动画效果)
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    for (NSInteger i = 0; i < self.avatarViews.count; ++i) {
        if (i < count) {
            self.avatarViews[i].alpha = 1;
            [TMCardComponentTool loadNetImageInImageView:self.avatarViews[i]
                                                   imUrl:data.cover.imgs[i]
                                  finishPlaceHolderImage:[TMCardComponentTool authorAvatarPlaceHolderImage]];
        }else {
            self.avatarViews[i].alpha = 0;
        }
        [self.avatarViews[i] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(8 + i * 14);
        }];
    }
    [CATransaction commit];
    
    //右侧副描述视图
    if (self.data.cover.imgs.count > 0 && self.data.cover.subTitle.length > 0) {
        self.rightAccessoryView.hidden = NO;
        self.rightAccessoryLbl.text = self.data.cover.subTitle;
    }else {
        self.rightAccessoryView.hidden = YES;
        self.rightAccessoryLbl.text = nil;
    }
    
    //处理回答内容区域显示隐藏
    if (self.data.cover.contents.count > 0) {
        self.answerFrameBgView.hidden = NO;
        
        NSString *answerStr = self.data.cover.contents.firstObject;
        [self updateAnswerContentLabelWithContentStr:answerStr animte:NO];
        
        //回答内容条数>1才需要相关动效
        if (self.data.cover.contents.count > 1) {
            if (self.data.cover.imgs.count >= 3) {
                //3个及以上头像 且 回答内容多玩1条时 才有头像视图循环动画效果
                [self performUpdateAnswerAvatarsAfterDelay];
            }else {
                //头像无动效，仅内容变化
                [self performUpdateAnswerLabelAfterDelay];                
            }
        }
        
    }else {
        self.answerFrameBgView.hidden = YES;
        [self.answerContentLbl updateText:nil];
    }
    
}

static NSTimeInterval s_card_animate_delayTime = 3.0f;

- (void)performUpdateAnswerAvatarsAfterDelay {
    //performSelector afterDelay 默认是加入的defaultMode的runloop,当scrollview拖动时不会响应，若需要scrollview拖动时仍然执行刷新操作则用下方inModes方法
    //[self performSelector:@selector(updateAnswerAvatars) withObject:nil afterDelay:5 inModes:@[NSRunLoopCommonModes]];
    
    [self performSelector:@selector(updateAnswerAvatars) afterDelay:s_card_animate_delayTime];
}

- (void)updateAnswerAvatars {
    if (!self.tmui_viewController) {
        return;
    }
    if (self.data.cover.imgs.count < 3) {
        return;
    }
    NSInteger preTimeAvatarIdex = self.avatarIdx;
    self.avatarIdx++;
    if (self.avatarIdx >= MIN(4, self.data.cover.imgs.count)) {
        self.avatarIdx = 0;
    }
    //更新头像
    //找到当前第一个头像视图及将要动画出现的末尾头像视图
    NSInteger lastToShowIdx = MIN(4, self.data.cover.imgs.count);
    UIImageView *animateHideAvatarView = [self.avatarViews firstObject];
    UIImageView *animationShowAvatarView = self.avatarViews[lastToShowIdx];
    animationShowAvatarView.image = animateHideAvatarView.image;
    if (!animationShowAvatarView.image) {
        [TMCardComponentTool loadNetImageInImageView:animationShowAvatarView
                         imUrl:self.data.cover.imgs[preTimeAvatarIdex]
        finishPlaceHolderImage:[TMCardComponentTool authorAvatarPlaceHolderImage]];
    }
    animationShowAvatarView.backgroundColor = animateHideAvatarView.backgroundColor;
    animationShowAvatarView.alpha = 0;
    [self.avatarListBoxView insertSubview:animationShowAvatarView atIndex:0];
    
    //数组里先换位置，第一个换到最后
    [self.avatarViews removeObject:animateHideAvatarView];
    [self.avatarViews addObject:animateHideAvatarView];
    
    //更新UI位置及显示效果动画效果
    //左侧第一个头像缓慢移走，其它头像按数组的最新顺序整体同步缓慢往移顶到第一个位置
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.avatarViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:animateHideAvatarView]) {
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(8 - 14);
                }];
            }else if ([obj isEqual:animationShowAvatarView]){
                //如果是将要出来的视图则不刷新位置，后面个动画需要延迟出来
            }else {
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(8 + idx * 14);
                }];
            }
        }];
        
        [self.avatarListBoxView setNeedsUpdateConstraints];
        [self.avatarListBoxView updateConstraints];
        [self.avatarListBoxView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        //将移出的头像视图位置还原到末尾
        if (finished && animateHideAvatarView.superview) {
            [animateHideAvatarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(8 + lastToShowIdx * 14);
            }];
        }
    }];
    
    //末尾头像视图移入及alpha渐变到1
    [UIView animateWithDuration:0.17 delay:0.33 options:UIViewAnimationOptionCurveLinear animations:^{
        animationShowAvatarView.alpha = 1;
        [animationShowAvatarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(8 + (lastToShowIdx-1) * 14);
        }];
        [self.avatarListBoxView setNeedsUpdateConstraints];
        [self.avatarListBoxView updateConstraints];
        [self.avatarListBoxView layoutIfNeeded];
    } completion:nil];
    
    //前半段时间，移出的头像视图的alpha渐变到0
    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        animateHideAvatarView.alpha = 0;
    } completion:nil];
    
    //延迟刷新问答文本内容
    [self performSelector:@selector(updateAnswerLabelAfterAvatarAnimation) afterDelay:0.42];
}

- (void)updateAnswerLabelAfterAvatarAnimation {
    if (!self.tmui_viewController) {
        return;
    }
    if (self.data.cover.contents.count > 1) {
        self.contentIdx++;
        if (self.contentIdx >= MIN(4, self.data.cover.contents.count)) {
            self.contentIdx = 0;
        }
        
        NSString *answerStr = self.data.cover.contents[self.contentIdx];
        
        [self updateAnswerContentLabelWithContentStr:answerStr animte:YES];
    }
    
    [self performUpdateAnswerAvatarsAfterDelay];
}

- (void)performUpdateAnswerLabelAfterDelay {
    //performSelector afterDelay 默认是加入的defaultMode的runloop,当scrollview拖动时不会响应，若需要scrollview拖动时仍然执行刷新操作则用下方inModes方法
    //[self performSelector:@selector(updateAnswerLabel) withObject:nil afterDelay:5 inModes:@[NSRunLoopCommonModes]];
    
    [self performSelector:@selector(updateAnswerLabel) afterDelay:s_card_animate_delayTime];
}

- (void)updateAnswerLabel {
    if (!self.tmui_viewController) {
        return;
    }
    if (self.data.cover.contents.count <= 1) {
        return;
    }
    
    self.contentIdx++;
    if (self.contentIdx >= MIN(4, self.data.cover.contents.count)) {
        self.contentIdx = 0;
    }
    
    NSString *answerStr = self.data.cover.contents[self.contentIdx];
    [self updateAnswerContentLabelWithContentStr:answerStr animte:YES];
    
    [self performUpdateAnswerLabelAfterDelay];
}

- (void)updateAnswerContentLabelWithContentStr:(NSString *)answerStr animte:(BOOL)animate {
    if (answerStr) {
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
        pStyle.lineSpacing = 5;
        pStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:answerStr
                                                                       attributes:@{NSParagraphStyleAttributeName: pStyle}];
        [self.answerContentLbl updateText:attributedText animate:animate];
    }else {
        [self.answerContentLbl updateText:nil];
    }
}

@end
