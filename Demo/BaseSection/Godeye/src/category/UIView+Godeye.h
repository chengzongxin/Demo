//
//  UIView+Godeye.h
//  Pods
//
//  Created by jerry.jiang on 2019/2/18.
//

#import <UIKit/UIKit.h>

@interface UIView (Godeye)


/**
 由数据中心分配，用于标识该组件
 */
@property (nonatomic, copy) NSString *geWidgetUid;


/**
 点击跳转h5时，需手动设置该值为h5链接
 */
@property (nonatomic, copy) NSString *geWidgetHref;


/**
 View是否在当前Screen范围内

 @return YES表示在,NO表示不在
 */
- (BOOL)isDisplayedInScreen;

@end
