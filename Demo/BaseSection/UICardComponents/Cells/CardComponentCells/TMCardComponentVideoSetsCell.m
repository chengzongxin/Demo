//
//  TMCardComponentVideoSetsCell.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/8/18.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentVideoSetsCell.h"
#import "TMCardComponentCellSizeTool.h"
#import "UIImageView+YYWebImage.h"


@interface TMCardComponentVideoSetsCell() {
    
}

///用动动画的两个imgView,原coverImgView隐藏即可
@property (nonatomic, strong) UIImageView *otherCoverImgView1;///< 与默认coverImgView配合作过渡动画的另一个ImgView
@property (nonatomic, strong) UIImageView *otherCoverImgView2;///< 与默认coverImgView配合作过渡动画的另一个ImgView
@property (nonatomic, strong) UIView *coverAreaView;///< 封面尺寸大小的顶层视图，用于显示subIcons
@property (nonatomic, strong) UILabel *titleLbl;///< 标题文本视图
@property (nonatomic, strong) UILabel *subTitleLbl;///< 副标题文本视图
@property (nonatomic, strong, readonly)NSDictionary<NSNumber *, UIImageView *> *subIconPositionMapIconViews;///< 显示在图片的小类型或其它修饰icon视图
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation TMCardComponentVideoSetsCell
@synthesize subIconPositionMapIconViews = _subIconPositionMapIconViews;

TMCardComponentPropertyLazyLoad(UIView, coverAreaView);
TMCardComponentPropertyLazyLoad(UIImageView, otherCoverImgView1);
TMCardComponentPropertyLazyLoad(UIImageView, otherCoverImgView2);
TMCardComponentPropertyLazyLoad(UILabel, titleLbl);
TMCardComponentPropertyLazyLoad(UILabel, subTitleLbl);


- (void)loadSubUIElement {
    [super loadSubUIElement];
        
    self.coverImgView.hidden = YES;
    self.coverImgView.alpha = 0;
    
    [self.contentView addSubview:self.coverAreaView];
    self.coverAreaView.clipsToBounds = YES;
    [self.coverAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    [self.contentView insertSubview:self.otherCoverImgView1 belowSubview:self.coverAreaView];
    [self.contentView insertSubview:self.otherCoverImgView2 belowSubview:self.coverAreaView];
    NSArray<UIImageView *> *imgVs = @[self.otherCoverImgView1, self.otherCoverImgView2];
    [imgVs enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.clipsToBounds = YES;
        obj.layer.masksToBounds = YES;
        obj.contentMode = UIViewContentModeScaleAspectFill;
        obj.layer.cornerRadius = self.coverImgView.layer.cornerRadius;
        obj.backgroundColor = THKColor_Sub_EmptyAreaBackgroundColor;
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
    }];
        
    self.otherCoverImgView1.layer.opacity = 1;
    self.otherCoverImgView2.layer.opacity = 0;
    
    for (NSInteger i = 0; i < 2; ++i) {
        UIView *shadowView = [[UIView alloc] init];
        shadowView.clipsToBounds = YES;
        shadowView.layer.cornerRadius = self.coverImgView.layer.cornerRadius;
        shadowView.backgroundColor = UIColorHexString(@"F5F5F5");
        shadowView.layer.borderColor = [UIColorHexString(@"D8D8D8") colorWithAlphaComponent:0.8].CGColor;
        shadowView.layer.borderWidth = 0.5;
        
        [self.contentView insertSubview:shadowView atIndex:0];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(8 * i + 8);
            make.trailing.mas_equalTo(- 8 - 8 * i);
            make.height.mas_equalTo(shadowView.mas_width);
            make.bottom.mas_equalTo(self.coverAreaView.mas_bottom).mas_offset(4 + 4 * i);
        }];
    }
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.subTitleLbl];
            
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverAreaView.mas_bottom).mas_offset(4 * 2 + TMCardUIConfigConst_firstLabelTopMargin);
        make.leading.mas_equalTo(TMCardUIConfigConst_contentLeftRightMargin);
        make.trailing.mas_equalTo(-TMCardUIConfigConst_contentLeftRightMargin);
    }];
    [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLbl.mas_bottom).mas_offset(TMCardUIConfigConst_secondLabelTopMargin);
        make.leading.mas_equalTo(TMCardUIConfigConst_contentLeftRightMargin);
        make.trailing.mas_equalTo(-TMCardUIConfigConst_contentLeftRightMargin);
        make.height.mas_equalTo(TMCardUIConfigConst_singleLineLabelHeight);
    }];
    //加载初始化相关装修icons，默认为隐藏状态
    [self loadSubIcons];
    
    //
    self.titleLbl.numberOfLines = 2;
    self.titleLbl.font = [TMCardComponentCellSizeTool NormalStyleCellTitleFont];
    self.titleLbl.textColor = UIColorHexString(@"1A1C1A");//333333
    self.subTitleLbl.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    self.subTitleLbl.textColor = UIColorHexString(@"999999");;
    
