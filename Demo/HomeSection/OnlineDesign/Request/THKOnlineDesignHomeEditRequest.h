//
//  THKOnlineDesignHomeEditRequest.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/17.
//

#import "THKBaseRequest.h"
#import "THKOnlineDesignHomeEditResponse.h"
#import "THKOnlineDesignHomeConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignHomeEditRequest : THKBaseRequest


/// 面积(单位m²)
@property (nonatomic, assign) NSInteger area;

/// 栏目列表
@property (nonatomic, strong) NSArray <THKOnlineDesignHomeConfigColumnList *> *columnList;

/// 小区名称
@property (nonatomic, strong) NSString *communityName;

/// 户型信息全码
@property (nonatomic, strong) NSString *houseTag;

/// 主键id
@property (nonatomic, assign) NSInteger id;

/// 户型图信息
@property (nonatomic, strong) NSArray *planImgList;

/// 语音信息列表
@property (nonatomic, strong) NSArray *recordingInfoList;

/// 需求描述
@property (nonatomic, strong) NSString *requirementDesc;

/// 来源 0-默认 1-用户手动新增 2-3d
@property (nonatomic, assign) NSString *planSource;

/// 来源id
@property (nonatomic, assign) NSInteger planSourceId;

@end

NS_ASSUME_NONNULL_END
