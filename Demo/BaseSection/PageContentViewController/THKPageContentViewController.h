//
//  ViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import <UIKit/UIKit.h>
#import "THKPageBGScrollView.h"
#import "THKSegmentControl.h"
#import "THKViewController.h"
#import "THKPageContentScrollView.h"

@class THKPageContentViewController;
@class THKPageHeaderVisualEffectView;

@protocol THKPageChildVCRefreshProtocol <NSObject>

@optional
/// 子VC开始下拉刷新，实现此方法，并在方法体内实现加载数据请求
- (void)childViewControllerBeginRefreshing;

/// 子VC开始下拉刷新，实现此方法，并在方法体内实现加载数据请求
- (void)childViewControllerBeginRefreshingWithPara:(NSDictionary *)para;

/// 已添加默认实现，子VC只需要调用该方法，结束下拉刷新
- (void)childViewControllerEndRefreshing;

/// 子VC在tabbar中点击事件
- (void)childViewControllerTabbarDidRepeatSelect;

@end

@protocol THKPageContentViewControllerDataSource <NSObject>

@required
/// 返回所有的子VC
- (NSArray <UIViewController *> *)viewControllersForChildViewControllers;

- (UIViewController *)viewControllerForContentController;

/// 返回子VC标题
- (NSArray <NSString *> *)titlesForChildViewControllers;

@optional
/// 固定头部的高度
- (CGFloat)heightForHeader;
/// 固定头部的View
- (UIView *)viewForHeader;

/*
 分三种情况:  如果有自定义导航栏需要实现这个方法,如果是附加到headerView上的，也需要实现（返回0)（没有使用系统导航栏, 并且导航栏是固定悬浮，不是加到headerView上随之滚动的）
 1. 隐藏导航栏，实现该方法，并返回0
 2. 使用系统导航栏，不实现该方法，内部自动计算导航栏高度，实现吸顶效果
 2. 使用自定义导航栏，实现该方法，返回自定义导航栏的高度，eg: 44， 56...
 @note 通常标准情况下，此方法应该固定返回44，若自定义的导航高度非标准高度则返回其它值，但注意⚠️⚠️⚠️：返回值不应该包含状态条的高度，
 */
- (CGFloat)heightForNavBar;
/// 滑动tab的高度
- (CGFloat)heightForSliderBar;
/// 用于自定义配置SliderBar，拿到control后可以设置选中，颜色，埋点曝光等tab属性。如果设置frame，heightForSliderBar代理方法无效，注意不要重写UIControlEventValueChanged事件，内部已做滑动交互
- (void)segmentControlConfig:(THKSegmentControl *)control;

@end

@protocol THKPageContentViewControllerDelegate <NSObject>
/// 子VC滑动回调事件
- (void)pageContentViewControllerDidScrolFrom:(NSInteger)fromVC to:(NSInteger)toVC;
/// scrollView滑动回调事件
- (void)pageContentViewControllerDidScroll:(UIScrollView *)scrollView;

@end

@interface THKPageContentViewController : THKViewController <THKPageContentViewControllerDataSource,THKPageContentViewControllerDelegate,THKTabBarRepeatSelectProtocol>
/// 数据源方法，默认Self
@property (nonatomic, weak) id<THKPageContentViewControllerDataSource> dataSource;
/// 代理方法，默认Self
@property (nonatomic, weak) id<THKPageContentViewControllerDelegate> delegate;
/// 当前被选中的indexVC
@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, assign, readonly) CGFloat sliderBarHeight;

@property (nonatomic, strong, readonly) NSArray <NSString *> *childTitles;

@property (nonatomic, strong, readonly) NSArray <UIViewController *> *childVCs;
/* 组件视图*/
/// 总的背景ScrollView
@property (nonatomic, strong, readonly) THKPageBGScrollView *contentView;
/// 头部遮罩
@property (nonatomic, strong, readonly) THKPageHeaderVisualEffectView *effectView;
/// 滑动tab
@property (nonatomic, strong, readonly) THKSegmentControl *slideBar;
/// 承载子VC的view的scrollView
@property (nonatomic, strong, readonly) THKPageContentScrollView *contentScrollView;

/// 刷新数据源，会初始化所有属性和子视图，重新调代理方法渲染界面
- (void)reloadData;

/// 滑动到某一个子VC
- (void)scrollTo:(UIViewController *)vc;

/// 滑动到某一个index指向的VC
- (void)scrollToIndex:(NSInteger)index animate:(BOOL)animate;

/// 滑动到顶部
/// @param animate 是否使用系统动画
- (void)scrollToTopAnimate:(BOOL)animate;

/// 下拉刷新,注意，每次reloadData后都需要重新添加下拉刷新，因为reload后，会重置清理所有视图
/// @param freshBlock 刷新block
- (void)addRefreshWithBlock:(dispatch_block_t)freshBlock;

/// 开始执行childVC下拉刷新,会调用childVc的childViewControllerBeginRefreshing协议方法，默认只刷新正在显示的childVC，不刷新滑出屏幕的childVC
- (void)childVCsBeginRefresh;

/// 开始执行childVC下拉刷新,会调用childVc的childViewControllerBeginRefreshing协议方法
/// @param forceAll 刷新所有已加载的子VC
- (void)childVCsBeginRefresh:(BOOL)forceAll;


/// 开始执行childVC下拉刷新,会调用childVc的childViewControllerBeginRefreshing协议方法
/// @param para 传给子类的参数
/// @param forceAll 刷新所有VC
- (void)childVCsBeginRefreshWithPara:(NSDictionary *)para forceAll:(BOOL)forceAll;

/// 停止刷新
- (void)endRefreshing;

/// 是否在滑动的时候给headerView加上模糊效果（在没有导航栏的时候，不会层叠在状态栏下）
@property (nonatomic, assign) BOOL isEnableHeaderViewBlurWhenScroll;

/// sliderbar置顶时变成白色
@property (nonatomic, assign) BOOL changeSliderBarColorWhenScrollToTop;

#pragma mark - content height methods

/// 重新加载子视图，因刷新等操作可能会调用多次, 因内容有一些视图层级默认加载，子类重写时必须先调用super完成默认的视图加载
- (void)addSubviews NS_REQUIRES_SUPER;

/// contentView的显示高度，内部有默认处理，仅当isUseSystemNavBar为YES时此方法会被调用用来确定contentView的实际显示高度
/// 子类可重写返回合适的值。 默认返回 return kMainScreenHeight - tmui_navigationBarHeight();
- (CGFloat)contentViewHeight;

/// 内部子childVc的父容器scrollView视图的高度距离底部的安全距离，默认返回0，对于一些底部有其它工具视图的情况可能需要重写返回对应的安全距离高度
- (CGFloat)contentScrollBottomSafeArea;

/// contentView的背景色，默认返回whiteColor
- (UIColor *)contentViewBackgroundColor;

@end

