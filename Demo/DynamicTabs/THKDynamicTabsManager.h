//
//  THKDynamicTabsManager.h
//  HouseKeeper
//
//  Created by collen.zhang on 2021/10/15.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import "THKImageTabSegmentControl.h"
#import "THKDynamicTabsViewModel.h"
#import "TMUIPageWrapperScrollView.h"
#import "THKDynamicTabsPageVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDynamicTabsManager : NSObject

/**
 外部可根据需求定制sliderBar的样式，它的变化由viewmodel的segmentValueChangedSubject信号发出，外部不用再监听它的变化事件
 默认frame为CGRectMake(0, 0, kScreenWidth, 52.0-6)
 */
@property (nonatomic, strong, readonly)     THKDynamicTabsViewModel         *viewModel;
/// 常规效果时使用容器
@property (nonatomic, strong, readonly)     UIView                          *wrapperView;
/// 吸顶效果时会包含的容器
@property (nonatomic, strong, readonly)     TMUIPageWrapperScrollView       *wrapperScrollView;
/// 吸顶效果时头部使用容器
@property (nonatomic, strong, readonly)     UIView                          *headerWrapperView;
/// slider菜单
@property (nonatomic, strong, readonly)     THKImageTabSegmentControl       *sliderBar;
/// 子VC集合容器
@property (nonatomic, strong, readonly)     THKDynamicTabsPageVC            *pageContainerVC;


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

- (void)loadTabs;

/**
 获取指定位置的vc
 */
- (UIViewController *)getViewControllerWithIndex:(NSInteger)index;

- (NSInteger)currentIndex;

///当前控制器
- (UIViewController *)getCurrentViewController;

@end

NS_ASSUME_NONNULL_END

