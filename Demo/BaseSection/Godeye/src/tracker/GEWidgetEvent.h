//
//  GEWidgetEvent.h
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/27.
//

#import <Foundation/Foundation.h>

@class GEWidgetResource;

typedef void(^GEWidgetWillExposeBlock)( UIView *view, GEWidgetResource *resource);

@interface GEWidgetResource : NSObject

/**
 传入要埋点的UIView，内部会自动取相关属性
 */
+ (instancetype)resourceWithWidget:(UIView *)widget;

+ (instancetype)resourceWithExposeScrollView:(UIScrollView *)widget atIndexPath:(NSIndexPath *)indexPath;

// 主要针对曝光事件, 有些情况下上报曝光的时候widget尚未被添加到父试图上, 此时需要告知父视图superWidget
// 典型的情况是UITableview和UICollectionView的CellForRow方法中Cell一开始是没有父视图的
+ (instancetype)resourceWithCellWidget:(UIView *)widget tableWidget:(UIView *)tableWidget indexPath:(NSIndexPath *)indexPath;

/**
 非自定义事件，这个值是必须要传的，也可以通过addObject:forKey或addEntries:添加"widget_uid"属性
 */
@property (nonatomic, copy)     NSString    *geWidgetUid;

/**
 页面来源
 */
@property (nonatomic, copy)     NSString    *gePageReferUid;

/**
 添加一个属性
 */
- (void)addObject:(id)object forKey:(NSString *)key;

/**
 添加多个属性
 */
- (void)addEntries:(NSDictionary *)dict;

/**
 移除属性，可移除内容部自动添加的某些属性值，比如UIButton会自动设置widget_title属性，如果埋点不需要这个属性，则可通过这个方法移除"widget_title"
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 获取内部自动生成的属性，正常情况下是不需要取这些内容的，但是一些特殊情况，比如互动组件需要传入埋点数据，可以需要通过这个方法拿到属性
 */
- (NSDictionary *)geResource;

@end

@interface GEWidgetEvent : NSObject

/**
 建议使用这个方法来埋点，它可以使View和业务逻辑解耦
 */
+ (instancetype)eventWithResource:(GEWidgetResource *)resource;

@property (nonatomic, strong, readonly) GEWidgetResource *resource;

/**
 不建议使用以下的eventWithWidget:方法
 */
+ (instancetype)eventWithWidget:(UIView *)widget;
+ (instancetype)eventWithWidget:(UIView *)widget indexPath:(NSIndexPath *)indexPath;

// 主要针对曝光事件, 有些情况下上报曝光的时候widget尚未被添加到父试图上, 此时需要告知父视图superWidget
// 典型的情况是UITableview和UICollectionView的CellForRow方法中Cell一开始是没有父视图的
+ (instancetype)eventWithWidget:(UIView *)widget superWidget:(UIView *)superWidget;
+ (instancetype)eventWithWidget:(UIView *)widget superWidget:(UIView *)superWidget indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy)     NSString *widgetHref;
@property (nonatomic, copy)     NSString *widgetUid;
@property (nonatomic, copy)     NSString *widgetClass;
@property (nonatomic, strong)   NSIndexPath *indexPath;
@property (nonatomic, copy)     NSString *pageUid;
@property (nonatomic, copy)     NSString *title;
@property (nonatomic, copy)     NSString *subTitle;
@property (nonatomic, copy)     NSString *widgetSrc;
@property (nonatomic, strong)   NSDictionary *geResource;
@property (nonatomic, copy)     NSString    *gePageReferUid;//页面来源

@property (nonatomic, copy) void(^onReportFinish)(void);

- (NSDictionary *)dictionaryValue;

- (void)report NS_REQUIRES_SUPER;

@end


@interface GEWidgetClickEvent : GEWidgetEvent

@end;



@interface GEWidgetExposeEvent : GEWidgetEvent

/**
 注册tableview/collectionView的曝光
 */
- (void)regist;

/**
 拦截曝光，如果实现了它，内部不自动上报
 */
@property (nonatomic, copy) GEWidgetWillExposeBlock willExposeBlock;

@end

@interface GEWidgetCustomEvent : GEWidgetEvent

+ (instancetype)eventWithResource:(GEWidgetResource *)resource eventName:(NSString *)eventName;

@end
