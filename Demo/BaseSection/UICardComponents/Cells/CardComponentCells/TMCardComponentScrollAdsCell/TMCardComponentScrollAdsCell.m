//
//  TMCardComponentScrollAdsCell.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/10/30.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentScrollAdsCell.h"
#import "TMCardComponentUIConfigDefine.h"
//#import "THKHomeFlowListResponse.h"
#import "TMCardComponentScrollAdsBannerView.h"
#import "TMCardComponentScrollAdsIndicatorView.h"
//#import "TADController.h"
//#import "GEProcessor+GodeyePrivate.h"

@interface TMCardComponentScrollAdsBannerItemCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *adLabel;///< 展示在封面上右下角位置的广告文字标记视图, 默认隐藏
@end

@implementation TMCardComponentScrollAdsBannerItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //
        [self.contentView addSubview:self.adLabel];
        self.adLabel.hidden = YES;
        [self.adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(-5);
            make.height.mas_equalTo(14.0);
            make.width.mas_equalTo(28.0);
        }];
    }
    return self;
}

- (UILabel *)adLabel {
    if (!_adLabel) {
        _adLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28, 14)];
        _adLabel.backgroundColor = [[UIColor colorWithHexString:@"010101"] colorWithAlphaComponent:0.45];
        _adLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightRegular];
        _adLabel.textAlignment = NSTextAlignmentCenter;
        _adLabel.textColor = [UIColor whiteColor];
        _adLabel.cornerRadius = 2.0;
        _adLabel.text = @"广告";
    }
    
    return _adLabel;
}

@end

@interface TMCardComponentScrollAdsCell()
@property (nonatomic, strong)THKHomeFlowListModel *data;

@property (nonatomic, strong)TMCardComponentScrollAdsBannerView *bannerView;
@property (nonatomic, strong)TMCardComponentScrollAdsIndicatorView *indicatorView;

@end

