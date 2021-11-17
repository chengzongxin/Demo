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

@interface THKDynamicTabsViewModel : THKViewModel

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

- (instancetype)initWithWholeCode:(NSString *)wholeCode defualtTabs:(NSArray<THKDynamicTabsModel *> *)tabs;
- (instancetype)initWithWholeCode:(NSString *)wholeCode extraParam:(NSDictionary *)extraParam defualtTabs:(NSArray<THKDynamicTabsModel *> *)tabs;

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
