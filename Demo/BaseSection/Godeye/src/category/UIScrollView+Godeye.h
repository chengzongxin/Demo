//
//  UIScrollView+Godeye.h
//  Pods
//
//  Created by jerry.jiang on 2018/12/28.
//

#import <UIKit/UIKit.h>
#import "GEWidgetEvent.h"
#import <objc/runtime.h>
#import "GEScrollViewExposeManger.h"
#import "RegistScrollViewProxy.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary *(^GEExposeBlock)(NSIndexPath *indexPath);//曝光，return nil表示不曝光(过滤重复曝光)，如果需要曝光但是又不需要其他参数，则需要返回空字典:@{}
typedef void(^GEExposeItemsBlock)(NSArray<NSIndexPath *> *arrayIndexPaths);//

@interface UIScrollView (Godeye)

// 设置为YES则不上报曝光事件
@property (nonatomic, assign) BOOL disableExposeReport;
@property (nonatomic, weak) id<UIScrollViewDelegate>    originDelegate;

@property (nonatomic, copy) GEExposeBlock geExposeBlock;//当cell触发曝光时回调这个block，返回你的业务数据
@property (nonatomic, copy) GEExposeItemsBlock geExposeItemsBlock;//返回当前显示的所有cell，曝光由外部控制

/**
 判断曝光的功能是否有效，当设置了geExposeBlock或geExposeItemsBlock时，曝光才是有效的
 */
- (BOOL)exposeBlockEnabled;

/**
 触发当前可见cell的上报事件
 */
- (void)reportExpose;

/**
 从0.9.0开始，下面2个方法废弃
 */
- (void)registerSubview:(UIView *)view forExposeEvent:(GEWidgetExposeEvent *)expose;

- (void)reportRegisterViews;

@end

NS_ASSUME_NONNULL_END
