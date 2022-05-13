//
//  THKNavigationTitleAvatarView.h
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import "THKNavigationTitleView.h"
#import "THKNavigationBarAvatarViewModel.h"
#import "THKFocusButtonView.h"
#import "THKAvatarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKNavigationAvatarTitleView : THKNavigationTitleView

@property (nonatomic, strong, readonly) THKNavigationBarAvatarViewModel *viewModel;

@property (nonatomic, strong, readonly) THKAvatarView *avatarView;

@property (nonatomic, strong, readonly) UILabel *nickNameLbl;

@property (nonatomic, strong, readonly) THKFocusButtonView *focusBtn;

@end

NS_ASSUME_NONNULL_END
