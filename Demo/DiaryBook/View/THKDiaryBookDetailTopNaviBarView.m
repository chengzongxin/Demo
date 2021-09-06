//
//  THKDiaryBookDetailTopNaviBarView.m
//  Example
//
//  Created by nigel.ning on 2020/10/19.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "THKDiaryBookDetailTopNaviBarView.h"
#import "UIView+THKDiaryAnimation.h"

@interface THKDiaryBookDetailTopNaviBarView()

//@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)TUserAvatarView *avatarImgView;
@property (nonatomic, strong)UILabel *nickNameLbl;
@property (nonatomic, strong)THKFocusButtonView *focusBtn;
@property (nonatomic, strong)UIButton *shareBtn;
@property (nonatomic, strong) UIImageView *notiImgView;
@property (nonatomic, strong) UILabel *notiLbl;
@end

@implementation THKDiaryBookDetailTopNaviBarView

- (void)thk_setupViews {
    [super thk_setupViews];
    
//    [self addSubview:self.backBtn];
    [self addSubview:self.avatarImgView];
    [self addSubview:self.nickNameLbl];
    [self addSubview:self.focusBtn];
    [self addSubview:self.shareBtn];
    
    [self _addSubLayoutConstraints];
    [self _configSubUIs];
}

- (void)_addSubLayoutConstraints {
//    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(6);
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(44);
//        make.bottom.mas_equalTo(0);
//    }];
    
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
//        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
        make.bottom.mas_equalTo(-6);
    }];
    
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarImgView.mas_trailing).mas_offset(10);
        make.centerY.mas_equalTo(self.avatarImgView.mas_centerY);
        make.trailing.mas_lessThanOrEqualTo(self.focusBtn.mas_leading).mas_offset(-4);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-12);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.avatarImgView.mas_centerY);
    }];
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarImgView.mas_centerY);
        make.trailing.mas_equalTo(self.shareBtn.mas_leading).mas_offset(-4);
        make.size.mas_equalTo(CGSizeMake(self.focusBtn.size.width, 25));
    }];
}

- (CGSize)intrinsicContentSize{
    return UILayoutFittingExpandedSize;
}

- (void)_configSubUIs {
    
    self.avatarImgView.clipsToBounds = YES;
    self.avatarImgView.layer.cornerRadius = 32/2;
    
    self.nickNameLbl.font = UIFontMedium(16);
    self.nickNameLbl.textColor = [UIColor whiteColor];
        
//    [self.backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:0];
//    [self updateCollectBtnState:NO];
    [self.shareBtn setImage:[UIImage imageNamed:@"nav_share_black"] forState:0];
}

//- (void)updateCollectBtnState:(BOOL)isCollected {
//    [self.collectBtn setImage:[UIImage imageNamed:isCollected ? @"nav_collected" : @"nav_uncollected_white"] forState:0];
//}

- (void)updateFocusBtnState:(NSInteger)uid followStatus:(BOOL)followStaus{
//    self.focusBtn.hidden = !self.viewModel.showFollowBtn;
    self.focusBtn.focusId = uid;
    [self.focusBtn setFocusStatus:followStaus];
}

- (void)recivedUrgeUpdate{
    if (self.avatarImgView.avatarImgView.layer.animationKeys.count == 0) {
        [self.avatarImgView.avatarImgView.layer addAnimation:[self imageViewScale] forKey:@"scaleAnimation"];
    }
    
    if (!self.notiImgView.superview) {
        [self addSubview:self.notiImgView];
        [self.notiImgView addSubview:self.notiLbl];
        
        [self.notiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.avatarImgView.mas_trailing).mas_offset(10);
            make.centerY.mas_equalTo(self.avatarImgView.mas_centerY);
            make.trailing.mas_lessThanOrEqualTo(self.focusBtn.mas_leading).mas_offset(-4);
            make.height.mas_equalTo(36);
        }];
        
        [self.notiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.bottom.mas_equalTo(0);
        }];
        
        [self.notiImgView.layer addAnimation:[self opacityAnimation] forKey:nil];
    }
}



#pragma mark - sub ui lazy loads

//TMUI_PropertyLazyLoad(UIButton, backBtn);
TMUI_PropertyLazyLoad(TUserAvatarView, avatarImgView);
TMUI_PropertyLazyLoad(UILabel, nickNameLbl);
//TMUI_PropertyLazyLoad(UIButton, focusBtn);
TMUI_PropertyLazyLoad(UIButton, shareBtn);

- (THKFocusButtonView *)focusBtn{
    if (!_focusBtn) {
        _focusBtn = [[THKFocusButtonView alloc] initWithStyle:FocusButtonViewStyle_Green_Large focusType:FocusType_User];
        _focusBtn.hideForFollowed = NO;
    }
    return _focusBtn;
}

- (UIImageView *)notiImgView{
    if (!_notiImgView) {
        _notiImgView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"diary_noti_bg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:1];
//        image = [image tmui_resizedInRect:CGRectMake(0, 0, 200, 36)];
//        CGFloat sscale = 1.0/2.0;
//        CGFloat leftRight = (image.size.width - image.size.width * sscale)/2.0;
//        CGFloat topBottom = (image.size.height - image.size.height * sscale)/2.0;
//        UIEdgeInsets inset = UIEdgeInsetsMake(topBottom, leftRight, topBottom, leftRight);
//        image = [image resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
        _notiImgView.image = image;
        _notiImgView.contentMode = UIViewContentModeScaleAspectFill;
//        _notiImgView.hidden = YES;
    }
    return _notiImgView;
}

- (UILabel *)notiLbl{
    if (!_notiLbl) {
        _notiLbl = [[UILabel alloc] init];
        _notiLbl.textColor = UIColor.whiteColor;
        _notiLbl.textAlignment = NSTextAlignmentLeft;
        _notiLbl.font = UIFont(16);
        _notiLbl.text = @"我已经收到啦，更新后会通知你❤️";
    }
    return _notiLbl;
}

@end
