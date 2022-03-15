//
//  THKNavigationBar.h
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    THKNavigationBarStyle_Light,
    THKNavigationBarStyle_Dark,
} THKNavigationBarStyle;


typedef enum : NSUInteger {
    THKNavigationBarLayout_LeftCenterRight,
    THKNavigationBarLayout_LeftCenter,
    THKNavigationBarLayout_CenterRight,
} THKNavigationBarLayout;

/**
 顶部导航条整体视图，内部的实际展示内容可操作下面的navigationBar对象
 @note 外部不要用InitXxx方法初始化，直接用提供的便捷方法初始化即可，内部会根据设备型号生成合适高度的对象
 
  Usage:
    ```
 // viewDidLoad 下添加下面3行代码：
 self.navBarHidden = YES;
 THKNavigationBar *navBar = [[THKNavigationBar alloc] init];
 [self.view addSubview:navBar];
    ```
 */
@interface THKNavigationBar : UIView

#pragma mark - Public Method ( Custom bar title & button item )
// 简单设置标题
@property (nonatomic, strong) NSString *title;
// 简单设置标题富文本
@property (nonatomic, strong) NSAttributedString *attrTitle;
// titleView
@property (nonatomic, strong) UIView *titleView;
// back button
@property (nonatomic, strong, readonly) UIButton *backBtn UI_APPEARANCE_SELECTOR;
// right button
@property (nonatomic, strong, readonly) UIButton *rightBtn;
// navigation bar style, defalt Normal is Light  white background, black content
@property (nonatomic, assign) THKNavigationBarStyle barStyle;
// navigation bar layout syle
@property (nonatomic, assign) THKNavigationBarLayout barLayout;

@property (nonatomic, assign) BOOL hideBackButton;

@property (nonatomic, assign) BOOL hideRightButton;
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

@end

NS_ASSUME_NONNULL_END
