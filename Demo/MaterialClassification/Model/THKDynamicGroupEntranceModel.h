//
//  THKDynamicGroupEntranceModel.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/7/10.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TMyHomeGroupNumType_Platform1 = 4,  //平台服务1
    TMyHomeGroupNumType_Platform2 = 5,  //平台服务2
    TMyHomeGroupNumType_User = 6,       //用户相关
    TMyHomeGroupNumType_Banner = 7,     //banner
} TMyHomeGroupNumType;

@interface THKDynamicGroupEntranceModel : NSObject

@property (nonatomic, assign)   NSInteger   groupId;//标签ID
@property (nonatomic, assign)   NSInteger   position; //标签位置
@property (nonatomic, assign)   NSInteger   groupNum; //入口组别
@property (nonatomic, copy)     NSString    *groupName ;//组别名称
@property (nonatomic, copy)     NSString    *title ;//标签名称
@property (nonatomic, assign)   NSInteger   targetType;//标签打开类型，1-H5，2-原生，3-内容
@property (nonatomic, copy)     NSString    *targetUrl ;//标签跳转链接
@property (nonatomic, assign)   NSInteger   origin;//标签内容来源
@property (nonatomic, copy)     NSString    *imgUrl ;//入口图片url
@property (nonatomic, assign)   NSInteger   width;//入口图片宽度
@property (nonatomic, assign)   NSInteger   height;//入口图片高度
@property (nonatomic, assign)   BOOL        needLogin;// 是否需要登录
@property (nonatomic, copy)     NSString    *badgetUrl; // 右上角额外展示图片
@property (nonatomic, copy)     NSString    *reportType;//数据上报ad_type，oms配置的写死feed

@property (nonatomic, assign)   NSInteger userGroup;//number 用户分群id，0-全量用户

///内容 （暂时是装修精灵后面那段话）
@property (nonatomic, copy)     NSString    *content;//内容

//是否上报过曝光（本地添加，否后台返回）
@property (nonatomic, assign) BOOL geReported;

@end

@interface THKDynamicGroupEntranceData : NSObject

@property (nonatomic, assign)   NSInteger   groupNum; // 组别
@property (nonatomic, copy)     NSString    *groupName; // 组别名称

/// 样式名称
@property (nonatomic, assign)   NSInteger   style;//1-第一组，2-第二组，3-第三组，4-新人权益

@property (nonatomic, copy) NSArray<THKDynamicGroupEntranceModel *>  *entrances;

//本地使用，非后台返回
@property (nonatomic, strong) id data;

@end

NS_ASSUME_NONNULL_END
