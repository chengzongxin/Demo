//
//  THKCompanyDetailBannerRollingCell.h
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, THKCompanyDetailBannerRollingStyle) {
    THKCompanyDetailBannerRollingStyleLive = 0,         // 直播提醒
    THKCompanyDetailBannerRollingStyleAppointment,      // 预约
};


@interface THKCompanyDetailBannerRollingBaseCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;


@property (nonatomic, assign) THKCompanyDetailBannerRollingStyle style;


- (void)setupSubviews;
- (void)makeConstraints;

@end

NS_ASSUME_NONNULL_END
