//
//  TRouterPathDefine.m
//  HouseKeeper
//
//  Created by 彭军 on 2019/5/15.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKRouterPathDefine.h"

NSString * const TRouter_Scheme = @"to8to";
NSString * const TRouter_Host = @"tbtrouter";
NSString * const TRouter_Build_Host = @"tbtbuilder";

//-------------v7.5.0---------------------
TRouterPath const THKRouterPage_AppMainTab = @"/app/main";//首页Tab切换
TRouterPath const THKRouterPage_PrettyCaseChannel = @"/app/choose/case";//美图/方案/3D 频道聚合页
TRouterPath const THKRouterPage_StrategyDiaryAskVideoChannel= @"/app/learn/decorate";//攻略/日记/问答/视频 频道聚合页
TRouterPath const THKRouterPage_HousePlanDiagnosisList=@"/ask/diagnosis/diagnosisList";// 户型诊断列表
TRouterPath const THKRouterPage_HousePlanDiagnosisDetail=@"/ask/diagnosis/diagnosisInfo";// 户型诊断详情
TRouterPath const THKRouterPage_HousePlanPublish=@"/ask/diagnosis/houseplan";// 发布户型图
TRouterPath const THKRouterPage_DesignerList= @"/shejiben/designer/list";//设计师大咖
TRouterPath const THKRouterPage_DesignerDetail = @"/shejiben/detail";//设计师大咖详情
TRouterPath const THKRouterPage_CompanyList = @"/company/companyList";//装修公司列表页
TRouterPath const THKRouterPage_CompanyDetail = @"/company/detail/act";//装修公司详情页
TRouterPath const THKRouterPage_MainSearch = @"/search/mainsearch";//全局搜索页
TRouterPath const THKRouterPage_CaseDetail = @"/housecase/case/detail/act";// 案例详情（设计师/装企/3D）
TRouterPath const THKRouterPage_PrettyPicDetail = @"/base/detail";//效果图（美图）详情页/UGC图文
TRouterPath const THKRouterPage_UGCVideoDetail = @"/video/act";//UGC/PGC视频详情页
TRouterPath const THKRouterPage_UGCArticleDetail = @"/ugc/articleDetail";//UGC文章(达人说)
TRouterPath const THKRouterPage_AskDetail = @"/ask/web/detail";//问答详情页
TRouterPath const THKRouterPage_StrategyDetail = @"/strategy/detail";//攻略详情页
TRouterPath const THKRouterPage_DiaryDetail = @"/locale/detail/act";//日记详情页
TRouterPath const THKRouterPage_MyHomeMain = @"/myHome/main";//我的家首页
TRouterPath const THKRouterPage_OldHomeMain = @"/newhome/ac";//旧版管工地
TRouterPath const THKRouterPage_IndexPublish = @"/index/publish";//发布页面
TRouterPath const THKRouterPage_NewDiaryDetail = @"/locale/diaryDetail";//子日记详情页
TRouterPath const THKRouterPage_CompanyCaseList = @"/company/plan/list/act";//网店案例列表

//-------------v7.7.0---------------------
TRouterPath const THKRouterPage_IMChat = @"/tim/newtransfer";//IM聊天页面
TRouterPath const THKRouterPage_Relationship = @"/ucenter/homePage";//个人主页
TRouterPath const THKRouterPage_IntegralTask = @"/ucenter/IntegralTask";//任务中心
TRouterPath const THKRouterPage_EditTransparent = @"/ugc/pic/edit/transparent";//晒我家
TRouterPath const THKRouterPage_DiaryDispatch = @"/locale/diary/dispatch";//写日记
TRouterPath const THKRouterPage_DecorationDynamicState = @"/project/detail/live";//装修动态

//-------------v7.9.0---------------------
TRouterPath const THKRouterPage_VideoDetail = @"/video/slide";//新版视频详情页，具体参数数据与 /video/act 路由保持一致即可
TRouterPath const THKRouterPage_WalletBankCard = @"/money/bank/list";//银行卡列表页面

TRouterPath const THKRouterPage_Command = @"/common/command";//口令
TRouterPath const THKRouterPage_InspirationDetail = @"/inspiration/detail";//灵感集详情
TRouterPath const THKRouterPage_3DFullViewDetail = @"/3dfullview/detail";//3D全景图详情
TRouterPath const THKRouterPage_SearchResult = @"/search/result";//701.搜索结果页
TRouterPath const THKRouterPage_CompanyDesignerDetail = @"/company/designer/detail";//装修公司设计师详情
TRouterPath const THKRouterPage_ContractList = @"/myhome/contract/list";//合同列表

//-------------v7.12.0---------------------
TRouterPath const THKRouterPage_MyWallet = @"/money/detail";//钱包页面

