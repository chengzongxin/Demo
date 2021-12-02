//
//  THKPageScrollView.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKDynamicTabsScrollView : UIScrollView

/// 是否开启无限滚动（嵌套Tab组件才需要开启）
@property (nonatomic, assign) BOOL isEnableInfiniteScroll;

@end

NS_ASSUME_NONNULL_END
