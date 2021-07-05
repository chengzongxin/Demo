//
//  TMCardComponentDataInfoObjects.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAttributedString+THKTextTagLabel.h"

#define TMCardComponentDataInfoObjectPropertyReadWrite readwrite
//#define TMCardComponentDataInfoObjectPropertyReadWrite readonly

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMCardComponentDataCoverSubIconPosition) {
    TMCardComponentDataCoverSubIconPositionTopRight = 0, ///< 右上角
    TMCardComponentDataCoverSubIconPositionTopLeft = 1,  ///< 左上角
    TMCardComponentDataCoverSubIconPositionBottomRight = 2, ///< 右下角
    TMCardComponentDataCoverSubIconPositionBottomLeft = 3, ///< 左下角
    TMCardComponentDataCoverSubIconPositionCenter = 4,      ///< 居中位置
};

 /// !!!: 按定义的数据结构将相关返回数据拆分成更小的对象集合
 
/**显示在封面上的类型icon数据对象*/
@interface TMCardComponentDataCoverSubIcon : NSObject
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)TMCardComponentDataCoverSubIconPosition position;///< icon显示的相对位置, 四个角位置的icon位置对应图片视图边距的依赖依赖约束位置不同约束不同，但相对对应的边距均为8pt,此边距统一逻辑不允许外部修改
/**
 本地资源icon的资源名，若此有值则优先取本地资源展示
 @warning 本地数据由本地逻辑控制赋值，同时对应的资源显示icon视图的width \ height也需要设置对应值
 */
@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *localImgName;
@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *imgUrl;///< icon的链接
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)NSInteger width;///< icon宽,图片真实宽，展示时会按 width/3 缩放后展示. 真实展示时用 layout_width的值
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)NSInteger height;///< icon高，图片真实高，展示时会按 height/3 缩放后展示。 真实展示时用 layout_height的值
@property (nonatomic, assign, readonly)NSInteger layout_width;///< icon视图显示效果的真实宽, width/3 缩放后的宽
@property (nonatomic, assign, readonly)NSInteger layout_height;///< icon视图显示效果的真实高， height/3 缩放后的高

@end

/**显示封面图内容上的相关数据*/
@interface TMCardComponentDataCoverInfo : NSObject
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)BOOL isFreeCoverSizeLimit;///< 8.10 add | 表示在通用逻辑处理封面的显示size时，是否放开有效宽高比值范围的限制，默认NO-表示按原有逻辑处理，即按设计要求会给出一个封面图显示的宽高比值范围作限定；若此值设置为YES，表示在处理决定封面图的显示尺寸时完全按照接口返回的width、height的真实比例做等比缩放。
@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *imgUrl;///< 封面图
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)NSInteger width;///< 封面宽
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)NSInteger height;///< 封面高
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *title;///< 标题
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *subTitle;///< 副标题
@property (nonatomic, strong, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSArray<NSString *> *imgs;///< 头像列表
@property (nonatomic, strong, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSArray<NSString *> *contents;///< 回答内容列表，当为问答类型时可能有值 |  version 8.6 add
@property (nonatomic, strong, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSArray<TMCardComponentDataCoverSubIcon *> *subIcons;///< 封面上四个角或中心位置的装饰Icon视图
@end

/**显示在底部，头像、认证icon、标题的相关数据*/
@interface TMCardComponentDataBottomInfo : NSObject
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *imgUrl;///< 头像
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *subIcon;///< 认证icon
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *title;///< 底部标题，即昵称
@end

@class TMCardComponentDataContentTextTag;

/**真实类型的业务内容数据*/
@interface TMCardComponentDataContentInfo : NSObject
@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *Id;///< 具体内容的referId
@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *type;///< 具体内容的bizType
@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *router;///< 点击跳转的路由链接串
@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *expenseNo;///< 扣费标识
@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *collectSource;///< 内容来源
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)NSInteger adId;///< 运营广告id
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)NSInteger liveIn;///< 直播状态，1：直播中，3：回放
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)NSInteger auditStatus;///< 内容状态，2：审核不通过，3：不存在

/// 8.8 add
@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *cityName; ///城市名称，用于直播列表页卡片中图标底部显示城市名称
@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)NSInteger redTag;///直播列表页卡片中右上角是否显示红包图标

///8.8 add, 推荐的视频列表中，卡片标题上方额外显示的当前内容的推荐来源信息| collectSourceName有值则显示，collectSourceIcon为可选显示
///8.11 modify UI样式调整，去除原额外增加的UI展示元素，换作封面图上接口返回的角标icon展示即可，但collectSourceName字段值保留，原版本相关埋点处理逻辑需要此值作为widget_tag，且原埋点处理逻辑保持不变，仅调整统一相关UI即可
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *collectSourceName;///< 内容被推荐显示的来源名-显示串：ep. 我关注的、xxx赞了、最常访问等

///内容被推荐显示的来源-显示icon,与设计定义的collectSourceName一一对应显示的Icon，若无值不显示icon
///@warning 8.11 modify 因UI调整，此返回属性值已经废弃
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *collectSourceIcon __deprecated_msg("v8.11 UI调整，此属性值已废弃使用,暂保留字段字义，后续版本会进行清理删除");


