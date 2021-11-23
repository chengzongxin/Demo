//
//  TRouterPathDefine.h
//  HouseKeeper
//
//  Created by 彭军 on 2019/5/15.
//  Copyright © 2019 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const TRouter_Scheme;//项目路由scheme定义
extern NSString * const TRouter_Host;//项目路由host定义
extern NSString * const TRouter_Build_Host;//项目路由Build host定义
//-------------v7.5.0---------------------
extern TRouterPath const THKRouterPage_AppMainTab;//首页Tab切换
extern TRouterPath const THKRouterPage_PrettyCaseChannel;//美图/方案/3D 频道聚合页
extern TRouterPath const THKRouterPage_StrategyDiaryAskVideoChannel;//攻略/日记/问答/视频 频道聚合页
extern TRouterPath const THKRouterPage_HousePlanDiagnosisList;//户型诊断列表
extern TRouterPath const THKRouterPage_HousePlanDiagnosisDetail;//户型诊断详情
extern TRouterPath const THKRouterPage_HousePlanPublish;//发布户型图
extern TRouterPath const THKRouterPage_DesignerList;//设计师大咖列表
extern TRouterPath const THKRouterPage_DesignerDetail;//设计师大咖详情
extern TRouterPath const THKRouterPage_CompanyList;//装修公司列表页
extern TRouterPath const THKRouterPage_CompanyDetail;//装修公司详情页
extern TRouterPath const THKRouterPage_MainSearch;//全局搜索页
extern TRouterPath const THKRouterPage_CaseDetail;// 案例详情（设计师/装企/3D）
extern TRouterPath const THKRouterPage_PrettyPicDetail;//效果图（美图）详情页/UGC图文
extern TRouterPath const THKRouterPage_UGCVideoDetail;//UGC/PGC视频详情页
extern TRouterPath const THKRouterPage_UGCArticleDetail;//UGC文章(达人说)
extern TRouterPath const THKRouterPage_AskDetail;//问答详情页
extern TRouterPath const THKRouterPage_StrategyDetail;//攻略详情页
extern TRouterPath const THKRouterPage_DiaryDetail;//日记详情页
extern TRouterPath const THKRouterPage_MyHomeMain;//我的家首页
extern TRouterPath const THKRouterPage_IndexPublish;//发布页面
extern TRouterPath const THKRouterPage_OldHomeMain;//旧版管工地
extern TRouterPath const THKRouterPage_NewDiaryDetail;//子日记详情页
extern TRouterPath const THKRouterPage_CompanyCaseList;//网店案例详情

//-------------v7.7.0---------------------
extern TRouterPath const THKRouterPage_IMChat;//IM聊天页面
extern TRouterPath const THKRouterPage_Relationship;//个人中心
extern TRouterPath const THKRouterPage_IntegralTask;//任务中心
extern TRouterPath const THKRouterPage_EditTransparent;//晒我家
extern TRouterPath const THKRouterPage_DiaryDispatch;//写日记
extern TRouterPath const THKRouterPage_DecorationDynamicState;//装修动态

//-------------v7.9.0---------------------
extern TRouterPath const THKRouterPage_VideoDetail;//新版视频详情页，具体参数数据与 /video/act 路由保持一致即可
extern TRouterPath const THKRouterPage_WalletBankCard;//银行卡列表页面


extern TRouterPath const THKRouterPage_Command;//口令
extern TRouterPath const THKRouterPage_InspirationDetail;//灵感集详情
extern TRouterPath const THKRouterPage_3DFullViewDetail;//3D全景图详情
extern TRouterPath const THKRouterPage_SearchResult;//搜索结果页
extern TRouterPath const THKRouterPage_CompanyDesignerDetail;//装修公司设计师详情

extern TRouterPath const THKRouterPage_ContractList;

//-------------v7.12.0---------------------
extern TRouterPath const THKRouterPage_MyWallet;//钱包页面

//-------------v7.13.0---------------------
extern TRouterPath const THKRouterPage_AllCommentList;//全部评论列表页面
extern TRouterPath const THKRouterPage_TopicMsgList;//话题消息页面
extern TRouterPath const THKRouterPage_TopicCommentWrite;//话题评论页面
extern TRouterPath const THKRouterPage_AdDetail;//广告页面
extern TRouterPath const THKRouterPage_AskChannelList;//问答分类列表
extern TRouterPath const THKRouterPage_AskAddAnswer;//添加回答页面
extern TRouterPath const THKRouterPage_ExpertChat;//专家服务页面

//-------------v8.0.0---------------------
extern TRouterPath const THKRouterPage_NewhomeQualityrecord;//质检报告页面
extern TRouterPath const THKRouterPage_CommunityTopicDetail;// 社区话题详情页

//-------------v8.1.0---------------------
extern TRouterPath const THKRouterPage_MyHomeAddComment;
extern TRouterPath const THKRouterPage_MyHomeCommentList;
extern TRouterPath const THKRouterPage_LiveList;

