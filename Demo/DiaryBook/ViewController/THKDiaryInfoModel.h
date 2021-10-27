//
//  THKDiaryListModel.h
//  HouseKeeper
//
//  Created by amby.qin on 2019/7/22.
//  Copyright © 2019 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "THKDiaryCommonModel.h"
//#import "THKDiaryProductDataModel.h"
//#import "THKDeleteDairyRequest.h"
//#import "NSString+Lines.h"
//#import "THKAssetResourceModel.h"
//#import "THKMyDiaryBookDataModel.h"
//#import "THKCommunityFeedImagesView.h"
//#import "THKDraftCacheManager.h"
//#import "THKSearchContentResponse.h"

NS_ASSUME_NONNULL_BEGIN

//cell底部工具条高度  15的底部间距 + 27的高度
#define kHeightOfBottomBar (20+22)
//显示日记审核不通过原因的lable的高度
#define kHeightOfLblMarking ([UIFont systemFontOfSize:11].lineHeight)

#define kTagAddOfImgv 168
#define kImgColumnCount 3
//#define kImgWidth 90.0
#define kImgMarginX 6.0
//配图视图外侧的间距
#define KNPictureViewOutterMargin (20.0)
#define KNPictureViewWidth (kScreenWidth - 2 * KNPictureViewOutterMargin)
//每个Item图的宽度
#define kImgWidth ((KNPictureViewWidth - (kImgColumnCount - 1) * kImgMarginX) / kImgColumnCount)


#define KNDiary_commentHF_Margin (8.0)
#define KNDiary_commentSeeMore_H (24.0)

////日记状态
typedef enum {
    kDiaryStatus_ok = 1, //正常，审核成功;
    kDiaryStatus_waitReview = 3, //3待审核;
    kDiaryStatus_reject = 4, //4:审核失败
    kDiaryStatus_deleted = -1,
    kDiaryStatus_posting = 0,
    kDiaryStatus_postFail = 5,
    kDiaryStatus_creating = 6, //创建中
}kDiaryStatus;

typedef enum {
    THKDiaryStatusAuditing = 0, //0待审核;
    THKDiaryStatusAuditSuccess = 1, //1正常，审核成功;
    THKDiaryStatusReject = 2, //2:审核不通过
    THKDiaryStatusShield = 3, //3屏蔽
    THKDiaryStatusDelete = 4,//4删除
    //本地用到
    THKDiaryStatusCreating = 80, //创建中
    THKDiaryStatusPosting = 81,//81发送中
    THKDiaryStatusPostFail = 82,//82发送失败
}THKDiaryStatus;

typedef enum {
    
    kDiaryComeFrom_PersonCeter = 6, //来自个人中心
    
}kDiaryComeFromStyle;

@class THKDiaryVideoInfoModel, THKDiaryBookDetailModel, THKDiaryInfoModel;

@interface THKDiaryStageModel : NSObject
@property (nonatomic, assign) NSInteger firstStageId;///<一级阶段名称
@property (nonatomic, strong) NSString *firstStageName;///<一级阶段名称
@property (nonatomic, strong) NSArray<THKDiaryInfoModel *> *diaryInfoList;

@property (nonatomic, assign) BOOL isDirectoryExpose;
@end

//日记信息的Model
@interface THKDiaryInfoModel : NSObject

/**
 *    8.11.0 add 二级阶段
 */
@property (nonatomic , assign) NSInteger              auditTemplateId;
@property (nonatomic , copy) NSString              * firstStageName;
@property (nonatomic , assign) NSInteger              secondStageId;//装修二级阶段id
@property (nonatomic , copy) NSString              * secondStageName;//装修二级阶段名称
@property (nonatomic , copy) NSString              * secondStageIcon;//装修二级阶段名称
@property (nonatomic , assign) NSInteger              firstStageId;
@property (nonatomic , assign) NSInteger                offset; ///< 当前子日记在列表中的位置 | 2021.10.25
@property (nonatomic, assign) BOOL                      showFirstStageName; ///< 该篇子日记是否为一级阶段下第一篇子日记（是否展示一级阶段名称） | 2021.10.25

