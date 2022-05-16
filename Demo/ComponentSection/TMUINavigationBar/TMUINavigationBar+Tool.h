//
//  TMUINavigationBar+Tool.h
//  Demo
//
//  Created by Joe.cheng on 2022/5/16.
//

#import "TMUINavigationBar.h"
#import "THKViewModel.h"
#import "THKNavigationBarViewModel.h"
#import "THKNavigationAvatarTitleView.h"
#import "THKNavigationBarAvatarViewModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    TMUINavigationBarContentType_Normal,
    TMUINavigationBarContentType_Avatar,
    TMUINavigationBarContentType_Search,
} TMUINavigationBarContentType;

@interface TMUINavigationBarViewModel : THKViewModel
///// navigation bar style, defalt Normal is Light  white background, black content
//@property (nonatomic, assign) THKNavigationBarStyle barStyle;
/// 内容
@property (nonatomic, assign) TMUINavigationBarContentType contentType;
/// 简单设置标题
@property (nonatomic, strong) NSString *title;
/// 简单设置标题富文本
@property (nonatomic, strong) NSAttributedString *attrTitle;
/// 用户头部模型，显示用户头像、认证标识、关注按钮、分享按钮（例如：日记详情页）
//@property (nonatomic, strong) THKNavigationAvatarViewModel *avatarViewModel;
/// 搜索框模型，显示搜索框或者城市搜索框（例如：商城）
//@property (nonatomic, strong) THKNavigationSearchBarViewModel *searchBarViewModel;

@end

@interface TMUINavigationBar (Tool)

@property (nonatomic, strong) TMUINavigationBarViewModel *viewModel;
/// 内容
@property (nonatomic, assign) TMUINavigationBarContentType contentType;
/// 简单设置标题
@property (nonatomic, strong) NSString *title;
/// 简单设置标题富文本
@property (nonatomic, strong) NSAttributedString *attrTitle;

- (void)bindViewModel:(TMUINavigationBarViewModel *)viewModel;


@end

NS_ASSUME_NONNULL_END