extern TRouterPath const THKRouterPage_MessageList;//消息列表页
extern TRouterPath const THKRouterPage_ShouYinTai;
extern TRouterPath const THKRouterPage_DecorationRaidersList; //装修攻略主页
extern TRouterPath const THKRouterPage_DecorationRaidersDetail NS_ENUM_DEPRECATED_IOS(8.10, 8.10, "版本开始已废弃，使用新版 THKRouterPage_NewDecorationRaidersDetail"); // 旧版装修攻略详情页，目前已废弃
extern TRouterPath const THKRouterPage_DesignerServiceEdit; // 设计师服务信息编辑
extern TRouterPath const THKRouterPage_DesignerServiceCheck;//服务信息查看页面


//-------------v8.2.0---------------------
extern TRouterPath const THKRouterPage_ProjectDetailBroadcast;
extern TRouterPath const THKRouterPage_MyWalletDetailOrder;

//extern TRouterPath const THKRouterPage_ProjectManagerMainView;

//-------------v8.3.0---------------------
extern TRouterPath const THKRouterPage_MyhomeContractDetail;

//-------------v8.4.0---------------------
extern TRouterPath const THKRouterPage_TbtDesignerList; //土巴兔设计师列表

//-------------v8.5.0---------------------
extern TRouterPath const THKRouterPage_fanweLiveRoom; //方维直播间或回播间-属于自定义路由类型
extern TRouterPath const THKRouterPage_fanweLiveAuth; //方维直播认证
extern TRouterPath const THKRouterPage_fanweStoreAuth; //方维店铺认证
extern TRouterPath const THKRouterPage_fanweItemDetail; //方维商品详情
extern TRouterPath const THKRouterPage_fanweOrderDetail; //方维订单详情
extern TRouterPath const THKRouterPage_fanweGoodsManager; //方维商品管理

//-------------v8.6.0---------------------
extern TRouterPath const THKRouterPage_DiaryWrite;//编辑日记
extern TRouterPath const THKRouterPage_DiaryBookWrite;//编辑日记本
extern TRouterPath const THKRouterPage_PopularityList;

//-------------v8.7.0---------------------
extern TRouterPath const THKRouterPage_CommunityHotList;//社区热门tab
extern TRouterPath const THKRouterPage_CommunityFollowList;//社区关注tab
extern TRouterPath const THKRouterPage_CommunityTopicList;//社区话题tab
extern TRouterPath const THKRouterPage_CreatorCenter; // 创作者中心
extern TRouterPath const THKRouterPage_CreatorCollege; // 创作者学院
extern TRouterPath const THKRouterPage_ChannelPrettyList; //美图tab 频道聚合页
extern TRouterPath const THKRouterPage_ChannelCaseList; //方案tab 频道聚合页
extern TRouterPath const THKRouterPage_HomeLive;// 首页直播Tab
extern TRouterPath const THKRouterPage_HomeRecommend;// 首页推荐Tab
extern TRouterPath const THKRouterPage_HomeVideo;// 首页视频Tab
extern TRouterPath const THKRouterPage_DiaryChannel; // 日记频道页 v10.11.0
extern TRouterPath const THKRouterPage_DiaryList; // change v10.11.0 日记频道 B方案
extern TRouterPath const THKRouterPage_ChannelListFragment; // 日记频道 A方案
extern TRouterPath const THKRouterPage_TacticList; // 经验Tab
extern TRouterPath const THKRouterPage_LivePreviewDetail;//预告详情
extern TRouterPath const THKRouterPage_TuCoinCenter; // 兔币中心
extern TRouterPath const THKRouterPage_MyBilling; // 记账
extern TRouterPath const THKRouterPage_FullHouseCustom; // 全屋定制
extern TRouterPath const THKRouterPage_WebViewTab;//WebView
extern TRouterPath const THKRouterPage_MyHomeLiveDevice; // 工地直播
extern TRouterPath const THKRouterPage_MyHomeMeasureReport; // 量房报告

//-------------v8.8.0---------------------
extern TRouterPath const THKRouterPage_CreateLiveNotice;//发起预告
extern TRouterPath const THKRouterPage_CreateLiveRoom;//发起直播
extern TRouterPath const THKRouterPage_SubjectDetail; // 专题

extern TRouterPath const THKRouterPage_TopicVideosSet;///< 话题视频集列表页,参数{name:话题名, cover:话题封面url(需要urlEncode),desc: 共xxx条视频(可不传，UI显示可从列表数据中取得后自行更新到UI, code: 视频列表接口需要的全码串)}
extern TRouterPath const THKRouterPage_openWechatMini;///打开微信小程序

//-------------v8.9.0---------------------
extern TRouterPath const THKRouterPage_LiveCateListTab;//直播分类列表
extern TRouterPath const THKRouterPage_TagVideosSet;///< 点击了推荐的标签卡片中的某个标签项跳转的标签项下的视频集列表页. 参数{wholeCode: 接口需要的全码串, title: 标签串，需要urlEncode}