#if DEBUG
    MASAttachKeys(self.titleLbl, self.subTitleLbl, self.coverAreaView, self.otherCoverImgView1, self.otherCoverImgView2);
#endif
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
    
    [self.otherCoverImgView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [self.otherCoverImgView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [self.coverAreaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    self.otherCoverImgView1.layer.opacity = 1;
    self.otherCoverImgView1.layer.transform = CATransform3DIdentity;
    self.otherCoverImgView2.layer.opacity = 0;
    self.otherCoverImgView2.layer.transform = CATransform3DIdentity;
}

- (UIImageView *)currentShowImgView {
    if (self.otherCoverImgView1.layer.opacity == 1) {
        return self.otherCoverImgView1;
    }else {
        return self.otherCoverImgView2;
    }
}

- (UIImageView *)willShowImgView {
    if (self.otherCoverImgView1.layer.opacity == 1) {
        return self.otherCoverImgView2;
    }else {
        return self.otherCoverImgView1;
    }
}

- (void)playAnimation {
    UIImageView *dismissImgView = [self currentShowImgView];
    UIImageView *willShowImgView = [self willShowImgView];
    
    NSInteger willIndex = self.currentIndex + 1;
    if (willIndex >= self.data.cover.imgs.count) {
        willIndex = 0;
    }
    NSInteger preLoadNextIndex = willIndex + 1;
    if (preLoadNextIndex >= self.data.cover.imgs.count) {
        preLoadNextIndex = 0;
    }
    self.currentIndex = willIndex;
    
    NSString *willShowImgUrl = [self.data.cover.imgs safeObjectAtIndex:willIndex];
    NSString *preLoadNextImgUrl = [self.data.cover.imgs safeObjectAtIndex:preLoadNextIndex];
    
    [TMCardComponentTool loadNetImageInImageView:willShowImgView
                                           imUrl:willShowImgUrl
    finishPlaceHolderImage:nil];
    
    float scale = (self.data.layout_cellSize.width - 8*2) / self.data.layout_cellSize.width;
    float translateY = (self.data.layout_coverShowHeight - self.data.layout_coverShowHeight * scale)/2 + 4;
    CATransform3D willShowInitTransform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1);
    willShowInitTransform = CATransform3DConcat(willShowInitTransform, CATransform3DTranslate(CATransform3DIdentity, 0, translateY, 0));
    willShowImgView.layer.transform = willShowInitTransform;
    willShowImgView.layer.opacity = 0.2;
    
    CATransform3D willDismissTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -25, 0);
    @weakify(dismissImgView);
    
    [UIView animateWithDuration:0.7 animations:^{
        dismissImgView.layer.opacity = 0;
    }];
    [UIView animateWithDuration:0.65 animations:^{
        dismissImgView.layer.transform = willDismissTransform;
        
        willShowImgView.layer.transform = CATransform3DIdentity;
        willShowImgView.layer.opacity = 1;
        
    } completion:^(BOOL finished) {
        @strongify(dismissImgView);
        if (finished && dismissImgView) {
            //消失后的视图对下一次出现的图片进行一次预加载，提高图片加载的速度
            [TMCardComponentTool loadNetImageInImageView:dismissImgView
                                                   imUrl:preLoadNextImgUrl
            finishPlaceHolderImage:nil];
        }
    }];
    
}

