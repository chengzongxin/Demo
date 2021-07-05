//
//  THKSearchAnimation+UI.h
//  HouseKeeper
//
//  Created by ben.gan on 2020/12/1.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKSearchAnimation.h"
#import "THKSearchView.h"
#import "TMSearchBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKSearchAnimation (UI)

/**
 统一自定义导航栏（44高）
 * @return 导航栏
 */
+ (UIView *)navBkgView;

/**
 统一搜索框UI（纯展示，有滚动字符）
 * @param highlighted 高亮
 * @return 搜索框
 */
+ (THKSearchView *)searchView:(BOOL)highlighted;

/**
 统一搜索框UI（输入型搜索框）
 * @return 搜索框
 */
+ (TMSearchBar *)searchBar;

/**
 统一取消按钮
 * @return 取消按钮
 */
+ (UIButton *)cancelBtn;

/**
 统一返回按钮
 * @return 返回按钮
 */
+ (UIButton *)backBtn;

@end

NS_ASSUME_NONNULL_END
