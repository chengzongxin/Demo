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
#import "THKPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDynamicTabsManager : NSObject

/**
 外部可根据需求定制sliderBar的样式，它的变化由viewmodel的segmentValueChangedSubject信号发出，外部不用再监听它的变化事件
 默认frame为CGRectMake(0, 0, kScreenWidth, 52.0-6)
 */
@property (nonatomic, strong, readonly)     THKDynamicTabsViewModel         *viewModel;
@property (nonatomic, strong, readonly)     TMUIPageWrapperScrollView       *wrapperScrollView;
@property (nonatomic, strong, readonly)     UIView                          *wrapperView;
@property (nonatomic, strong, readonly)     UIView                          *headerView;
@property (nonatomic, strong, readonly)     THKImageTabSegmentControl       *sliderBar;
@property (nonatomic, strong, readonly)     THKPageViewController           *pageContainerVC;

/**
 这个Block做了重复曝光的判断，如果你需要重复曝光，可以直接用sliderBar.itemExposeBlock
 */
@property (nonatomic, copy  ) THKSegmentControlItemEventBlock     tabButtonExposeBlock;

/**
 左右滑动切换tab事件
 */
@property (nonatomic, copy  ) THKSegmentControlItemEventBlock     tabButtonScrollBlock;

@property (nonatomic, assign) BOOL breakLayout;

/**
 初始化出入viewmodel，如果不传入，则内部新建一个viewmodel
 */
- (instancetype)initWithViewModel:(THKDynamicTabsViewModel *)viewModel;

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