@property (nonatomic, copy, TMCardComponentDataInfoObjectPropertyReadWrite)NSString * collectId;///< 灵感集收藏Id

@property (nonatomic, strong, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)TMCardComponentDataContentTextTag *textTag;///< 8.11 add| 在title文本串前面显示的标签串.⚠️：当cover.title为空串时若有此标签串也不会显示

@end

/** 显示在title前面的标签串对象 */
@interface TMCardComponentDataContentTextTag: NSObject
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *tag;///< 标签串文本
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *foregroundColor;///< 标签串文本显示的字颜色16进制串，若无值时，显示时UI应该给一个默认色显示
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *backgroundColor;///< 标签串文本显示的区域块背景色16进制串，若无值时，显示时UI应该给定一个默认色显示
@end

@class TMCardComponentDataInsertRecommendTagModel;
///8.9 add, 通用的推荐标签样式卡片需要的数据，由于之前首页信息流及搜索相关列表页已有接口定义的相关结构，所以这里将之前的结构提取到此处即可，相关新接口按原结构传值即可
@interface  TMCardComponentDataInsertRecommendTagsInfo : NSObject

@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *title;///< 标签卡片放大镜icon后面跟着的title串，若相关UI会显示默认的值
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *imgUrl;///< 标签卡片背景底图，暂无用，原旧版需要显示，故这里暂保留原字段的字义
/**标签项数据列表，对应key "guideWordVos" ,接口必须返回4个,多于4个显示时也最多处理前4个*/
@property (nonatomic, strong, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSArray<TMCardComponentDataInsertRecommendTagModel *> *guideWords;

@end

@interface TMCardComponentDataInsertRecommendTagModel : NSObject
@property (nonatomic, copy)NSString *content;///< 标签名描述文本串
@property (nonatomic, copy)NSString *imageUrl;///< 标签项目对应展示的图片url串
@property (nonatomic, copy)NSString *targetUrl;///< 点击了标签项视图后足协对应的路由串
@end

typedef NS_ENUM(NSInteger, TMCardComponentDataInteractionInfoType) {
    TMCardComponentDataInteractionInfoTypeNormal = 0, ///< 通用类型，无点击交互，仅显示text串
    TMCardComponentDataInteractionInfoTypePraise = 1, ///< 点赞操作交互类型
    TMCardComponentDataInteractionInfoTypeCollect = 2, ///< 收藏操作交互类型
    TMCardComponentDataInteractionInfoTypeComment = 3, ///< 评论类型，不响应点击交互，仅显示评论数据text串
    TMCardComponentDataInteractionInfoTypeWatch   = 4, ///< 观看数类型，在text文本左侧显示一个头像icon，无点击交互
};


/**底部右下角相关的互动数据*/
@interface TMCardComponentDataInteractionInfo : NSObject
@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *moduleCode;///< 具体交互时接口需要的值

@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)TMCardComponentDataInteractionInfoType type;///< 交互类型

@property (nonatomic, copy, nullable, TMCardComponentDataInfoObjectPropertyReadWrite)NSString *text;///< 显示的串，当互动类型时对应的互动数字超过999，比如当num为1000时，此text值可能会返回 "999+"的样式，所以建议互动数据还是直接取下面的num数字作判断

@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)NSInteger num;///< 若为点赞等互动操作类型，则为具体的互动真实数字

@property (nonatomic, assign, TMCardComponentDataInfoObjectPropertyReadWrite)BOOL status;///< 若为相关交互操作则对应相关交互操作的状态值，比如：是否已经点赞，是否已收藏

@end


#pragma mark - 8.8 增加特殊情况下，可能会指定某卡片cell在暴光、点击事件上报(需要单独主动调用接口执行上报)
///MARK: 以下增加的对象字段支持的是单独的接口调用，非天眼的相关上报
///MARK: 以下子对象暂时用在本地相关处理逻辑，暂不支持相关数据完全依赖接口返回的数据结构，计划是后续接口支持

typedef NS_OPTIONS(NSUInteger, TMCardComponentDataReportActions) {
    TMCardComponentDataReportActionsNone    = 0,        ///< 不需要执行相关上报
    TMCardComponentDataReportActionsExpose  = 1 << 0,   ///< 需要执行暴光上报
    TMCardComponentDataReportActionsClick   = 1 << 1,   ///< 需要执行点击上报
};

@interface TMCardComponentDataReportConfig : NSObject

/** 是否已调用过暴光接口的标记。需要单独调用接口进行暴光。默认为NO
 @note 此为本地标记值字段
 */
@property (nonatomic, assign)BOOL exposeFlag;

/** 上报动作*/
@property (nonatomic, assign)TMCardComponentDataReportActions reportActions;

/**执行暴光上报的接口*/
@property (nonatomic, copy)NSString *exposeReportUrl;

/**执行点击上报的接口*/
@property (nonatomic, copy)NSString *clickReportUrl;

/** 需要上报的业务数据，直播透传即可 */
@property (nonatomic, strong)NSDictionary *reportData;

//默认都是java接口、post请求
//@property (nonatomic, assign)BOOL isJavaApi;
//@property (nonatomic, assign)BOOL isPostMehtod;

@end

NS_ASSUME_NONNULL_END
