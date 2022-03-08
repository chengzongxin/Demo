//
//  THKNavigationTitleAvatarView.h
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import "THKNavigationTitleView.h"
#import "THKNavigationAvatarTitleViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKNavigationAvatarTitleView : THKNavigationTitleView
@property (nonatomic, strong, readonly) THKNavigationAvatarTitleViewModel *viewModel;

- (void)updateFocusBtnState:(NSInteger)uid followStatus:(BOOL)followStaus;

@end

NS_ASSUME_NONNULL_END
