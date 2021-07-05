//
//  TMCardComponentLiveStyleCell.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/5/16.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentLiveStyleCell.h"
#import "TMCardComponentCellSizeTool.h"
#import "TMCardComponentTool.h"
//#import <Lottie/Lottie.h>
//#import "TImageTitleButton.h"
#import "THKTextTagLabel.h"
#import "TMCardLiveStatusView.h"
#import "TUserAvatarView.h"
#import "TTagShapeColorView.h"

@interface TMCardComponentLiveStyleCell()
@property (nonatomic, strong) UIView *titleBoxView;///< 标题信息块视图，包含距离上部10pt间距及最多两行文本的高度和
@property (nonatomic, strong) THKTextTagLabel *titleLbl;///< 标题文本视图

@property (nonatomic, strong) UIView *subTitleBoxView;///< 描述信息块视图，包含距离上部8pt间距及一行文本的高度和，若有副标题显示则固定高度为8 + 16，若无则为0
@property (nonatomic, strong) UILabel *subTitleLbl;///< 副标题文本视图

@property (nonatomic, strong) TMCardLiveStatusView *liveStatusView;///< 直播状态视图

///v8.8.0 直播状态视图中右上角的红包图标动画
@property (nonatomic, strong)UIView *redPacketLottieView;

//v8.13 add 新设计稿,封面图底部60pt高度区域的渐变蒙层视图，显示在在头像、昵称 、位置视图下面
@property (nonatomic, strong)TTagShapeColorView *coverBottomGradientColorView;

//v8.13 调整地址视图显示到封面图右下角 下安全边距12，右安全边距15
@property (nonatomic, strong)UIView   *addressContainerView;
@property (nonatomic, strong)UILabel  *addressLabel;

@property (nonatomic, strong)TUserAvatarView *avatarView;
@property (nonatomic, strong)UILabel *nickNameLbl;

@end

@implementation TMCardComponentLiveStyleCell

TMCardComponentPropertyLazyLoad(UIView, titleBoxView);
TMCardComponentPropertyLazyLoad(THKTextTagLabel, titleLbl);
TMCardComponentPropertyLazyLoad(UIView, subTitleBoxView);
TMCardComponentPropertyLazyLoad(UILabel, subTitleLbl);

TMCardComponentPropertyLazyLoad(TTagShapeColorView, coverBottomGradientColorView);
TMCardComponentPropertyLazyLoad(TUserAvatarView, avatarView);
TMCardComponentPropertyLazyLoad(UILabel, nickNameLbl);

- (void)loadInitLiveStatusView {
    if(!self.liveStatusView) {
        self.liveStatusView = [[TMCardLiveStatusView alloc] init];
        [self.coverImgView addSubview:self.liveStatusView];
        [self.liveStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.mas_equalTo(TMCardUIConfigConst_floatingIconSafeMargin);
            make.height.mas_equalTo(20);
        }];
    }
        
    [self.coverImgView addSubview:self.redPacketLottieView];
    [self.redPacketLottieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImgView.mas_top).mas_offset(4);
        make.trailing.mas_equalTo(self.coverImgView.mas_trailing).mas_offset(-4);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
}

