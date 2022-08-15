//
//  THKOnlineDesignModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import <Foundation/Foundation.h>
#import "THKRecordTool.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKOnlineDesignItemDataType_None = 0,
    THKOnlineDesignItemDataType_HouseType,
    THKOnlineDesignItemDataType_HouseStyle,
    THKOnlineDesignItemDataType_HouseBudget,
    THKOnlineDesignItemDataType_HouseDemand,
} THKOnlineDesignItemDataType;

@class THKOnlineDesignItemModel;

@interface THKOnlineDesignModel : NSObject

@end

@interface THKOnlineDesignSectionModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) THKOnlineDesignItemModel *item;

@end


@interface THKOnlineDesignItemModel : NSObject

@property (nonatomic, assign) THKOnlineDesignItemDataType type;

@property (nonatomic, strong) Class cellClass;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong) NSString *picUrl;

@property (nonatomic, strong) NSString *houseAreaName;

@property (nonatomic, strong) NSArray <NSString *> *houseStyles;

@property (nonatomic, strong) NSArray <NSString *> *houseBudget;

@property (nonatomic, strong) NSArray <THKAudioDescription *> *demandDesc;
///  本地处理
@property (nonatomic, strong) NSArray <NSString *> *items;

@end


NS_ASSUME_NONNULL_END