@implementation TMCardComponentScrollAdsCell
//
//- (void)updateUIElement:(THKHomeFlowListModel /*NSObject<TMCardComponentCellDataProtocol>*/ *)data {
//    [self _updateContentData];
//    
//    self.data = data;
//    
//    @weakify(self);
//    [[data.autoScrollShouldPauseSignal takeUntil:[self rac_signalForSelector:@selector(_updateContentData)]] subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        [self.bannerView pauseTimeIfNeed];
//    }];
//    [[data.autoScrollShouldResumeSignal takeUntil:[self rac_signalForSelector:@selector(_updateContentData)]] subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        [self.bannerView resumeTimerIfNeed];
//    }];
//    
//    [self.indicatorView updateIndicatorProgress:0 animate:NO];
//    if (data.scrollAds.count <= 1) {
//        self.indicatorView.hidden = YES;//一个子内容时隐藏指示器视图
//        [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(15);
//        }];
//    }else {
//        self.indicatorView.hidden = NO;
//        [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(MIN(45, 15 * data.scrollAds.count));
//        }];
//        [self.indicatorView updateIndicatorProgress:0 animate:NO];
//    }
//    
//    [self.bannerView reloadDataOfTotalItemCount:data.scrollAds.count];
//    
//    if (self.superview && data.scrollAds.count > 0) {
//        [self exposeIfNeedFromAd:data.scrollAds[0] adIdx:0];
//    }
//}
//
//- (void)didMoveToSuperview {
//    [super didMoveToSuperview];
//    if (self.data.scrollAds.count > 0) {
//        NSInteger idx = [self.bannerView currentIndex];
//        if (idx >= 0 && idx < self.data.scrollAds.count) {
//            [self exposeIfNeedFromAd:self.data.scrollAds[idx] adIdx:idx];
//        }
//    }
//}
//
//- (void)_updateContentData {}
//
//- (void)prepareForReuse {
//    [super prepareForReuse];
//    //被重用时先销毁旧timer及data数据
//    [self.bannerView pauseTimeIfNeed];
//    self.data = nil;
//}
//
//#pragma mark - init ui
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {        
//        [self thk_setupViews];
//    }
//    return self;
//}
//
//- (void)thk_setupViews {
//    self.contentView.clipsToBounds = YES;
//    self.clipsToBounds = YES;
//    self.layer.cornerRadius = TMCardUIConfigConst_cardCornerRadius;
//        
//    [self.contentView addSubview:self.bannerView];
//    [self.contentView addSubview:self.indicatorView];
//        
//    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
//    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.contentView.mas_centerX);
//        make.height.mas_equalTo(3);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
//        make.width.mas_equalTo(15);
//    }];
//    
//    @weakify(self);
//    [self.bannerView registCellClass:[TMCardComponentScrollAdsBannerItemCell class] fillCellForRowAtIndex:^(TMCardComponentScrollAdsBannerItemCell * _Nonnull cell, NSUInteger index) {
//        @strongify(self);
//        TAD *ad = self.data.scrollAds[index];
//        [cell.imageView loadImageWithUrlStr:ad.material.firstObject.resource_url];
//        cell.adLabel.hidden = (ad.put_type == 1) ? NO : YES;        
//    } didClickCellForRowAtIndex:^(TMCardComponentScrollAdsBannerItemCell * _Nonnull cell, NSUInteger index) {
//        @strongify(self);
//        TAD *ad = self.data.scrollAds[index];
//        //点击上报
//        [self reportClickFromAd:ad adIdx:index];
//        //
////        [TADController handleAd:ad rootViewController:self.tmui_viewController];
//    }];
//    [self.bannerView setDidScrollToPageIndexBlock:^(NSInteger curIdx, NSInteger totalCount) {
//        @strongify(self);
//        if (!self.data) {return;}
//        
//        CGFloat percent = curIdx * 1.0f / ((totalCount-1) * 1.0f);
//        [self.indicatorView updateIndicatorProgress:percent animate:YES];
//        //暴光上报
//        [self exposeIfNeedFromAd:self.data.scrollAds[curIdx] adIdx:curIdx];
//    }];
//    //指示视图默认隐藏
//    self.indicatorView.userInteractionEnabled = NO;
//    self.indicatorView.hidden = YES;        
//}
//
//- (void)exposeIfNeedFromAd:(TAD *)ad adIdx:(NSInteger)idx {
//    if (!ad.geExposedFlag && self.superview) {
//        ad.geExposedFlag = YES;
//        NSDictionary *dic = [self reportDicFromAd:ad adIdx:idx];
//        if (dic.count > 0) {
//            [[GEProcessor shareProcessor] reportEvent:@"appWidgetShow" properties:dic];
//        }
//    }
//}
//
//- (void)reportClickFromAd:(TAD *)ad adIdx:(NSInteger)idx {
//    NSDictionary *dic = [self reportDicFromAd:ad adIdx:idx];
//    if (dic.count > 0) {
//        [[GEProcessor shareProcessor] reportEvent:@"appWidgetClick" properties:dic];
//    }
//}
//
//- (NSDictionary *)reportDicFromAd:(TAD *)ad adIdx:(NSInteger)idx {
//    NSDictionary *properties = @{
//        @"ad_type":@"ad",
//        @"ad_id":@(ad.ad_id).description,
//        @"ad_index":@(ad.adpos_id).description,
//        @"ad_title":kUnNilStr(ad.title),
//        @"ad_src":kUnNilStr(ad.material[0].resource_url),
//        @"widget_href" : kUnNilStr(ad.ios_url),
//        @"page_uid" : self.viewController.gePageUid ?: @"THKHomeRecommendViewController#1",
//        @"page_refer_uid" : self.viewController.gePageReferUid?:@"",
//        @"widget_index": @(ad.widget_index),
//        @"widget_uid" : ad.widget_uid ? ad.widget_uid : @"homepage_top_banner",
//        @"widget_title" : ad.widget_title ? ad.widget_title : @"",
//        @"page_title" : ad.page_title ? ad.page_title : @"",
//    };
//    return properties;
//}
//
//TMCardComponentPropertyLazyLoad(TMCardComponentScrollAdsBannerView, bannerView);
//TMCardComponentPropertyLazyLoad(TMCardComponentScrollAdsIndicatorView, indicatorView);
//

@end
