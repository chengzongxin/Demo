//
//  THKHomeEditCardRequest.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKBaseRequest.h"
#import "THKHomeEditCardResponse.h"
#import "THKOnlineDesignHomeEditRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKHomeEditCardRequest : THKBaseRequest



/// 面积(单位m²)
@property (nonatomic, assign) NSInteger area;

/// 栏目列表
@property (nonatomic, strong) NSArray <THKOnlineDesignHomeEditColumnList *> *columnList;
//@property (nonatomic, strong) NSArray <THKOnlineDesignHomeEditIdList *> *idList;

/// 小区名称
@property (nonatomic, strong) NSString *communityName;

/// 户型信息全码
@property (nonatomic, strong) NSString *houseTag;

/// 主键id
@property (nonatomic, assign) NSInteger id;

/// 户型图信息
@property (nonatomic, strong) NSArray <THKOnlineDesignHomeEditPlanImgList *>*planImgList;

/// 语音信息列表
@property (nonatomic, strong) NSArray <THKOnlineDesignHomeEditRecordingInfoList *>*recordingInfoList;

/// 需求描述
@property (nonatomic, strong) NSString *requirementDesc;

/// 来源 0-默认 1-用户手动新增 2-3d
@property (nonatomic, assign) NSString *planSource;

/// 来源id
@property (nonatomic, assign) NSInteger planSourceId;

//户型信息 3室2厅
@property (nonatomic, strong) NSString *houseInfo;


@property (nonatomic, assign) NSInteger lat;

@property (nonatomic, assign) NSInteger lng;

@property (nonatomic, assign) NSInteger planCityId;

@property (nonatomic, assign) NSInteger planTownId;

////房屋面积
//@property (nonatomic, assign) NSInteger area;
//
////装修预算全码
//@property (nonatomic, strong) NSString *budgetTag;
//
////小区名称
//@property (nonatomic, strong) NSString *communityName;
//
//装修方式
@property (nonatomic, assign) NSInteger decorateType;
//
////房屋户型全码
//@property (nonatomic, strong) NSString *houseTag;
//
//居住人口
@property (nonatomic, assign) NSInteger populationType;
//
////特殊需求
//@property (nonatomic, strong) NSString *requirementDesc;
//
////装修风格全码
//@property (nonatomic, strong) NSString *styleTag;


- (void)setStyleCode:(NSString *)code;

- (void)setBudgetCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
