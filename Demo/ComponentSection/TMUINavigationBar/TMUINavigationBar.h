//
//  TMUINavigationBar.h
//  Demo
//
//  Created by Joe.cheng on 2022/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TMUINavigationBarStyle_Light,
    TMUINavigationBarStyle_Dark,
} TMUINavigationBarStyle;


typedef enum : NSUInteger {
    TMUINavigationBarLayout_LeftCenterRight,
    TMUINavigationBarLayout_LeftCenter,
    TMUINavigationBarLayout_CenterRight,
} TMUINavigationBarLayout;



@interface TMUINavigationBar : UIView


#pragma mark - Public Method ( Custom bar title & button item )
// 简单设置标题
@property (nonatomic, strong) NSString *title;
// 简单设置标题富文本
@property (nonatomic, strong) NSAttributedString *attrTitle;
// titleView
@property (nonatomic, strong) UIView *titleView;
// titleView
@property (nonatomic, strong) UIImage *backgroundImage;
// back button
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
// back button
@property (nonatomic, strong, readonly) UIButton *backBtn UI_APPEARANCE_SELECTOR;
// right button
@property (nonatomic, strong, readonly) UIButton *rightBtn;
// navigation bar style, defalt Normal is Light  white background, black content
@property (nonatomic, assign) TMUINavigationBarStyle barStyle;
/// titleView 内容缩进
@property (nonatomic, assign) UIEdgeInsets titleViewInset;
// navigation bar titleView Inset, defalut {0,20,0,20},titleView距离父视图左右边距
@property (nonatomic, assign) UIEdgeInsets titleViewEdgeInsetWhenHiddenEdgeButton;
// hidden back button
- (void)setIsBackButtonHidden:(BOOL)isBackButtonHidden animate:(BOOL)animate;
@property (nonatomic, assign) BOOL isBackButtonHidden;
// hidden right button
- (void)setIsRightButtonHidden:(BOOL)isRightButtonHidden animate:(BOOL)animate;
@property (nonatomic, assign) BOOL isRightButtonHidden;
#pragma mark - public method by block
// 自定义titleView
- (void)configContent:(__kindof UIView * (^)(UIView * contentView))blk;
// 自定义返回按钮
- (void)configLeftContent:(void (^)(UIButton * backBtn))blk;
// 自定义右侧按钮
- (void)configRightContent:(void (^)(UIButton * rightBtn))blk;

/**
 设置导航条在scrollview滚动过程可渐变效果

 @param color 导航条最终颜色
 @param oriTintColor 导航条上的内容变化之前的默认颜色
 @param toTintColor 导航条上的内容可能也需要调整的目标颜色
 @param percent 颜色计算的百分比，颜色的过渡进度百分比，取值【0，1】，<=0 按0， >=1 按1
 @warning 导航条上的内容颜色过渡由oriTintColor和toTintColor联合决定
 @warning 导航条的titleview里仅处理label的textColor颜色变化，若是其它类型子视图则不会变换颜色
 @note 内部会处理使导航条的navigationItem的左右item视图相关imageView颜色渐变
 @note titleview的其它alpha值变化，交给外部控制，此方法内部仅控制相关颜色
 @warning navigationItem的左右item视图只有全icon样式渐变效果才好，若有文字则文字部分的颜色不会渐变
 */
- (void)setNavigationBarColor:(UIColor *)color originTintColor:(UIColor *)oriTintColor toTintColor:(UIColor *)toTintColor gradientPercent:(float)percent;

//注：9.10二级装企页面专用 0 透明底白字白图标 1 白底黑字黑图标。
- (void)setStyle:(CGFloat)style;

/// 供外界VC访问，根据滑动percent，动态切换状态栏样式
@property (nonatomic, assign, readonly) UIStatusBarStyle preferredStatusBarStyle;


//// 标题文字
//@property (nonatomic, copy) NSString *title;
//// 可以修改字体的样式
//@property (nonatomic, strong) UILabel *centerTitleLabel;
//// 默认添加一个返回按钮
//@property (nonatomic, strong) UIButton *backButton;
//// 是否隐藏底部阴影线条
//@property (nonatomic, assign, getter=isHidenShadow) BOOL hidenShadow;
//// 左边添加视图按钮
//- (void)addLeftViews:(NSArray<UIView *> *)view;
//// 右边边添加视图按钮
//- (void)addRightViews:(NSArray<UIView *> *)view;

@end

NS_ASSUME_NONNULL_END
