//
//  THKOnlineDesignModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import <Foundation/Foundation.h>
#import "THKRecordTool.h"
#import "THKOnlineDesignHomeEditRequest.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKOnlineDesignItemDataType_None = 0,
    THKOnlineDesignItemDataType_HouseType,
    THKOnlineDesignItemDataType_HouseStyle,
    THKOnlineDesignItemDataType_HouseBudget,
    THKOnlineDesignItemDataType_HouseDemand,
    THKOnlineDesignItemDataType_HouseTypeModel,
} THKOnlineDesignItemDataType;

@class THKOnlineDesignItemModel,THKOnlineDesignItemHouseTypeModel,THKOnlineDesignItemDemandModel;

@interface THKOnlineDesignModel : NSObject

@end

@interface THKOnlineDesignSectionModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) THKOnlineDesignItemModel *item;

@property (nonatomic, assign) BOOL isFold;

@property (nonatomic, assign) NSInteger selectIdx;

@end


@interface THKOnlineDesignItemModel : NSObject

@property (nonatomic, assign) THKOnlineDesignItemDataType type;

@property (nonatomic, strong) Class cellClass;

@property (nonatomic, assign) CGSize itemSize;

// 对应数据
@property (nonatomic, strong) THKOnlineDesignItemHouseTypeModel *houseType;

//@property (nonatomic, strong) NSString *houseAreaName;

@property (nonatomic, strong) NSArray <NSString *> *houseStyles;

@property (nonatomic, strong) NSArray <NSString *> *houseBudget;

@property (nonatomic, strong) THKOnlineDesignItemDemandModel *demandModel;
///  本地处理
@property (nonatomic, strong) NSArray *items;

@end

@interface THKOnlineDesignItemHouseTypeModel : NSObject
// 图片链接
@property (nonatomic, strong) NSArray <THKOnlineDesignHomeEditPlanImgList *> *planImgList;
// 小区名
@property (nonatomic, strong) NSString *houseArea;
// 户型
@property (nonatomic, strong) NSString *houseType;
// 建筑面积
@property (nonatomic, assign) NSInteger buildArea;
// 本地路径
@property (nonatomic, strong) NSArray <NSString *> *imageFilePath;
// 户型信息全码
@property (nonatomic, strong) NSString *houseTag;
/// 来源 0-默认 1-用户手动新增 2-3d
@property (nonatomic, assign) NSString *planSource;

/// 来源id
@property (nonatomic, assign) NSInteger planSourceId;

@end

@interface THKOnlineDesignItemDemandModel : NSObject

@property (nonatomic, strong) NSArray <THKAudioDescription *> *demandDesc;

@property (nonatomic, strong) NSString *demandPlacehoder;

@end


NS_ASSUME_NONNULL_END