//-------------v7.13.0---------------------
TRouterPath const THKRouterPage_AllCommentList = @"/commsocial/comment/totalList";//全部评论列表页面
TRouterPath const THKRouterPage_TopicMsgList = @"/topic/list/msg";//话题消息页面
TRouterPath const THKRouterPage_TopicCommentWrite = @"/commsocial/comment/write";//话题评论页面
TRouterPath const THKRouterPage_AdDetail = @"/ad/detail";//广告页面
TRouterPath const THKRouterPage_AskChannelList = @"/ask/bridge/activity";//问答分类列表
TRouterPath const THKRouterPage_AskAddAnswer = @"/ask/activity/add_answer";//添加回答页面
TRouterPath const THKRouterPage_ExpertChat = @"/expert/entrance/verify";//专家服务页面

//-------------v8.0.0---------------------
TRouterPath const THKRouterPage_NewhomeQualityrecord = @"/newhome/qualityrecord";//质检报告页面
TRouterPath const THKRouterPage_CommunityTopicDetail = @"/community/topic/detail";// 社区话题详情页

//-------------v8.1.0---------------------
TRouterPath const THKRouterPage_MyHomeAddComment = @"/myhome/comment/addComment";// 我的家添加评价页面
TRouterPath const THKRouterPage_MyHomeCommentList = @"/myhome/comment/commentList";// 我的家评价列表

TRouterPath const THKRouterPage_ShouYinTai = @"/money/shouyintai"; // 新版收银台


//-------------v8.2.0---------------------
TRouterPath const THKRouterPage_ProjectDetailBroadcast = @"/project/detail/broadcast"; // 装修播报
TRouterPath const THKRouterPage_MyWalletDetailOrder = @"/money/detail/order"; // 款项记录

TRouterPath const THKRouterPage_MessageList = @"/message/list";//消息列表页

TRouterPath const THKRouterPage_DecorationRaidersList = @"/decorationraiders/list"; // 装修攻略主页

TRouterPath const THKRouterPage_DecorationRaidersDetail = @"/decorationraiders/detail"; // 装修攻略详情页

TRouterPath const THKRouterPage_NewDecorationRaidersDetail = @"/newdecorationraiders/detail"; // 新版装修攻略详情页

//TRouterPath const THKRouterPage_ProjectManagerMainView = @"/projectManager/mainView"; 
TRouterPath const THKRouterPage_DesignerServiceEdit = @"/designer/service/edit";//服务信息编辑页面
TRouterPath const THKRouterPage_DesignerServiceCheck = @"/designer/service/check";//服务信息查看页面

//-------------v8.3.0---------------------
TRouterPath const THKRouterPage_MyhomeContractDetail = @"/myhome/contract/contractDetail";//合同详情页

//-------------v8.4.0---------------------
TRouterPath const THKRouterPage_TbtDesignerList = @"/tbt/designer/list"; //土巴兔设计师列表

//-------------v8.5.0---------------------
TRouterPath const THKRouterPage_fanweLiveRoom = @"/fan/liveRoom"; //方维直播间或回播间-属于自定义路由类型
TRouterPath const THKRouterPage_fanweLiveAuth = @"/fan/liveAuth"; //方维直播认证
TRouterPath const THKRouterPage_fanweStoreAuth = @"/fan/storeAuth"; //方维店铺认证
TRouterPath const THKRouterPage_fanweItemDetail = @"/fan/itemdetail"; //方维商品详情
TRouterPath const THKRouterPage_fanweOrderDetail = @"/fan/orderdetail"; //方维订单详情
TRouterPath const THKRouterPage_fanweGoodsManager = @"/fan/itemmanager"; //方维商品管理

//-------------v8.6.0---------------------
TRouterPath const THKRouterPage_DiaryWrite = @"/locale/diary/write";//编辑日记
TRouterPath const THKRouterPage_DiaryBookWrite = @"/locale/diary/book/edit";//编辑日记本
TRouterPath const THKRouterPage_PopularityList = @"/fan/livePopList";//人气排行榜

//-------------v8.7.0---------------------
TRouterPath const THKRouterPage_WebViewTab = @"/common/tab/webview";//WebView
TRouterPath const THKRouterPage_CommunityHotList = @"/community/homeHotFeed";//社区热门tab
TRouterPath const THKRouterPage_CommunityFollowList = @"/community/homeFollowingFeed";//社区关注tab
TRouterPath const THKRouterPage_CommunityTopicList = @"/community/topic/communityTopic";//社区话题tab
TRouterPath const THKRouterPage_CreatorCenter = @"/creator/center"; // 创作者中心
TRouterPath const THKRouterPage_CreatorCollege = @"/creator/institute"; // 创作者学院
TRouterPath const THKRouterPage_ChannelPrettyList = @"/pretty/list";//美图 频道tab
TRouterPath const THKRouterPage_ChannelCaseList = @"/case/list";//方案 频道tab
TRouterPath const THKRouterPage_HomeLive = @"/home/live";// 首页直播Tab
TRouterPath const THKRouterPage_HomeRecommend = @"/home/recommend";// 首页推荐Tab
TRouterPath const THKRouterPage_HomeVideo = @"/home/video";// 首页视频Tab
TRouterPath const THKRouterPage_DiaryChannel = @"/locale/diary/diaryChannel"; // 日记频道页

