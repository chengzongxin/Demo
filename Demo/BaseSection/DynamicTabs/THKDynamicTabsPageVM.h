//
//  THKDynamicTabsPageVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import "THKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDynamicTabsPageVM : THKViewModel

#pragma mark - YNPage Config
/** 裁剪内容高度 用来添加最上层控件 添加在父类view上 */
@property (nonatomic, assign) CGFloat cutOutHeight;
/** 页面是否可以滚动 默认 YES */
@property (nonatomic, assign) BOOL pageScrollEnabled;
/// 是否开启无限滚动（嵌套Tab组件才需要开启）
@property (nonatomic, assign) BOOL isEnableInfiniteScroll;
@end

NS_ASSUME_NONNULL_END