- (void)loadUserInfoView {
    self.avatarView.identityIconSize = CGSizeMake(6, 6);
    self.nickNameLbl.font = UIFont(11);
    self.nickNameLbl.textColor = [UIColor whiteColor];
    
    [self.coverImgView addSubview:self.coverBottomGradientColorView];
    [self.coverImgView addSubview:self.avatarView];
    [self.coverImgView addSubview:self.nickNameLbl];
    [self.coverImgView addSubview:self.addressContainerView];
    
    [self.coverBottomGradientColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(self.coverImgView);
        make.height.mas_equalTo(60);
    }];
    
    [self.addressContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarView.mas_centerY);
        make.trailing.mas_equalTo(self.coverImgView.mas_trailing).mas_offset(-15);
        make.height.mas_equalTo(16);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.bottom.mas_equalTo(self.coverImgView.mas_bottom).mas_offset(-12);
        make.width.height.mas_equalTo(14);
    }];
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarView.mas_trailing).mas_offset(4);
        make.centerY.mas_equalTo(self.avatarView.mas_centerY);
        make.trailing.mas_lessThanOrEqualTo(self.addressContainerView.mas_leading).mas_offset(-4);
    }];
    
    //设置相关约束优先级，让右测地址labl优先显示完整, nickNameLbl显示可被自动压缩
    [self.addressLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.addressLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.coverBottomGradientColorView.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor,
                                                 (id)[[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor];
}

- (void)loadSubUIElement {
    [super loadSubUIElement];
    
    [self loadInitLiveStatusView];
    [self loadUserInfoView];
    
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
        
    } else {
        self.titleLbl.text = nil;
    }
    
    self.subTitleLbl.text = data.cover.subTitle.length > 0 ? data.cover.subTitle : nil;
    //
    //加载头像及设置默认头像占位图,加载认证icon
    BOOL isNormalAuthorAvatar = YES;
    BOOL showIdentifyIcon = YES;
        
    BOOL hasAvaliableTitle = self.data.bottom.title.length > 0 ? YES : NO;
    BOOL hasAvaliableImg = self.data.bottom.imgUrl.length > 0 ? YES : NO;
    BOOL canShowAvatarPlaceHolderImg = (hasAvaliableTitle || hasAvaliableImg);
    //当昵称和头像数据都为空时，不显示头像的占位图
    [TMCardComponentTool loadNetImageInImageView:self.avatarView.avatarImgView
                     imUrl:self.data.bottom.imgUrl
                          finishPlaceHolderImage:(isNormalAuthorAvatar && canShowAvatarPlaceHolderImg) ? [TMCardComponentTool authorAvatarPlaceHolderImage] : nil];
    self.avatarView.identityIconView.hidden = !showIdentifyIcon;
    [TMCardComponentTool loadNetImageInImageView:self.avatarView.identityIconView
                                           imUrl:self.data.bottom.subIcon
                          finishPlaceHolderImage:nil];
        
    //更新昵称
    self.nickNameLbl.text = self.data.bottom.title;
    //更新直播状态视图
    [self updateLiveStatusViewAsLiving:data.content.liveIn];
    if (data.interaction.type == TMCardComponentDataInteractionInfoTypeWatch) {
        //观看人数的描述串
        self.liveStatusView.watchNumFormatStr = data.interaction.text;
    }else {
        self.liveStatusView.watchNumFormatStr = nil;
    }
    //更新地理位置
    self.addressContainerView.hidden = YES;
    if (data.content.cityName && data.content.cityName.length > 0) {
        self.addressContainerView.hidden = NO;
        self.addressLabel.text = data.content.cityName;
    }else {
        self.addressLabel.text = nil;
    }
    
    if (data.content.redTag > 0) {
        self.redPacketLottieView.hidden = NO;
//        [self.redPacketLottieView play];
    } else {
        self.redPacketLottieView.hidden = YES;
//        [self.redPacketLottieView stop];
    }
}

- (void)updateLiveStatusViewAsLiving:(NSInteger)liveIn {
    if (liveIn == 1) {// 直播中
        self.liveStatusView.living = YES;
    }else {// 回放 (值为3表示回放，但由于8.13 UI调整后，仅支持直播或回放，没有其它隐藏逻辑，所以这里将 != 1 的情况全部归为回放)
        self.liveStatusView.living = NO;
    }
}

- (UIView *)redPacketLottieView {
    if (!_redPacketLottieView) {
        NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
        NSString *jsonFilePath = [[mainBundle pathForResource:@"liveCardRedPacketLottie" ofType:@"bundle"] stringByAppendingPathComponent:@"animate.json"];
        if (jsonFilePath.length > 0) {
//            _redPacketLottieView = [LOTAnimationView animationWithFilePath:jsonFilePath];
//            _redPacketLottieView.loopAnimation = YES;
//            [_redPacketLottieView stop];
//            _redPacketLottieView.hidden = YES;
        }
    }
    return _redPacketLottieView;
}

- (UIView *)addressContainerView {
    if (!_addressContainerView) {
        _addressContainerView = [[UIView alloc] init];
        _addressContainerView.backgroundColor = [UIColor clearColor];
        _addressContainerView.hidden = YES;
        
        UIImage *image = [UIImage imageNamed:@"icon_liveCard_addres"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [_addressContainerView addSubview:imageView];
        [_addressContainerView addSubview:self.addressLabel];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(_addressContainerView.mas_trailing);
            make.centerY.mas_equalTo(_addressContainerView.mas_centerY);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(self.addressLabel.mas_leading).mas_offset(-4);
            make.centerY.mas_equalTo(_addressContainerView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }
    return _addressContainerView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.font = UIFont(11);
        _addressLabel.textAlignment = NSTextAlignmentRight;
    }
    return _addressLabel;
}

@end
