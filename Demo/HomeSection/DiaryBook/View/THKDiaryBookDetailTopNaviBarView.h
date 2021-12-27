//
//  THKDiaryBookDetailTopNaviBarView.h
//  Example
//
//  Created by nigel.ning on 2020/10/19.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "THKView.h"
#import "TUserAvatarView.h"
#import "THKFocusButtonView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 日记详情页顶部自定义导航条
 @note 显示返回按钮、用户头像、用户昵称、收藏及分享等视图
 */
@interface THKDiaryBookDetailTopNaviBarView : THKView

@property (nonatomic, strong, readonly)UIButton *backBtn;
@property (nonatomic, strong, readonly)TUserAvatarView *avatarImgView;
@property (nonatomic, strong, readonly)UILabel *nickNameLbl;
@property (nonatomic, strong, readonly)THKFocusButtonView *focusBtn;
@property (nonatomic, strong, readonly)UIButton *shareBtn;

//- (void)updateCollectBtnState:(BOOL)isCollected;
- (void)updateFocusBtnState:(NSInteger)uid followStatus:(BOOL)followStaus;

- (void)recivedUrgeUpdate;

@end


@interface THKDiaryNotiPopView : UIView

@property (nonatomic, strong) NSString *text;

@end

NS_ASSUME_NONNULL_END
