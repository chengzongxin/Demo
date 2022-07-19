//
//  THKNavigationSearchTitleViewModel.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2022/5/24.
//  Copyright © 2022 binxun. All rights reserved.
//

#import "THKNavigationTitleViewModel.h"

NS_ASSUME_NONNULL_BEGIN


/// 搜索框模型，显示搜索框或者城市搜索框（例如：商城）
@interface THKNavigationSearchTitleViewModel : THKNavigationTitleViewModel

@property (nonatomic, assign) TMUISearchBarStyle barStyle;
/// 是否显示取消按钮，默认NO
@property (nonatomic, assign) BOOL                              showsCancelButton;

@end

NS_ASSUME_NONNULL_END
