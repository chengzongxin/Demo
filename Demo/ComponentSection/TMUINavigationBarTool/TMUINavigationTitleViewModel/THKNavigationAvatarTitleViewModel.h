//
//  THKNavigationBarAvatarViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/5/13.
//

#import "THKNavigationTitleViewModel.h"
#import "THKFocusButtonView.h"
//#import "THKUserHomeRouter.h"
NS_ASSUME_NONNULL_BEGIN
/// 用户头部模型，显示用户头像、认证标识、关注按钮、分享按钮（例如：日记详情页）
@interface THKNavigationAvatarTitleViewModel : THKNavigationTitleViewModel

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *descText;
/// 用户标识0 业主 1 设计师 2 装修公司 3 商家
//@property (nonatomic, assign) NSInteger authorIdentity;
@property (nonatomic, assign) NSInteger identificationType;///身份
@property (nonatomic, assign) NSInteger subCategory;///二级身份

/// 用户类型
//@property (nonatomic, assign) THKUserIdentityType userIdentityType;
/// 用户id，设计师id，装企id
@property (nonatomic, assign) NSInteger uid;
/// 装企id
//@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger followStaus;
/// 关注状态后是否要隐藏，某些场景下，由未关注变为关注状态时要隐藏次按钮，防止用户取消关注；默认为YES，如果关注后不需要隐藏，则要手动把这个值设置为NO
@property (nonatomic, assign) BOOL hideAfterFollowed;
/// 取消关注是否禁止弹引导弹窗
@property (nonatomic, assign) BOOL disableAlertViewWhenCancelFollowed;
/// 关注按钮的样式, 默认为FocusButtonViewStyle_Gray_Normal
@property (nonatomic, assign) FocusButtonViewStyle focusStyle;

@end

NS_ASSUME_NONNULL_END
