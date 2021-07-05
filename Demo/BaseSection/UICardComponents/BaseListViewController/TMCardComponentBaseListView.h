//
//  TMCardComponentBaseListView.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMCardComponentCollectionViewLayout.h"

#import "TMCardComponentCellProtocol.h"
#import "TMCardComponentCellDataProtocol.h"

#import "TMCardComponentCellSizeTool.h"
#import "TMCardComponentCellStyle.h"
#import "TMCardComponentCells.h"

typedef NSString TMBasicCardCellIdentifier;

NS_ASSUME_NONNULL_BEGIN

/** 卡片瀑布流组件列表视图
@warning 若是卡片组件本身支持的样式则对应的数据格式必须满足协议 TMCardComponentCellDataProtocol;
@warning 若是外部自定义卡片样式对应的数据格式则必须满足协议 TMCardComponentCellDataBasicProtocol;
*/
@interface TMCardComponentBaseListView : UIView

@property (nonatomic, strong, readonly)TMCardComponentCollectionViewLayout *layout;///< 外部初始时可以根据实际情况调整相关配置参数

/**
 反回内容列表上下滑动的scrollview对象，外部用在此基础上扩展上拉、下拉刷新等操作
 @warning 此方法仅为get方法，不支持kvo
 @warning 外部不要修改scrollview的delegate，若实在需要中转scrollview的delegate请在中转的时候不要影响原本的delegate响应(截取不影响原实现的相关手段可参考工程里相关基于NSProxy上的Adaptor协议处理方式)
 */
@property (nonatomic, strong, readonly)UIScrollView *scrollView;

#pragma mark - reload or inert Data

/**
当数据变化后调用此来刷新列表UI
*/
- (void)reloadData;

/**
 当需要在列表里动态插入数据及更新列表UI时的方法
 @warning 相关数据源列表的数据插入变化可以在dataInsertBlock里实现，也可以放到调用此方法前的外部逻辑里添加，但若需要UI执行相关更新，则block需要返回插入位置的indexPath数组
 @warning 需要返回插入位置的indexPath的数组
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

#pragma mark - 瀑布流列表相关数据源回调

/**当reload或setContentoffset或scrollToItemAtIndexPath或其它手动拖动等行为，只要是滑动结束则进行相关回调，将当前滑动停止时当前页显示的可见的数据indexPath数组回调给上层
 @note 主要是首页有相关广告数据在当前页展示时的接口上报逻辑需要
 @warning 若当前内部取到的可视的indexPath数组为空则不会触发此回调，即只有当至少有一条数据在当前页面展示时才会回调
 */
@property (nonatomic, copy, nullable)void (^didEndScrollWithVisibleIndexPathsBlock)(NSArray<NSIndexPath *> *visibleIndexPaths);

@property (nonatomic, copy, nullable)void (^willDisplayCellAtIndexPathBlock)(__kindof UICollectionViewCell *cell, NSIndexPath * indexPath);
@property (nonatomic, copy, nullable)void (^didEndDisplayCellAtIndexPathBlock)(__kindof UICollectionViewCell *cell, NSIndexPath * indexPath);

#pragma mark - sections & items configs block
@property (nonatomic, copy)BOOL (^floatingHeaderAtIndexPath)(NSIndexPath *indexPath);///<控制 indexPath的header是否悬浮
/**获取内部瀑布流列表多少个sections的回调
 @note 若不赋值实现，则内部默认为1个section
 */
@property (nonatomic, copy, nullable)NSInteger (^numberOfSectionsBlock)(TMCardComponentBaseListView *cardsCollectionView);

/**获取内部瀑布流列表某个section下多少个items的回调
 @note 若不赋值实现，则内部默认为返回0个items
 */
@property (nonatomic, copy)NSInteger (^numberOfItemsInSectionBlock)(TMCardComponentBaseListView *cardsCollectionView, NSInteger section);

/**获取内部瀑布流列表某个section下显示成多少列
@note 若不赋值实现，则内部默认为指定显示2列
*/
@property (nonatomic, copy, nullable)NSInteger (^columnsInSectionBlock)(TMCardComponentBaseListView *cardsCollectionView, NSInteger section);

/**获取指定索引位置的数据对象
 @note 返回的数据对象应该实现指定的相关协议
 */
@property (nonatomic, copy)NSObject<TMCardComponentCellDataBasicProtocol> * (^dataAtIndexPathBlock)(TMCardComponentBaseListView *cardsCollectionView, NSIndexPath *indexPath);

/** 点击了cell的回调
 */
@property (nonatomic, copy)void (^clickCellBlock)(TMCardComponentBaseListView *cardsCollectionView, UICollectionViewCell *cell, NSIndexPath *indexPath, NSObject<TMCardComponentCellDataBasicProtocol> *data);

