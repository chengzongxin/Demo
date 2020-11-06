//
//  THKCompanyDetailBannerRollingLiveCell.h
//  Demo
//
//  Created by Joe.cheng on 2020/11/6.
//

#import "THKCompanyDetailBannerRollingBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKCompanyDetailBannerRollingLiveCell : THKCompanyDetailBannerRollingBaseCell

@property (nonatomic, strong) UILabel *remindLiveLabel;

@property (nonatomic, strong) RACSubject *tapRemindSubject;

@end

NS_ASSUME_NONNULL_END
