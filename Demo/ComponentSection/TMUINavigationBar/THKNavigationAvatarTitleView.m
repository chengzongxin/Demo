//
//  THKNavigationTitleAvatarView.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import "THKNavigationAvatarTitleView.h"
#import "THKFocusButtonView.h"
#import "THKAvatarView.h"

@interface THKNavigationAvatarTitleView ()

@property (nonatomic, strong) THKNavigationAvatarTitleViewModel *viewModel;

@property (nonatomic, strong) THKAvatarView *avatarView;
@property (nonatomic, strong) UILabel *nickNameLbl;
@property (nonatomic, strong) THKFocusButtonView *focusBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation THKNavigationAvatarTitleView
@dynamic viewModel;

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.avatarView];
    [self addSubview:self.nickNameLbl];
    [self addSubview:self.focusBtn];
    [self addSubview:self.shareBtn];
    
    [self _addSubLayoutConstraints];
    [self _configSubUIs];
}



- (void)_addSubLayoutConstraints {
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
        make.bottom.mas_equalTo(-6);
    }];
    
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarView.mas_trailing).mas_offset(10);
        make.centerY.mas_equalTo(self.avatarView.mas_centerY);
        make.trailing.mas_lessThanOrEqualTo(self.focusBtn.mas_leading).mas_offset(-4);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.avatarView.mas_centerY);
    }];
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarView.mas_centerY);
        make.trailing.mas_equalTo(self.shareBtn.mas_leading).mas_offset(-4);
        make.size.mas_equalTo(self.focusBtn.size);
    }];
}

- (void)_configSubUIs {
    
    self.avatarView.clipsToBounds = YES;
    self.avatarView.layer.cornerRadius = 32/2;
    
    self.nickNameLbl.font = UIFontMedium(16);
    self.nickNameLbl.textColor = [UIColor blackColor];
    
    [self.shareBtn setImage:[UIImage imageNamed:@"nav_share_black"] forState:0];
}



#pragma mark - Public
- (void)bindViewModel{
    [super bindViewModel];
    
    //更新头像视图
    THKAvatarViewModel *avm = [[THKAvatarViewModel alloc] initWithAvatarUrl:self.viewModel.avatarUrl placeHolderImage:kDefaultHeadPortrait_60 identityType:self.viewModel.identificationType identitySubType:self.viewModel.subCategory];
    [self.avatarView bindViewModel:avm];
    self.nickNameLbl.text = self.viewModel.nickname;
    self.focusBtn.focusId = self.viewModel.uid;
    [self.focusBtn setFocusStatus:self.viewModel.followStaus];
}




- (void)updateFocusBtnState:(NSInteger)uid followStatus:(BOOL)followStaus{
    self.focusBtn.focusId = uid;
    [self.focusBtn setFocusStatus:followStaus];
}



#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters
TMUI_PropertyLazyLoad(THKAvatarView, avatarView);
TMUI_PropertyLazyLoad(UILabel, nickNameLbl);
TMUI_PropertyLazyLoad(UIButton, shareBtn);

- (THKFocusButtonView *)focusBtn{
    if (!_focusBtn) {
        _focusBtn = [[THKFocusButtonView alloc] initWithStyle:FocusButtonViewStyle_Gray_Normal focusType:FocusType_User];
        _focusBtn.hideForFollowed = NO;
    }
    return _focusBtn;
}

#pragma mark - Supperclass
// 重写这个方法，不压缩titleView
- (CGSize)intrinsicContentSize{
    return UILayoutFittingExpandedSize;
}

#pragma mark - NSObject





@end