- (void)performOrStopDelayAnimationTimerIfNeed {
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
    if (!self.superview ||
        !self.data) {
        return;
    }
    
    @weakify(self)
    dispatch_queue_t queue = dispatch_get_main_queue();
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    float delaySecs = 2.5 + 0.65;
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW + (delaySecs - 0.6) * NSEC_PER_SEC, delaySecs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
            //执行的函数或代码块
            @strongify(self);
            [self playAnimation];
        });
    dispatch_resume(_timer);
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self performOrStopDelayAnimationTimerIfNeed];
}

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {
    if (self.data && [self.data isEqual:data]) {
        //防止重复reloadData重复刷新cell
        return;
    }
    
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
    //清除旧动画并还有相关显示状态
    [self.otherCoverImgView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(data.layout_coverShowHeight);
    }];
    [self.otherCoverImgView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(data.layout_coverShowHeight);
    }];
    [self.coverAreaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(data.layout_coverShowHeight);
    }];
    self.otherCoverImgView1.layer.opacity = 1;
    self.otherCoverImgView1.layer.transform = CATransform3DIdentity;
    self.otherCoverImgView2.layer.opacity = 0;
    self.otherCoverImgView2.layer.transform = CATransform3DIdentity;
    //
    [super updateUIElement:data];
    //加载图片

    
    if(self.data.cover.imgs.count >=2) {
        [TMCardComponentTool loadNetImageInImageView:self.otherCoverImgView1
                                               imUrl:self.data.cover.imgs[0]
                              finishPlaceHolderImage:nil];
        [TMCardComponentTool loadNetImageInImageView:self.otherCoverImgView2
                                               imUrl:self.data.cover.imgs[1]
                              finishPlaceHolderImage:nil];
    }
    
    self.currentIndex = 0;
    if (data.cover.title.length > 0) {
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
        pStyle.lineSpacing = [TMCardComponentCellSizeTool NormalStyleCellTitleLineGap];
        pStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLbl.attributedText = [[NSAttributedString alloc] initWithString:data.cover.title
                                                                       attributes:@{NSParagraphStyleAttributeName: pStyle}];
        // 使搜索分词高亮
        //TSearchContentMakeKeywordsShowHighlightInLabelIfNeed(self.titleLbl, data);
    }else {
        self.titleLbl.text = nil;
    }
    
    self.subTitleLbl.text = data.cover.subTitle.length > 0 ? data.cover.subTitle : nil;
    
    //更新装修icons视图的内容显示或隐藏处理
    [self updateSubIcons];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self performOrStopDelayAnimationTimerIfNeed];
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
    [self.coverAreaView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.top.mas_equalTo(safeGap);
        make.trailing.mas_equalTo(-safeGap);
    }];
    //
    iconView = self.subIconPositionMapIconViews[@(TMCardComponentDataCoverSubIconPositionTopLeft)];
    [self.coverAreaView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.top.mas_equalTo(safeGap);
        make.leading.mas_equalTo(safeGap);
    }];
    //
    iconView = self.subIconPositionMapIconViews[@(TMCardComponentDataCoverSubIconPositionBottomRight)];
    [self.coverAreaView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.bottom.mas_equalTo(-safeGap);
        make.trailing.mas_equalTo(-safeGap);
    }];
    //
    iconView = self.subIconPositionMapIconViews[@(TMCardComponentDataCoverSubIconPositionBottomLeft)];
    [self.coverAreaView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.bottom.mas_equalTo(-safeGap);
        make.leading.mas_equalTo(safeGap);
    }];
    //
    iconView = self.subIconPositionMapIconViews[@(TMCardComponentDataCoverSubIconPositionCenter)];
    [self.coverAreaView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.centerX.mas_equalTo(self.coverAreaView.mas_centerX);
        make.centerY.mas_equalTo(self.coverAreaView.mas_centerY);
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
