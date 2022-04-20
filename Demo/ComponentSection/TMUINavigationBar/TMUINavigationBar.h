//
//  TMUINavigationBar.h
//  Demo
//
//  Created by Joe.cheng on 2022/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUINavigationBar : UIView
// 标题文字
@property (nonatomic, copy) NSString *title;
// 可以修改字体的样式
@property (nonatomic, strong) UILabel *centerTitleLabel;
// 默认添加一个返回按钮
@property (nonatomic, strong) UIButton *backButton;
// 是否隐藏底部阴影线条
@property (nonatomic, assign, getter=isHidenShadow) BOOL hidenShadow;
// 左边添加视图按钮
- (void)addLeftViews:(NSArray<UIView *> *)view;
// 右边边添加视图按钮
- (void)addRightViews:(NSArray<UIView *> *)view;

@end

NS_ASSUME_NONNULL_END
