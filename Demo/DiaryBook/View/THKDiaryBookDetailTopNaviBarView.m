//
//  THKDiaryBookDetailTopNaviBarView.m
//  Example
//
//  Created by nigel.ning on 2020/10/19.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "THKDiaryBookDetailTopNaviBarView.h"

@interface THKDiaryBookDetailTopNaviBarView()

//@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)TUserAvatarView *avatarImgView;
@property (nonatomic, strong)UILabel *nickNameLbl;
@property (nonatomic, strong)THKFocusButtonView *focusBtn;
@property (nonatomic, strong)UIButton *shareBtn;
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

@end