#pragma mark - 当内部执行cellForItem方法按正常流程或自定义流程生成了有效的cell后，会额外回调一次以下方法，以便子类可对标准的卡片组件做一些扩展的UI调整(通常是在标准组件视图层上添加其它功能项子视图，例如：选择、删除蒙层等)
@property (nonatomic, copy, nullable)void (^extraAddUIElementsOnCellBlock)(TMCardComponentBaseListView *cardsCollectionView, UICollectionViewCell *cell, NSIndexPath *indexPath, NSObject<TMCardComponentCellDataBasicProtocol> *data);

#pragma mark - 自定义样式的卡片相关处理回调

/**若有customStyle样式的数据时，则外部需要在reloadData操作前主动调用来提前注册自定义的cell*/
- (void)registCustomCells:(void(^)(UICollectionView *collectionView))registCustomCellBlock;

/**当碰到customStyle样式的数据时，会触发获取外部指定的cell重用的identifier值*/
@property (nonatomic, copy, nullable)NSString *(^customCellIdentifierBlock)(TMCardComponentBaseListView *cardsCollectionView, NSIndexPath *indexPath, NSObject<TMCardComponentCellDataBasicProtocol> *data);

/**若customStyle样式的cell不遵循TMCardComponentCellProtocol协议则会触发此回调由外部对cell进行相关内容的赋值更新*/
@property (nonatomic, copy, nullable)void (^fillCustomCellBlock)(TMCardComponentBaseListView *cardsCollectionView, UICollectionViewCell *cell, NSIndexPath *indexPath, NSObject<TMCardComponentCellDataBasicProtocol> *data);

#pragma mark - section heder & footer configs block
/**获取指定索引下的section的Insets回调
 @note 若不赋值实现，则内部默认为cardsCollectionLayout设置固定值
 */
@property (nonatomic, copy, nullable)UIEdgeInsets (^InsetsOfSectionsBlock)(TMCardComponentBaseListView *cardsCollectionView, NSInteger section);

/**获取指定索引下的section的header视图的高度回调
 @note 若不赋值实现，则内部默认为返回0的高度
 */
@property (nonatomic, copy, nullable)CGFloat (^sectionHeaderHeightBlock)(TMCardComponentBaseListView *cardsCollectionView, NSInteger section);

/**获取指定索引下的section的footer视图的高度回调
@note 若不赋值实现，则内部默认为返回0的高度
*/
@property (nonatomic, copy, nullable)CGFloat (^sectionFooterHeightBlock)(TMCardComponentBaseListView *carsCollectionView, NSInteger section);

/**自定义指定索引下的section的header视图
@note 若不赋值实现，则内部默认为返回一个 UICollectionReusableView 类型的对象
*/
@property (nonatomic, copy, nullable)void (^sectionHeaderViewBlock)(TMCardComponentBaseListView *cardsCollectionView, NSInteger section, UICollectionReusableView *view);

/**自定义指定索引下的section的footer视图
@note 若不赋值实现，则内部默认为返回一个 UICollectionReusableView 类型的对象
*/
@property (nonatomic, copy, nullable)void (^sectionFooterViewBlock)(TMCardComponentBaseListView *cardsCollectionView, NSInteger section, UICollectionReusableView *view);

/**获取指定索引下的section的footer视图的高度回调
@note 若不赋值实现，则内部默认为返回layout.minimumInteritemSpacing的高度
*/
@property (nonatomic, copy, nullable)CGFloat (^minimumInteritemSpacingBlock)(TMCardComponentBaseListView *carsCollectionView, NSInteger section);
#pragma mark - 暴光、点击埋点相关数据获取的回调

/** 获取指定indexPath下的cell对应的widgetUid
 @note 若不实现或返回nil则表示不需要暴光点击相关埋点处理
 */
@property (nonatomic, copy, nullable)NSString * _Nullable(^cellWidgetUidBlock)(TMCardComponentBaseListView *cardsCollectionView, NSIndexPath *indexPath, NSObject<TMCardComponentCellDataBasicProtocol> * data);

/** 获取指定indexPath下的cell对应的上报的数据字典(pageUid默认天眼会自动采集)
@note 若不实现或返回nil则表示不需要暴光点击相关埋点处理
*/
@property (nonatomic, copy, nullable)NSDictionary * _Nullable(^cellReportDataBlock)(TMCardComponentBaseListView *cardsCollectionView, NSIndexPath *indexPath, NSObject<TMCardComponentCellDataBasicProtocol> * data);


#pragma mark - 构建cell 、style相关映射关系的字典

/**返回当前版本支持的所有卡片cell对应的重用identifier列表*/
+ (NSArray<TMBasicCardCellIdentifier *> *)allCellIdentifiers;

/**返回指定identifier串对应的卡片cell的class*/
+ (Class)cellClassOfCellIdentifier:(TMBasicCardCellIdentifier *)identifier;

/**当style为custom时返回nil*/
+ (TMBasicCardCellIdentifier *_Nullable)cellIdentifierOfCellStyle:(TMCardComponentCellStyle)style;

@end

NS_ASSUME_NONNULL_END
