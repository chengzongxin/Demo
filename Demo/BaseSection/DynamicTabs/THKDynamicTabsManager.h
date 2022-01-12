//
//  THKDynamicTabsManager.h
//  HouseKeeper
//
//  Created by collen.zhang on 2021/10/15.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THKImageTabSegmentControl.h"
#import "THKDynamicTabsViewModel.h"
#import "THKDynamicTabsWrapperScrollView.h"
#import "THKDynamicTabsPageVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol THKDynamicTabsManagerDelegate <NSObject>
@optional

/**
 PageVc滚动时回调
 UIScrollView滚动时回调, 可用来自定义 ScrollMenuView
 
 @param pageViewController PageVC
 @param scrollView UIScrollView
 @param progress 进度
 @param fromIndex 从哪个页面
 @param toIndex 到哪个页面
 */
- (void)pageViewController:(THKDynamicTabsPageVC *)pageViewController
                 didScroll:(UIScrollView *)scrollView
                  progress:(CGFloat)progress
                 formIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex;


/// 背景ScrollView滑动时回调
- (void)wrapperScrollViewDidScroll:(THKDynamicTabsWrapperScrollView *)wrapperScrollView;

/// 外层WrapperView滑动时回调
/// @param scrollView 滚动视图
/// @param diff 距离上次滚动偏移量
- (void)wrapperScrollViewDidScroll:(UIScrollView *)scrollView diff:(CGFloat)diff;


/// 内容ScrollView滑动时回调（通常是子vc的tableView或者collectionView）
/// @param scrollView 滚动视图
/// @param diff 距离上次滚动偏移量
- (void)contentScrollViewDidScroll:(UIScrollView *)scrollView diff:(CGFloat)diff;

///主VC开始刷新（非容器）
- (void)dynamicTabsManagerMainVCBeginingRefresh;

@end


@interface THKDynamicTabsManager : NSObject<THKDynamicTabsPageVCDelegate,UIScrollViewDelegate>

/**
 外部可根据需求定制sliderBar的样式，它的变化由viewmodel的segmentValueChangedSubject信号发出，外部不用再监听它的变化事件
 默认frame为CGRectMake(0, 0, kScreenWidth, 52.0-6)
 */
@property (nonatomic, strong, readonly)     THKDynamicTabsViewModel         *viewModel;
/// 常规效果时使用容器（根View）
@property (nonatomic, strong, readonly)     UIView                          *view;
/// 吸顶效果时会包含的容器
@property (nonatomic, strong, readonly)     THKDynamicTabsWrapperScrollView *wrapperScrollView;
/// 吸顶效果时头部使用容器
@property (nonatomic, strong, readonly)     UIView                          *headerWrapperView;
/// slider菜单
@property (nonatomic, strong, readonly)     THKImageTabSegmentControl       *sliderBar;
/// 子VC集合容器
@property (nonatomic, strong, readonly)     THKDynamicTabsPageVC            *pageContainerVC;
/// 代理
@property (nonatomic, weak)             id<THKDynamicTabsManagerDelegate>   delegate;

#pragma mark - 初始化集合
/**
 暂时不可用，用initWithViewModel初始化
 */
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
/**
 指定初始化方法，需要传入ViewModel
 */
- (instancetype)initWithViewModel:(THKDynamicTabsViewModel *)viewModel NS_DESIGNATED_INITIALIZER;


#pragma mark - 埋点事件集合
/**
 这个Block做了重复曝光的判断，如果你需要重复曝光，可以直接用sliderBar.itemExposeBlock
 */
@property (nonatomic, copy  ) THKSegmentControlItemEventBlock     tabButtonExposeBlock;

/**
 左右滑动切换tab事件
 */
@property (nonatomic, copy  ) THKSegmentControlItemEventBlock     tabButtonScrollBlock;

@property (nonatomic, assign) BOOL breakLayout;


#pragma mark - 外部方法调用

- (void)loadTabs;

- (void)updateSliderbarHeight:(CGFloat)height;

/// 是否子VC禁用滚动
@property (nonatomic, assign) BOOL isPageVCScrollEnable;

/**
 获取指定位置的vc
 */
- (UIViewController *)getViewControllerWithIndex:(NSInteger)index;

- (NSInteger)currentIndex;

///当前控制器
- (UIViewController *)getCurrentViewController;

@end


@interface THKDynamicTabsManager (THKRefresh)

- (void)setRefreshHeader:(CGFloat)inset;

- (void)endRefreshing;

@end


NS_ASSUME_NONNULL_END

