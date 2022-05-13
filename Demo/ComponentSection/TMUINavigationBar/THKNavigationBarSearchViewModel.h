//
//  THKNavigationBarSearchViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/5/13.
//

#import "THKNavigationBarViewModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 搜索框模型，显示搜索框或者城市搜索框（例如：商城）
@interface THKNavigationBarSearchViewModel : THKNavigationBarViewModel

@property (nonatomic, assign) TMUISearchBarStyle barStyle;

@end

NS_ASSUME_NONNULL_END