@property (nonatomic, copy)     NSString *auditReason;// (string, optional): 审核理由 ,
@property (nonatomic, assign)   THKDiaryStatus auditStatus;// (integer, optional): 审核状态(0-待审核、1-审核通过、2-审核不通过、3-屏蔽、4-删除)
@property (nonatomic, copy)     NSString *auditFailedUrl;//审核失败的H5
@property (nonatomic, assign)   NSUInteger companyId;//子日记所属日记本的装企id
@property (nonatomic, copy)     NSString *content;// (string, optional): 内容 ,
@property (nonatomic, assign)   NSInteger diaryBookId;// (integer, optional): 日记本id ,
@property (nonatomic, copy)     NSString *diaryBookTitle;// (string, optional): 日记本标题 ,
@property (nonatomic, assign)   NSInteger diaryId;// (integer, optional): 日记id ,
@property (nonatomic, assign)   NSInteger ownerId;// (integer, optional): 业主 ,
//@property (nonatomic, strong)   NSArray<THKDiaryProductDataModel *> *productList;// (Array[日记清单项], optional): 清单列表 ,
@property (nonatomic, assign)   NSInteger publishTime;// (integer, optional): 发布时间 ,
@property (nonatomic, assign)   NSInteger stageBigId;// (integer, optional): 装修阶段id ,
@property (nonatomic, copy)     NSString *stageBigName;// (string, optional): 装修阶段名称,
//@property (nonatomic, strong)   NSArray<TInteractiveCommentViewModel *> *comments;//(array, optional)评论数组,
@property (nonatomic, assign)   NSInteger commentNum;// (integer, optional): 评论数,
//@property (nonatomic, strong)   NSArray<THKDiaryCommonImageModel *> *imageList;// (Array[string], optional): 图片列表,
@property (nonatomic, assign)   NSInteger isOriginal;//是否是原创 (1:原创 0:非原)
@property (nonatomic, assign)   BOOL isCollect;///< 收藏状态
@property (nonatomic, assign)   NSInteger collectNum;///< 收藏数
@property (nonatomic, assign)   NSInteger praiseNum;// (integer, optional): 点赞数 ,
@property (nonatomic,assign)    NSInteger isPraise;
@property (nonatomic, copy)     NSString *shareUrl;// (string, optional): 分享 url;
@property (nonatomic, assign)   NSInteger topicId;// 话题id;
@property (nonatomic, copy)     NSString *topicTitle;// 话题名;
@property (nonatomic, copy)     NSString *topicIcon;// 话题图标;
@property (nonatomic, copy)     NSString *wholeCode;// 话题全码;
@property (nonatomic, assign)   BOOL disabledEditTopic;//话题不可编辑
@property (nonatomic, assign)   BOOL isFromTopicVc;//从话题详情页发布
@property (nonatomic, assign)   NSInteger cityId;// 城市id;
@property (nonatomic, copy)     NSString *cityName;// 城市名;
@property (nonatomic, assign)   CGFloat longitude;// 经度
@property (nonatomic, assign)   CGFloat latitude;// 纬度
@property (nonatomic, copy)     NSString *locationName;// 具体位置

///>视频
@property (nonatomic, assign) NSInteger videoId;
///>视频资源
//@property (nonatomic, strong, nullable) THKAssetResourceModel *assetResourceModel;
//@property (nonatomic, assign, readonly) BOOL isVideo;
//@property (nonatomic, strong) NSArray <THKDiaryVideoInfoModel *> *videoInfoList;
//@property (nonatomic, copy, readonly) THKDiaryVideoInfoModel *editVideoInfo;
//
/////>所属日记本信息
//@property (nonatomic, strong, nullable) THKMyDiaryBookDataModel *diaryBookDataModel;
//@property (nonatomic, strong, nullable) THKDiaryBookDetailModel *diaryBookDetailModel;
//
//@property (nonatomic,assign)    NSInteger   score;//积分
////日记列表的
//@property (nonatomic, strong)   THKDiaryProductDataModel *productVO;
//
////所选订单的总价
//@property(nonatomic , assign)CGFloat productTotalPrice;
//
///*
// 9.5 add 质检卡片
// */
//@property (nonatomic, strong) NSArray <THKQIServiceModel *> *inspectionDataList;

//本地使用
//@property (nonatomic,assign) NSTimeInterval localCreateTime;//本地创建时间 用于排序
@property (nonatomic,assign) BOOL isLocalDiary; //是否是刚发送的本地日记
@property (nonatomic,assign) NSInteger postDate; //发送时间，时间戳(根据这个字段删除本地文件)

//用于 设置是否原创 ，草稿箱的数据不需要设置默认值
@property (nonatomic,assign) BOOL isFromDraftBox; //是否是草稿数据
@property (nonatomic,assign) BOOL disableShowAlert; //是否禁止弹出完善日记本

