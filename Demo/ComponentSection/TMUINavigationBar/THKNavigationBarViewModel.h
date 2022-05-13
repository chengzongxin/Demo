//
//  THKNavigationBarViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/5/12.
//

#import "THKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKNavigationBarContentType_Normal,
    THKNavigationBarContentType_Avatar,
    THKNavigationBarContentType_Search,
} THKNavigationBarContentType;

@interface THKNavigationBarViewModel : THKViewModel
///// navigation bar style, defalt Normal is Light  white background, black content
//@property (nonatomic, assign) THKNavigationBarStyle barStyle;
/// 内容
@property (nonatomic, assign) THKNavigationBarContentType contentType;
/// 简单设置标题
@property (nonatomic, strong) NSString *title;
/// 简单设置标题富文本
@property (nonatomic, strong) NSAttributedString *attrTitle;
/// 用户头部模型，显示用户头像、认证标识、关注按钮、分享按钮（例如：日记详情页）
//@property (nonatomic, strong) THKNavigationAvatarViewModel *avatarViewModel;
/// 搜索框模型，显示搜索框或者城市搜索框（例如：商城）
//@property (nonatomic, strong) THKNavigationSearchBarViewModel *searchBarViewModel;

@end

NS_ASSUME_NONNULL_END