//-------------v8.9.1---------------------
extern TRouterPath const THKRouterPage_MyNewHomeMain;
extern TRouterPath const THKRouterPage_MyHomeAdditional; //水电增项
extern TRouterPath const THKRouterPage_MyHomeLiveView; //工地直播页
extern TRouterPath const THKRouterPage_MyHomeApplyQCView;
extern TRouterPath const THKRouterPage_MyHomeCommentSuccessView;
extern TRouterPath const THKRouterPage_MyHomeCommentSupervisor;
extern TRouterPath const THKRouterPage_MyHomeAgreeToPay;//
extern TRouterPath const THKRouterPage_MyHomeSignSuccess;
extern TRouterPath const THKRouterPage_MyHomeSwitchProject;
extern TRouterPath const THKRouterPage_MyHomeProjectConfirm;
extern TRouterPath const THKRouterPage_DepositRecharge;
extern TRouterPath const THKRouterPage_DepositRefund;
extern TRouterPath const THKRouterPage_DepositManager;
extern TRouterPath const THKRouterPage_RetrieveProject;
extern TRouterPath const THKRouterPage_RefundListView;

// --------------- v8.10.0 ------------------------
extern TRouterPath const THKRouterPage_NewDecorationRaidersDetail; // 新版装修攻略路由

///V8.10.0
extern TRouterPath const THKRouterPage_HomeRecommendNew;

//V8.11.0
extern TRouterPath const THKRouterPage_CompanyAddressMapView;//地图显示装企详情地址
extern TRouterPath const THKRouterPage_CompanyCommentListView;
extern TRouterPath const THKRouterPage_CompanyDesignerListView;
extern TRouterPath const THKRouterPage_CompanySiteListView;
extern TRouterPath const THKRouterPage_CompanyDetailTabHomePageView;
extern TRouterPath const THKRouterPage_CompanyDetailTabCraftPageView;
extern TRouterPath const THKRouterPage_CompanyConstructorListView;

// --------------- v8.11.0 ------------------------
extern TRouterPath const THKRouterPage_HomeNative;

extern TRouterPath const THKRouterPage_CompanyDetailTabDynamicView;
extern TRouterPath const THKRouterPage_CompanyDetailTabConstructorView;
extern TRouterPath const THKRouterPage_CompanyDetailTabDiaryListView;
extern TRouterPath const THKRouterPage_HostCenter; // 直播中心

/// V8.12.0
extern TRouterPath const THKRouterPage_MyDiaryBook;// 我的日记本

/// V8.14.0
//mpaas
extern TRouterPath const THKRouterPage_mPaash5 __deprecated_msg("9.0.0版已移除mpaas框架，此定义已无效");///< 9.0.0移除mpaas
extern TRouterPath const THKRouterPage_mPaasMiniProgram __deprecated_msg("9.0.0版已移除mpaas框架，此定义已无效");///< 小程序路由| 9.0.0移除mpaas

extern TRouterPath const THKRouterPage_CommonEmptyView;

/// V8.16.0
extern TRouterPath const THKRouterPage_PersonProfile;// 个人资料页

/// V8.16.3
extern TRouterPath const THKRouterPage_BrandDetail;// 品牌商家详情页

/// V8.17.1
extern TRouterPath const THKRouterPage_CompanyQualification;// 网店公司介绍页

///V9.0.0
extern TRouterPath const THKRouterPage_NewHomeMainView;
extern TRouterPath const THKRouterPage_CollectionList;// 收藏列表
extern TRouterPath const THKRouterPage_LikeList;// 喜欢列表

extern TRouterPath const THKRouterPage_DecorationCompanyList;         //网店列表
extern TRouterPath const THKRouterPage_DecorationRecommendList;     //网店日记
extern TRouterPath const THKRouterPage_DecorationServiceActivity; //二级装企页面

extern TRouterPath const THKRouterPage_UGCGraphicDetail;//UGC图文详情页
extern TRouterPath const THKRouterPage_3DDesignHomePage;//3D设计首页

//9.0.2
extern TRouterPath const THKRouterPage_MessageCenter; //消息中心
//9.3.0
extern TRouterPath const THKRouterPage_SelectMaterialHomePage; //选材首页
extern TRouterPath const THKRouterPage_MaterialAllCategory; //选材全部分类
extern TRouterPath const THKRouterPage_MaterialCertifieldBrand; //大牌在线详情
extern TRouterPath const THKRouterPage_BrandRecommendList;//品牌详情推荐页面
extern TRouterPath const THKRouterPage_SelectMaterialCategoryDetail; //选材分类详情页
extern TRouterPath const THKRouterPage_SelectMaterialHotRank; //热门榜单
extern TRouterPath const THKRouterPage_SelectMaterialBrandRank; //品牌榜单
extern TRouterPath const THKRouterPage_SelectMaterialCommodityRank; //商品榜单

//v9.2.1
extern TRouterPath const THKRouterPage_CounterPay; // 新版收银台(web用)

extern TRouterPath const THKRouterPage_MaterialSubVC; // 新版收银台(web用)

@interface THKRouterPathDefine : NSObject

@end

NS_ASSUME_NONNULL_END