@property (nonatomic,assign) NSTimeInterval otime;//创建时间 用于排序
//localCreateTime
@property (nonatomic,assign) NSTimeInterval ctime;// 系统分配发布时间 用于排序
@property (nonatomic,strong)NSString *createDate; //时间显示
@property (nonatomic,strong) NSString *strOtime;

@property (nonatomic,assign) CGFloat heigitOfCell;
@property (nonatomic,assign) CGFloat heightOfLblContent;

#pragma mark - 自定义样式
@property(nonatomic , assign)BOOL isBottomCell;

@property(nonatomic , assign)BOOL isLastCell;

//计算完成完整的cell高度缓存
@property(nonatomic , assign)CGFloat totalCellH;

//需要完整文字的高度(是否需要展开文字)
//@property(nonatomic , assign)BOOL isNeedAllTextH;

//当前日记内容显示需要的行数
@property(nonatomic , assign)NSInteger totalTRow;

//展示更多日记内容的按钮的显示与隐藏 No表示隐藏
@property(nonatomic , assign)BOOL isMoreContentHidden;

//是否需要重新计算cell的高度 缓存机制 提高性能
@property(nonatomic , assign)BOOL isNeedCalCellH;

//图片空间高度之上的总高度
@property(nonatomic , assign)CGFloat imgWidgetH;

//清单空间高度之上的总高度
@property(nonatomic , assign)CGFloat listWidgetH;

//清单栏是否需要折叠  no不用折叠 就不用折叠按钮
@property(nonatomic , assign)BOOL isListNeedFold;

//清单栏折叠按钮的状态 no不展示全部清单
@property(nonatomic , assign)BOOL isNeedAllList;

//正文顶部约束高度  默认为20 但是第一条为5
@property(nonatomic , assign)CGFloat contentTopCH;

//内容的行高
@property(nonatomic , assign)CGFloat contentLineHeight;

//cell底部分割线的高度
@property(nonatomic , assign)CGFloat cellButtomCH;

 //审核失败完整文本高度
@property (nonatomic,assign) CGFloat fullRemarkHeight;

//评论控件高度
@property (nonatomic,assign) CGFloat commentVH;

//新增,兼容个人中心 是否需要判断是否是主人状态 来达到不显示编辑按钮的目的
@property(nonatomic , assign)   kDiaryComeFromStyle comeFormStyle;
//是否需要显示更多评论,现规则是超过三条评论则显示更过评论
@property (nonatomic,assign) BOOL isNeedMoreComment; //评论数量

//add by amby.qin 从社区进入，互动数据上报需要加上页面来源
@property (nonatomic, copy) NSString    *gePage_Refer_Uid;

/** 分享的数据字典 | 分享功能里会自行解析此字典数据 .编辑成功后需要返回新的分享数据
 * {title:xx, content:xx, imageUrl,xxx, webpageUrl:xxx, sinaContent, generatePicture: {}, reportData: {id:xx, type:xxx}}, miniWechat:{miniPath:xxx, ...}}
 *
 */
@property (nonatomic, copy) NSDictionary *shareData;

-(BOOL)isOwner;
-(BOOL)isOwnerDiary;

-(NSArray *)arrImgUrl;

//-(void)deleteWithCompleteHandle:(T8TBOOLBlock)aBlock HUDVIew:(UIView *)aView;

+ (id)createDiary;

-(void)setWithDict:(NSDictionary *)dict;

//检测屏蔽是否可以后续操作提示“日记被屏蔽，无法进行此操作！”（评论、点赞、编辑、删除）
- (BOOL)checkShieldCanAction;

//检测审核未通过是否可以后续操作提示“日记审核不通过，无法进行此操作！”（评论、点赞）
- (BOOL)checkRejectCanAction;

//检测本地发布数据
- (BOOL)checkSendingStatus;

//视频高度
@property(nonatomic , assign)CGSize videoWidgetSize;


//日记视频新增

//日记类型(0-文本日记、1-视频日记),
@property (nonatomic, assign)NSInteger diaryType;

//@property (nonatomic, strong, nullable) THKCommunityFeedFlowSetImageModel *cFlowImageModel;
//
/////>更新视频信息
//- (void)updateVideoInfo:(T8TBOOLBlock)block;

//是否已经曝光埋点
@property(nonatomic , assign)BOOL isReportShow;

//@property (nonatomic, assign)BOOL isContentAllShow;// (string, optional): 内容 ,

@property (nonatomic, assign) BOOL isNeedShowAllContent;

@end

NS_ASSUME_NONNULL_END
