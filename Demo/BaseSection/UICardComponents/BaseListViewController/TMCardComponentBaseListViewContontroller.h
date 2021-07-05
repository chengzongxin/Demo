//
//  TMCardComponentBaseListViewContontroller.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "THKViewController.h"
#import "TMCardComponentBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

/**封装了卡片瀑布流相关UI及通用处理逻辑的基类
 @warning 此基类不能被直接初始化，应该继承并实现相关数据方法才能使UI正确展示
 @warning 若是卡片组件本身支持的样式则对应的数据格式必须满足协议 TMCardComponentCellDataProtocol;
 @warning 若是外部自定义卡片样式对应的数据格式则必须满足协议 TMCardComponentCellDataBasicProtocol;
 */
@interface TMCardComponentBaseListViewContontroller : THKViewController

///MARK: 以下两个可读取属性为直接跳转listView里的相关属性

@property (nonatomic, strong, readonly)TMCardComponentCollectionViewLayout *layout;///< 外部初始时可以根据实际情况调整相关配置参数
/**
反回内容列表上下滑动的scrollview对象，外部用在此基础上扩展上拉、下拉刷新等操作
@warning 此方法仅为get方法，不支持kvo
@warning 外部不要修改scrollview的delegate，若实在需要中转scrollview的delegate请在中转的时候不要影响原本的delegate响应(截取不影响原实现的相关手段可参考工程里相关基于NSProxy上的Adaptor协议处理方式)
*/
@property (nonatomic, strong, readonly)UIScrollView *scrollView;

#pragma mark - 以下相关操作api接口为直接跳转listView里的相关操作： reload or inert Data

/**
 当数据变化后调用此来刷新列表UI
 */
- (void)reloadData;

/**
 当需要在列表里动态插入数据及更新列表UI时的方法
 */
- (void)insertItemsWithBlock:(NSArray<NSIndexPath *> *(^)(void))dataInsertBlock;

/**
 当需要在列表里动态删除数据及更新列表UI时的方法
 */
- (void)deleteItemsWithBlock:(NSArray<NSIndexPath *> *(^)(void))dataDeleteBlock;

/**可同时执行插入和删除操作并对应更新列表UI的方法
 @note 外部往两个可变数组中添加本次操作要插入及要删除的项对应的indexPath对象即可
 */
- (void)updateItemsWithBlock:(void(^)(NSMutableArray<NSIndexPath *> *toAddIndexPaths, NSMutableArray<NSIndexPath *> *toDeleteIndexPaths))updateBlock;

/**
 将列表展示内容滚动到指定的索引位置
 */
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

/**
 返回当前显示区域内显示的cell对应的indexPaths数组
 */
- (NSArray<NSIndexPath *> *)visibleIndexPaths;

/// !!!: 以下相关方法为列表展示需要的相关数据源数据及相关UI配置项，部分方法实现有默认值，子类根据实际情况选择重写相关方法
/// !!!: 相关cell的暴光上报及点击上报，子类只用实现相关数据的获取方法即可，具体上报逻辑内部已统一处理

#pragma mark - 列表滚动停止时的回调，子类可根据需要进行重写

/** 当reload或setContentoffset或scrollToItemAtIndexPath或其它手动拖动等行为，只要是滑动结束则进行相关回调，将当前滑动停止时当前页显示的可见的数据indexPath数组回调给上层
@note 主要是首页有相关广告数据在当前页展示时的接口上报逻辑需要
@warning 若当前内部取到的可视的indexPath数组为空则不会触发此回调，即只有当至少有一条数据在当前页面展示时才会回调
 */
- (void)didEndScrollWithVisibleIndexPaths:(NSArray<NSIndexPath *> *)visibleIndexPaths;

#pragma mark - 设置内部collectionview相关dataSource数据
- (NSInteger)numberOfSections;///< 默认返回1
- (NSInteger)numberOfItemsInSection:(NSInteger)section;///< 默认返回0,此方法子类必须重写实现
- (NSInteger)columnsInSection:(NSInteger)section;///< 默认返回2，即双瀑布流样式

/**
 默认返回nil,此方法子类必须重写实现
 @warning 若是卡片组件本身支持的样式则对应的数据格式必须满足协议 TMCardComponentCellDataProtocol;
 @warning 若是外部自定义卡片样式对应的数据格式则必须满足协议 TMCardComponentCellDataBasicProtocol;
 */
- (NSObject<TMCardComponentCellDataBasicProtocol> *)dataAtIndexPath:(NSIndexPath *)indexPath;