TRouterPath const THKRouterPage_ChannelListFragment = @"/locale/diary/channelListFragment"; // 日记频道 A方案 双feed
TRouterPath const THKRouterPage_DiaryList = @"/locale/diary/list";// 日记列表Tab  change v10.11.0 日记频道 B方案 单feed

TRouterPath const THKRouterPage_TacticList = @"/strategy/list";// 经验单列表Tab
TRouterPath const THKRouterPage_LivePreviewDetail = @"/livePreview/detail"; //预告详情
TRouterPath const THKRouterPage_TuCoinCenter = @"/ucenter/tubiCenter"; // 兔币中心
TRouterPath const THKRouterPage_MyBilling = @"/tally/activity"; // 记账
TRouterPath const THKRouterPage_FullHouseCustom = @"/money/customhouse/activity"; // 全屋定制
TRouterPath const THKRouterPage_MyHomeLiveDevice = @"/myhome/liveDevice"; // 工地直播
TRouterPath const THKRouterPage_MyHomeMeasureReport = @"/myhome/measurereport"; // 量房报告

//-------------v8.8.0---------------------
TRouterPath const THKRouterPage_CreateLiveNotice = @"/live/createLiveNotice";//发起预告
TRouterPath const THKRouterPage_CreateLiveRoom = @"/live/createLiveRoom";//发起直播
TRouterPath const THKRouterPage_SubjectDetail = @"/subject/detail/act"; // 专题

TRouterPath const THKRouterPage_TopicVideosSet = @"/community/topic/videosSet";///< 话题视频集列表页,参数{name:话题名, cover:话题封面url(需要urlEncode),desc: 共xxx条视频(可不传，UI显示可从列表数据中取得后自行更新到UI, code: 视频列表接口需要的全码串)}

TRouterPath const THKRouterPage_openWechatMini = @"/open/wechatMini"; //打开微信小程序

//8.9.0
TRouterPath const THKRouterPage_LiveCateListTab = @"/home/live/cateList";//直播分类列表
TRouterPath const THKRouterPage_TagVideosSet = @"/video/tag/videoSet";///< 点击了推荐的标签卡片中的某个标签项跳转的标签项下的视频集列表页. 参数{wholeCode: 接口需要的全码串, title: 标签串，需要urlEncode}

//8.9.1 add by amby.qin
TRouterPath const THKRouterPage_MyNewHomeMain = @"/myHouse/main";//新版我的家首页
TRouterPath const THKRouterPage_MyHomeAdditional = @"/myhome/project/additional";//水电增项
TRouterPath const THKRouterPage_MyHomeLiveView = @"/myhome/project/liveView";//工地直播
TRouterPath const THKRouterPage_MyHomeApplyQCView = @"/myhome/project/applyQCView";//提交质检服务
TRouterPath const THKRouterPage_MyHomeCommentSuccessView = @"/myhome/comment/successView";//评价成功
TRouterPath const THKRouterPage_MyHomeCommentSupervisor = @"/myhome/comment/supervisor"; //评价工长
TRouterPath const THKRouterPage_MyHomeAgreeToPay = @"/myhome/payment/agree"; //同意付款
TRouterPath const THKRouterPage_MyHomeSignSuccess = @"/myhome/contract/signSuccess";//签约成功
TRouterPath const THKRouterPage_MyHomeSwitchProject = @"/myhome/project/switch";//切换工地
TRouterPath const THKRouterPage_MyHomeProjectConfirm = @"/myhome/project/confirm";//确认竣工时间
TRouterPath const THKRouterPage_DepositRecharge = @"/money/deposit/recharge";//订金充值
TRouterPath const THKRouterPage_DepositRefund = @"/money/deposit/refund";//退款详情
TRouterPath const THKRouterPage_DepositManager = @"/money/deposit/manager";
TRouterPath const THKRouterPage_RetrieveProject = @"/myhome/project/retrieve";//找回工地
TRouterPath const THKRouterPage_RefundListView = @"/money/deposit/refundList";//申请退款

///V8.10.0
TRouterPath const THKRouterPage_HomeRecommendNew = @"/home/recommendNew";// 首页推荐Tab B方案


