//
//  THKDynamicTabsModel.h
//  HouseKeeper
//
//  Created by amby.qin on 2020/7/10.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *DynamicTabsWholeCodeString;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, THKDynamicTabTargetType) {
    THKDynamicTabTargetType_H5 = 1,
    THKDynamicTabTargetType_Origin,
    THKDynamicTabTargetType_Content
};

typedef NS_ENUM(NSInteger, THKDynamicConfigOriginType) {
    THKDynamicConfigOriginType_EffectImage=3,//效果图
    THKDynamicConfigOriginType_Video = 5,// 视频
    THKDynamicConfigOriginType_Guide,//经验（原攻略）
    THKDynamicConfigOriginType_Topic=8,//话题
    THKDynamicConfigOriginType_Diary=10,//日记
    THKDynamicConfigOriginType_Case,//案例
    THKDynamicConfigOriginType_Live,//直播
    THKDynamicConfigOriginType_HomePage,//首页
    THKDynamicConfigOriginType_CommunityHot,//社区-热门
    THKDynamicConfigOriginType_CommunityFollow,//社区-关注
    THKDynamicConfigOriginType_3DRoaming,//3D设计
};

typedef NS_ENUM(NSInteger, THKDynamicTabButtonStyle) {
    THKDynamicTabButtonStyle_TextOnly,
    THKDynamicTabButtonStyle_TextAndImage,
    THKDynamicTabButtonStyle_ImageOnly
};

UIKIT_EXTERN DynamicTabsWholeCodeString const kDynamicTabsWholeCodeHomePage; //首页
UIKIT_EXTERN DynamicTabsWholeCodeString const kDynamicTabsWholeCodeCaseList; //案例列表
UIKIT_EXTERN DynamicTabsWholeCodeString const kDynamicTabsWholeCodeVedioList; //视频列表
UIKIT_EXTERN DynamicTabsWholeCodeString const kDynamicTabsWholeCodeCommunity; //社区
UIKIT_EXTERN DynamicTabsWholeCodeString const kDynamicTabsWholeCodeMinePage; //我的
UIKIT_EXTERN DynamicTabsWholeCodeString const kDynamicTabsWholeCodeLivePage; //直播
UIKIT_EXTERN DynamicTabsWholeCodeString const kDynamicTabsWholeCodeCompanyDetail; //装企详情页
UIKIT_EXTERN DynamicTabsWholeCodeString const kDynamicTabsWholeCodeLocalDiaryChannel;//日记频道

@interface THKDynamicTabsHomeImageModel : NSObject

@property (nonatomic, copy)     NSString *url ;//图片链接
@property (nonatomic, assign)   CGFloat width;//图片宽
@property (nonatomic, assign)   CGFloat height;//图片高

@end

@interface THKDynamicTabDisplayModel : NSObject

@property (nonatomic, strong)     UIColor   *normalColor; //正常状态下的文字颜色
@property (nonatomic, strong)     UIColor   *selectedColor; //选中状态下的文字颜色
@property (nonatomic, strong)     UIFont    *normalFont; //正常字体
@property (nonatomic, strong)     UIFont    *selectedFont; //选中时的字体

@property (nonatomic, strong)     UIColor   *badgeImageColor; //右上角角标：小红点
@property (nonatomic, assign)     CGFloat   scale; // 按钮的放大系数，如果设置了该值，则按钮(文字+图片)整体做缩放

@property (nonatomic, assign)     BOOL    showBadge;

@end

@interface THKDynamicTabsModel : NSObject

@property (nonatomic, assign)   NSInteger tabId;//标签ID
@property (nonatomic, assign)   NSInteger position; //标签位置
@property (nonatomic, copy)     NSString *title ;//标签名称
@property (nonatomic, assign)   NSInteger targetType;//标签打开类型，1-H5，2-原生，3-内容
@property (nonatomic, copy)     NSString *targetUrl ;//标签跳转链接
@property (nonatomic, assign)   NSInteger origin;//标签内容来源
@property (nonatomic, assign)   NSInteger userGroup;//number 用户分群id，0-全量用户
@property (nonatomic, assign)   THKDynamicTabButtonStyle style;//0:纯文本/1:图文/2:纯图
@property (nonatomic, assign)   BOOL selected;//是否为默认的选项

@property (nonatomic, strong)   THKDynamicTabsHomeImageModel *image;

@property (nonatomic, strong)   THKDynamicTabDisplayModel *displayModel;

@property (nonatomic, assign)   BOOL isExpose;//是否已曝光

@end


NS_ASSUME_NONNULL_END