/**
 点击了相关cell的回调. 子类根据实际使用场景决定是否需要重写相关实现
 @note 父类会默认处理当前支持类型的相关跳转。若为自定义类型的cell则需要子类自行处理
 @note 父类默认点击响应为执行当前选择的数据项对应的路由串的路由跳转动作
 @note 若一些特定场景需要其它处理则子类自行实现相关跳转处理逻辑，比如：效果图列表跳转效果图详情页、视频列表跳转视频详情页等 需要传入连续性的列表数据的则需要子类单独额外处理
 @warning 若子类重写相关实现，若某些类型需要保持默认点击处理则调用super，仅针对不需要默认点击处理的场景自行实现即可
 @warning 若子类全部自行重写实现则【不要】调用super
 */
- (void)didClickCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data;

///8.12 add 外部可在didClickCell：xxxx回调里生成路由，再通过调用此接口来达到瀑布流列表页相关路由跳转的统一控制的目的
///@note 因部分子类，通过data里的数据生成相关路由router的过程中，还可能添加一些自定义的处理逻辑，所以这里再提供一个外部传入router对象的统一跳转接口
- (void)doRouterJump:(TRouter *)router withClickCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data;

#pragma mark - 若有自定义样式的cell则重写以下方法
- (NSString *)customCellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data;///< 若有其它自定义样式的卡片cell则子类重写实现
- (void)registCustomCellInCollectionView:(UICollectionView *)collectionView;///< 若有其它自定义样式的卡片cell则子类重写实现
- (void)fillCustomCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data;///< 若有其它自定义样式的卡片cell则子类重写实现

#pragma mark - 当内部执行cellForItem方法按正常流程或自定义流程生成了有效的cell后，会额外回调一次以下方法，以便子类可对标准的卡片组件做一些扩展的UI调整(通常是在标准组件视图层上添加其它功能项子视图，例如：选择、删除蒙层等)
/// optional 子类根据需要选择重写
- (void)extraAddUIElementsOnCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data;///< 在cellFotItem流程生成有效的cell后会额外执行此函数方便子类对已有的卡片组件做一些其它需要的调整(主要是添加额外的子UI元素)

#pragma mark - 设置section Header & Footer的方法，子类根据实际情况选择实现
- (UIEdgeInsets)sectionInsectsAtSection:(NSInteger)section;///< 默认返回layout初始值
- (CGFloat)sectionHeaderHeightAtSection:(NSInteger)section;///< 默认返回 CGFLOAT_MIN
- (CGFloat)sectionFooterHeight;///< 默认返回 CGFLOAT_MIN
- (CGFloat)minimumInteritemSpacingAtSection:(NSInteger)section;///< 默认返回layout初始值
- (void)fillContentInHeaderView:(UICollectionReusableView *)sectionHeaderView atSection:(NSInteger)section;///< 填充sectionHeader视图的相关contentView
- (void)fillContentInFooterView:(UICollectionReusableView *)sectionFooterView atSection:(NSInteger)section;///< 填充sectionFooter视图的相关contentView

///!!!: ⚠️⚠️⚠️
///⚠️⚠️⚠️ 8.11 优化一些逻辑，防止不需要悬停功能时也会触发悬停的相关位置判断处理逻辑，导致列表一滑动就总是在响应不停的计算布局数据逻辑。
///出于列表滑动的流畅度及内存、cpu等的优化提升，这里增加一个前置开关属性needFloatingHeaderSupport，协助原方法一起工作。只有当needFloatingHeaderSupport设置为YES时，原方法实现代码才会真实生效
/// ⚠️⚠️⚠️：下面关于sectionHeader视图是否支持悬念的接口，只有当needFloatingHeaderSupport为YES时，下面的floatingHeaderAtIndexPath:方法的返回值才会有实际效果.

@property (nonatomic, assign)BOOL needFloatingHeaderSupport;///< 是否需要支持header视图的悬停功能，默认为NO

///当对应的sectionHeader需要悬念时返回YES，不需要则返回NO。默认返回NO
///@note v8.11 优化-需要悬停时还需要将前置开关 needFloatingHeaderSupport 手动设置为YES.只开关为YES时才会执行下面方法回调处理逻辑
- (BOOL)floatingHeaderAtIndexPath:(NSIndexPath *)indexPath;

- (void)willDisplayCell:(__kindof UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)didEndDisplayCell:(__kindof UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 埋点相关方法,需要子类实现提供具体数据值
- (NSString *_Nullable)reportWidgetUidOfCellAtIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull)data;
- (NSDictionary *_Nullable)reportResourceOfCellAtIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull)data;

@end

NS_ASSUME_NONNULL_END
