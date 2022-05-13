//
//  THKNavigationBarAvatarViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/5/13.
//

#import "THKNavigationBarViewModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 用户头部模型，显示用户头像、认证标识、关注按钮、分享按钮（例如：日记详情页）
@interface THKNavigationBarAvatarViewModel : THKNavigationBarViewModel

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, assign)NSInteger identificationType;///身份
@property (nonatomic, assign)NSInteger subCategory;///二级身份

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) BOOL followStaus;

@end

NS_ASSUME_NONNULL_END
