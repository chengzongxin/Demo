//
//  TDecDetailFirstModel.h
//  HouseKeeper
//
//  Created by cl w on 2019/7/31.
//  Copyright © 2019年 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 videoList    object []
 必须
 视频列表
 item 类型: object
 
 imgUrl    string
 必须
 视频封面图
 videoUrl    string
 必须
 视频连接
 bannerList    string []
 必须
 图片列表
 item 类型: string
 
 非必须
 图片链接
 备注: 图片链接
 
 companyId    integer
 必须
 公司id
 companyName    string
 必须
 公司名称
 companyLogo    string
 必须
 公司logo
 designLevel    number
 必须
 设计评分（满分5.0）
 constructLevel    number
 必须
 施工评分（满分5.0）
 serviceLevel    number
 必须
 服务评分（满分5.0）
 evaluationNum    integer
 必须
 评价数
 evaluationLevel    number
 必须
 评价星级
 labelList    object []
 必须
 标签列表
 item 类型: object
 
 tabTitle    string
 必须
 标签名称
 tabColour    string
 必须
 标签颜色
 borderColour    string
 必须
 边框颜色
 tabUrl    string
 必须
 标签链接
 ranking    object
 必须
 榜单
 备注: 榜单
 
 rankingId    integer
 必须
 榜单id
 rankingName    string
 必须
 榜单名称及名次
 rankingUrl    string
 必须
 榜单链接
 rankLabelColor    string
 必须
 榜单标签颜色
 rankBackgroundColor    string
 必须
 榜单标签背景颜色
 orderNum    integer
 必须
 签约数
 appointmentNum    integer
 必须
 预约数
 caseNum    integer
 必须
 案例数
 diaryNum    integer
 必须
 日记数
 designerNum    integer
 必须
 设计师数
 address    string
 必须
 详细地址
 longitude    number
 必须
 经度
 latitude    number
 必须
 纬度
 axnPhone    string
 必须
 电话号码
 calledSituation    string
 必须
 电话咨询情况（整个文案）
 birthDate    integer
 必须
 公司成立日期
 qualityNum    integer
 必须
 资质数目
 bizServiceList    object []
 必须
 商户服务列表
 item 类型: object
 
 title    string
 必须
 标题
 content    string
 必须
 内容
 phoneStaffId    integer
 必须
 客服ID
 cooperationType    integer
 必须
 合作状态（0无合作，1店铺宝合作，2派单合作，3店铺宝+派单合作）
 **/

typedef struct TDecActivityRemaingTime {
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
} TDecActivityRemaingTime;

@interface TDecDetailVideoModel : NSObject

@property (nonatomic, strong) NSString *imgUrl,*videoUrl;

@property (nonatomic, assign) NSInteger vid,pid;

@property (nonatomic, assign) BOOL exposeFlag;

@property (nonatomic, strong) NSDictionary *reportDic;

@property (nonatomic, assign) BOOL isPortraitVideo;//竖屏视频

@end

@interface TDecDetailRankingModel : NSObject

@property (nonatomic, strong) NSString *rankingName,*rankingUrl,*rankLabelColor,*rankBackgroundColor;
@property (nonatomic, assign) NSInteger rankingId;

@end

@interface TDecDetailLabelModel : NSObject

@property (nonatomic, strong) NSString *tabTitle,*tabColour,*borderColour,*tabUrl,*tabImage;

@end

@interface TDecDetailBizModel : NSObject

@property (nonatomic, strong) NSString *title,*content,*priceText;

@property (nonatomic, assign) NSInteger activitySubType,exposeFlag;

@end

@interface TDecLiveModel : NSObject

@property (nonatomic, copy) NSString *title,*liveCover,*liveClass;

@property (nonatomic, assign) NSInteger liveId,status,viewers,beginTime;//直播状态  1|直播中 0|已停止;2|正在创建直播;3|历史数据

@property (nonatomic, strong) NSString *targetUrl;

@property (nonatomic, strong) NSArray <NSDictionary *>*goodsList;

- (NSArray *)goodsImgs;

- (NSArray *)goodsPrices;

@end

@interface THKAppointEntranceVO : NSObject

/*
 appointEntranceVO    object
 必须
 预约入口
 备注: 预约入口

 hasPhone    boolean
 必须
 是否能电话咨询
 hasRegister    boolean
 必须
 是否能登记预约
 hasIM    boolean
 必须
 是否能IM咨询
 hasIntention    boolean
 必须
 是否有“我要装修”
 needRemind    boolean
 必须
 是否弹框再次确认提醒
 */
@property (nonatomic, assign) BOOL hasPhone,hasRegister,hasIM,hasIntention,needRemind;

@property (nonatomic, assign, readonly) NSInteger toolBarStyle;//toolBar的样式 参考：TDecDetailToolBarStyle

@property (nonatomic, strong) NSString *intentionUrl;

- (BOOL)showToolBar;

@end

@interface TDecDetailActivityConfig : NSObject

@property (nonatomic, strong) NSString *activityName,*activityUrl,*imgUrl,*updateUserStr,*fileName;
@property (nonatomic, assign) NSInteger createTime,createUser,endTime,activityId,positionType,rangeType,serverTime,showTime,startTime,updateTime,updateUser;//positionType 1顶部 2中部

- (TDecActivityRemaingTime)midAdRemainTime;

- (BOOL)hasStarted;

@end

@interface TDecDetailFirstModel : NSObject

@property (nonatomic, strong) NSArray <TDecDetailVideoModel *> *videoList,*bannerList;
@property (nonatomic, strong) NSArray <NSString *> *basicData;
//0 | 未合作 1| 合作店铺宝基础版 2 | 合作店铺宝付费版 3 | 合作了其他业务（如 图满意、派单）
@property (nonatomic, assign) NSInteger companyId,evaluationNum,orderNum,appointmentNum,caseNum,
                                        diaryNum,designerNum,phoneStaffId,isCollected,
                                        authStatus,qualityNum,birthDate,specialServiceNum,shopTreasureStatus,subBusinessCooperationStatus,actualVideoSize;//subBusinessCooperationStatus 0 | 未合作 1 | 店铺宝基础版 2| 店铺宝付费版
@property (nonatomic, strong) NSArray <TDecDetailRankingModel *> *rankingList;
@property (nonatomic, strong) NSArray <TDecDetailLabelModel *>*labelList,*brandLabel;
@property (nonatomic, strong) NSArray <TDecDetailBizModel *>*bizServiceList;
@property (nonatomic, strong) NSString *decShortName,*companyName,*companyLogo,*address,*axnPhone,*calledSituation,
*h5IndexUrl,*womScore;
@property (nonatomic, strong) NSNumber *designLevel,*constructLevel,*serviceLevel,*longitude,*latitude,
                                        *evaluationLevel;
@property (nonatomic, strong) NSArray <TDecLiveModel *> *companyLiveList;//直播

@property (nonatomic, strong) THKAppointEntranceVO *appointEntranceVO;

@property (nonatomic, strong) NSArray <TDecDetailActivityConfig *> *activities;

@property (nonatomic, assign) NSInteger axnPhoneExposeFlag;

///分享用到的type
@property (nonatomic, assign) NSInteger typeForShare;

- (TDecDetailActivityConfig *)topAd;

- (TDecDetailActivityConfig *)midAd;

@end
