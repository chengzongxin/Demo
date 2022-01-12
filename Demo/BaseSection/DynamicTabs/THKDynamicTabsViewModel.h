//
//  THKDynamicTabsViewModel.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/7/10.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKViewModel.h"
#import "THKDynamicTabsRequest.h"
#import "THKTabBadgeRequest.h"
#import "THKDynamicTabsProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKDynamicTabsLayoutType_Custom = 0,    ///<自定义，需要外部手动布局
    THKDynamicTabsLayoutType_Normal,        ///<常规布局
    THKDynamicTabsLayoutType_Suspend,       ///<包含头部、Tab、吸顶效果布局
} THKDynamicTabsLayoutType;

typedef enum : NSUInteger {
    THKDynamicTabsLoadType_API = 0,    ///< 通过调接口传wholecode加载tab
    THKDynamicTabsLoadType_Data,        ///<通过塞VCs和Titles加载tab
    THKDynamicTabsLoadType_Model,         ///<通过THKDynamicTabModel加载tab
} THKDynamicTabsLoadType;

@interface THKDynamicTabsViewModel : THKViewModel
/// 是否有头部悬浮效果，默认NO，设计到内部容器wrapper是scrollView还是View
@property (nonatomic, assign) THKDynamicTabsLayoutType layout;
/// 加载数据方式
@property (nonatomic, assign, readonly) THKDynamicTabsLoadType loadType;
/// 头部视图
@property (nonatomic, strong) UIView *headerContentView;
/// 头部视图高度
@property (nonatomic, assign) CGFloat headerContentViewHeight;
/// 锁定高度
@property (nonatomic, assign) CGFloat lockArea;
/// tab标签高度,默认44
@property (nonatomic, assign) CGFloat sliderBarHeight;
/// 非pageContent内容的高度
@property (nonatomic, assign) CGFloat cutOutHeight;
/// 当前VC，用于管理子VC生命周期
@property (nonatomic, weak) UIViewController *parentVC;
/// 是否需要下拉刷新
@property (nonatomic, assign) BOOL isEnableRefresh;
/// 刷新头部高度，默认在顶端
@property (nonatomic, assign) CGFloat refreshHeaderInset;
/// 是否开启无限滚动（嵌套Tab组件才需要开启）
@property (nonatomic, assign) BOOL isEnableInfiniteScroll;

+ (instancetype)new NS_UNAVAILABLE;
//- (instancetype)init NS_UNAVAILABLE;

/// 使用下面的方法初始化，会调用接口创建VC
- (instancetype)initWithWholeCode:(NSString *)wholeCode defualtTabs:(NSArray<THKDynamicTabsModel *> *)tabs;
- (instancetype)initWithWholeCode:(NSString *)wholeCode extraParam:(nullable NSDictionary *)extraParam defualtTabs:(NSArray<THKDynamicTabsModel *> *)tabs NS_DESIGNATED_INITIALIZER;
/// 使用静态VC，需要外部提供数据源
- (instancetype)initWithVCs:(NSArray<UIViewController *> *)childVCs titles:(NSArray<NSString *> *)childTitles NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithTabs:(NSArray<THKDynamicTabsModel *> *)tabs NS_DESIGNATED_INITIALIZER;
/// 没有通过指定方法创建（使用init），后期手动塞入数据源调用下面方法
- (void)setVCs:(NSArray<UIViewController *> *)childVCs titles:(NSArray<NSString *> *)childTitles;
- (void)setTabs:(NSArray<THKDynamicTabsModel *> *)tabs;

/**
 获取标签tab接口结果
 */
@property (nonatomic, strong, readonly)     RACSubject  *tabsResultSubject;

/**
 当sliderBar发生变化时发出该信号
 */
@property (nonatomic, strong, readonly)     RACSubject  *segmentValueChangedSubject;

/**
 Tab加载出来后的Signal
 */
@property (nonatomic, strong, readonly)     RACSubject *tabsLoadFinishSignal;

/**
 后台返回的tabs数据
 */
@property (nonatomic, copy, readonly)       NSArray<THKDynamicTabsModel *>      *segmentTabs;


/**
 用于segment的标题数据，如果获取数据失败，则要给一个默认的值
 */
@property (nonatomic, copy, readonly)       NSArray<NSString *>      *segmentTitles;

/**
 根据THKDynamicTabsModel.targetUrl可以找到对应的vc，所以把这些vc都保存到这个数组中
 */
@property (nonatomic, copy, readonly)       NSArray<UIViewController *>    *arrayChildVC;

/**
 后台返回的默认选中项，该值为只读
 */
@property (nonatomic, assign, readonly)     NSInteger         sliderBarDefaultSelected;

/**
 记录是否请求成功。如果失败的话则需要重新请求
 */
@property (nonatomic, assign, readonly)     BOOL                isRequestSuccess;


- (void)loadTabs;
/**
 请求tab的数据接口，请求返回后发出tabsResultSubject信号
 这个接口需要传入默认的tabs，如果获取数据失败则解析默认的tab并回传，所以这个接口不存在返回错误的情况，但有可能返回空数组
 */
- (void)requestConfigTabs;

/**
 所有的红点请求都走这个接口，根据type来做区分
 */
- (void)requestBadgeWithType:(THKTabBadgeType)type successBlock:(T8TObjBlock)successBlock failBlock:(T8TObjBlock)failBlock;

/**
 消除所有红点的请求都走这个接口，根据type来做区分
 */
- (void)requestClearBadgeWithType:(THKTabBadgeType)type successBlock:(T8TObjBlock)successBlock failBlock:(T8TObjBlock)failBlock;

- (void)parseTabs:(NSArray<THKDynamicTabsModel *> *)tabs;

#pragma mark - 8.8 增加一些功能性辅助用到的其它配置属性项及接口

/**
 外部实现这个回调来设值每个按钮的字体颜色和选中状态等信息
 */
@property (nonatomic, copy, nullable) void(^configDynamicTabButtonModelBlock)(THKDynamicTabDisplayModel *configButtonModel, NSInteger tabId, NSString *title);
@property (nonatomic, copy, nullable) void(^dynamicTabsModelViewControllerBlock)(UIViewController *vc, THKDynamicTabsModel *tabsModel);

@end

NS_ASSUME_NONNULL_END
