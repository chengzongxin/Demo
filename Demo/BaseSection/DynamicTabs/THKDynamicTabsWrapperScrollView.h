//
//  THKDynamicTabsWrapperScrollView.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/12/21.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKDynamicTabsScrollView.h"
#import "THKDynamicTabsViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class THKDynamicTabsWrapperScrollView;

@protocol THKDynamicTabsWrapperScrollViewDelegate <UIScrollViewDelegate>

@optional
/// 吸顶状态改变回调
- (void)pageWrapperScrollView:(THKDynamicTabsWrapperScrollView *)pageWrapperScrollView pin:(BOOL)pin;
/// 真实滑动（不被吸顶影响的滑动事件）
- (void)pageWrapperScrollViewRealChanged:(THKDynamicTabsWrapperScrollView *)pageWrapperScrollView diff:(CGFloat)diff;
/// 内部scrollView滑动
- (void)pageWrapperContentScrollViewChanged:(UIScrollView *)contentScrollView diff:(CGFloat)diff;

@end

@interface THKDynamicTabsWrapperScrollView : THKDynamicTabsScrollView

/// 头部固定区域
@property (nonatomic, assign) CGFloat lockArea;
/// 是否头部固定
@property (nonatomic, assign, readonly) BOOL pin;

@property (nullable, nonatomic, weak) id<THKDynamicTabsWrapperScrollViewDelegate> delegate;

/// 首页切换页面时，系统私有方法会更改contentoffset，在切换的时候先禁用掉此功能以免抖动
@property (nonatomic, assign) BOOL disableAdjustContentOffsetIfNecessary;

/// manager的布局方式，对于THKDynamicTabsLayoutType_Interaction 需要特别处理
@property (nonatomic, assign) THKDynamicTabsLayoutType layout;

///重新设置头部时，滑动动顶部时的动画
@property (nonatomic, assign) BOOL resetHeaderScrollAnimated;

/// 滑动到顶部
- (void)scrollToTop:(BOOL)animated;
/// 子VC下拉后左右滑动，需要把内部scrollView置顶
- (void)childViewControllerDidChanged:(UIViewController *)vc;

@end

@interface UIScrollView (THKDynamic_PageComponent)
#pragma mark - 私有属性
/// 滑动某一个scrollView时，禁止Wrapper联动滑动，通常在子VC中有弹窗类scrollView时，需要禁止弹窗scrollView的联动Wrapper，或者有包多层scrollView时使用
@property (nonatomic, assign) BOOL thk_isWarpperNotScroll;
/// 是否包含刷新头部组件、如果子VC需要下拉，则需要设置此值，否则只会响应父scrollView的下拉刷新
@property (nonatomic, assign) BOOL thk_isAddRefreshControl;

#pragma mark - 快捷访问方法
/// scrollView顶部坐标
@property (nonatomic, assign, readonly) CGPoint thk_topPoint;
/// scrollView是否在顶部
@property (nonatomic, assign, readonly) BOOL thk_isAtTop;

//- (void)_adjustContentOffsetIfNecessary;
@end


NS_ASSUME_NONNULL_END