//V8.11.0
TRouterPath const THKRouterPage_CompanyAddressMapView = @"/company/address/map";//地图显示装企详情地址
TRouterPath const THKRouterPage_CompanyCommentListView = @"/company/comment/list";//装企评论列表页
TRouterPath const THKRouterPage_CompanyDesignerListView = @"/company/designer/list";//装企设计师列表
TRouterPath const THKRouterPage_CompanyConstructorListView = @"/company/constructor/list";//工长列表
TRouterPath const THKRouterPage_CompanySiteListView = @"/company/site/list";//装企设站点列表
TRouterPath const THKRouterPage_CompanyDetailTabHomePageView = @"/company/detail/tab/homepage";//装企详情页中的tab“首页”
TRouterPath const THKRouterPage_CompanyDetailTabCraftPageView = @"/company/detail/tab/craft";//装企详情页中的tab“工艺”
TRouterPath const THKRouterPage_HomeNative = @"/home/localTab";// 首页-本地Tab
TRouterPath const THKRouterPage_CompanyDetailTabDynamicView = @"/company/trend/list";//工地动态页
TRouterPath const THKRouterPage_CompanyDetailTabConstructorView = @"/company/constructor/list";//工长
TRouterPath const THKRouterPage_CompanyDetailTabDiaryListView = @"/locale/diary/company/list";
TRouterPath const THKRouterPage_HostCenter = @"/flive/hostCenterActivity"; // 直播中心

/// V8.12.0
TRouterPath const THKRouterPage_MyDiaryBook = @"/locale/myDiary";  // 我的日记本

/// V8.14.0
TRouterPath const THKRouterPage_mPaash5 = @"/mpaas/h5";//mpaas路由
TRouterPath const THKRouterPage_mPaasMiniProgram = @"/mpaas/miniProgram";//小程序路由

TRouterPath const THKRouterPage_CommonEmptyView = @"/common/emptyView";  // 通用的空白页面

/// V8.16.0
TRouterPath const THKRouterPage_PersonProfile = @"/person/profile";// 个人资料页

/// V8.16.3
TRouterPath const THKRouterPage_BrandDetail = @"/brand/detail";// 品牌商家详情页

/// V8.17.1
TRouterPath const THKRouterPage_CompanyQualification = @"/company/detail/companyQualification";// 网店公司介绍页

///V9.0.0
TRouterPath const THKRouterPage_NewHomeMainView = @"/home/new";// 首页Tab B方案
TRouterPath const THKRouterPage_CollectionList = @"/interaction/inspirationCollect/fm";// 收藏列表
TRouterPath const THKRouterPage_LikeList = @"/ucenter/user/likeFragment";// 喜欢列表

TRouterPath const THKRouterPage_DecorationCompanyList = @"/decoration/company/list";         //网店列表
TRouterPath const THKRouterPage_DecorationRecommendList = @"/decoration/recommend/list";     //网店日记
TRouterPath const THKRouterPage_DecorationServiceActivity = @"/decoration/service/activity"; //二级装企页面

///V9.1.0
TRouterPath const THKRouterPage_UGCGraphicDetail = @"/ugc/pic/detail/act";//UGC图文详情页
TRouterPath const THKRouterPage_3DDesignHomePage = @"/case/3ddesign/homePage";//3D设计首页

//9.0.2
TRouterPath const THKRouterPage_MessageCenter = @"/tim/TMsgCenterActivity"; //消息中心


//9.3.0
TRouterPath const THKRouterPage_SelectMaterialHomePage = @"/material/index"; //选材首页
TRouterPath const THKRouterPage_MaterialAllCategory = @"/material/allCategory"; //选材全部分类
TRouterPath const THKRouterPage_MaterialCertifieldBrand = @"/material/brand/bigBrandOnlineDetail";// 大牌在线详情
TRouterPath const THKRouterPage_BrandRecommendList = @"/material/brand/recommendList";// 大牌在线详情
TRouterPath const THKRouterPage_SelectMaterialCategoryDetail = @"/material/mainCategoryDetail"; //选材分类详情页
TRouterPath const THKRouterPage_SelectMaterialHotRank = @"/material/rank/hot"; //热门榜单
TRouterPath const THKRouterPage_SelectMaterialBrandRank = @"/material/rank/model"; //品牌榜单
TRouterPath const THKRouterPage_SelectMaterialCommodityRank = @"/material/rank/all"; //商品榜单

//v9.2.1
TRouterPath const THKRouterPage_CounterPay = @"/money/counterPay"; // 新版收银台(web用)

TRouterPath const THKRouterPage_MaterialSubVC = @"/material/materialSubVC"; // 新版收银台(web用)

@implementation THKRouterPathDefine

@end
