//
//  UIViewController+Godeye.h
//  Godeye
//
//  Created by jerry.jiang on 2018/12/25.
//  Copyright © 2018 jerry.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    GEPageShowMethodClick = 0,
    GEPageShowMethodScroll,
} GEPageShowMethod;


@interface UIViewController (Godeye)


/**
 设置为YES则不自动上报pageCicle事件
 */
@property (nonatomic, assign) BOOL geDisableAutoTrack;

/**
 通过什么方式打开当前页面，默认Click，为Scroll的时候需要手动设置
 */
@property (nonatomic, assign) GEPageShowMethod geShowMethod;

/**
 存在多个vc复用的地方需要手动设置pageTag加以区分
 */
@property (nonatomic, assign) NSUInteger gePageTag;

/**
 默认情况取类名，特殊情况下需要手动设置
 */
@property (nonatomic, copy) NSString *gePageUid;

/**
 当前页面的H5链接
 */
@property (nonatomic, copy) NSString *gePageUrl;

/**
 上一跳的页面，默认采集
 */
@property (nonatomic, copy) NSString *gePageReferUid;

/**
 上一跳的h5链接，需要手动赋值
 */
@property (nonatomic, copy) NSString *gePageReferUrl;

/**
 从哪个按钮点击而来，需要手动设置为该按钮的widgetUid
 */
@property (nonatomic, copy) NSString *geWidgetReferUid;


/**
 判断当前Controller是否已经加载

 @return YES表示已经加载, NO:表示尚未加载
 */
- (BOOL)isVisible;

/**
 页面名称，由产品或数据整理给到，要和android保持一致
 */
@property (nonatomic, copy) NSString *gePageName;

/**
 页面路径，由产品或数据整理给到，要和android保持一致，各层级用/分割
 例如：我的/直播中心/我的店铺
 */
@property (nonatomic, copy) NSString *gePageLevelPath;

/**
 是否用于显示，比如一些框架列的VC只承载页面，不用于显示，比如THKPageViewController
 默认为NO。如果不用于显示，需要手动设置它为YES
 */
@property (nonatomic, assign) BOOL gePageNotDisplay;

@end
