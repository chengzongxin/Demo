//
//  THKCalcQuataConfigModel.h
//  Demo
//
//  Created by 程宗鑫 on 2022/10/13.
//

#import <Foundation/Foundation.h>

@interface THKCalcQuataConfigHouseBaseListItem : NSObject
@property (nonatomic , assign) NSInteger              itemId;
@property (nonatomic , copy) NSString              * itemName;
@end

NS_ASSUME_NONNULL_BEGIN
@interface THKCalcQuataConfigHouseTypeListItem :NSObject
@property (nonatomic , assign) NSInteger              chu;
@property (nonatomic , assign) NSInteger              maxArea;
@property (nonatomic , assign) NSInteger              ting;
@property (nonatomic , assign) NSInteger              wei;
@property (nonatomic , assign) NSInteger              fang;
@property (nonatomic , assign) NSInteger              houseTypeId;
@property (nonatomic , assign) NSInteger              yangtai;
@property (nonatomic , assign) NSInteger              minArea;

@property (nonatomic, strong, readonly) NSString *houseTypeName;

@end


@interface THKCalcQuataConfigWeiListItem :THKCalcQuataConfigHouseBaseListItem
@end


@interface THKCalcQuataConfigTingListItem :THKCalcQuataConfigHouseBaseListItem
@end


@interface THKCalcQuataConfigYangtaiListItem :THKCalcQuataConfigHouseBaseListItem
@end


@interface THKCalcQuataConfigFangListItem :THKCalcQuataConfigHouseBaseListItem
@end


@interface THKCalcQuataConfigChuListItem :THKCalcQuataConfigHouseBaseListItem

@end


@interface THKCalcQuataConfigTownListItem :NSObject
@property (nonatomic , copy) NSString              * townName;
@property (nonatomic , assign) NSInteger              townId;

@end


@interface THKCalcQuataConfigCityListItem :NSObject
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , assign) NSInteger              cityId;
@property (nonatomic , strong) NSArray <THKCalcQuataConfigTownListItem *>              * townList;

@end

@interface THKCalcQuataConfigModel : NSObject
@property (nonatomic , assign) NSInteger              defaultArea;
@property (nonatomic , strong) NSArray <THKCalcQuataConfigHouseTypeListItem *>              * houseTypeList;
@property (nonatomic , strong) NSArray <THKCalcQuataConfigWeiListItem *>              * weiList;
@property (nonatomic , strong) NSArray <THKCalcQuataConfigTingListItem *>              * tingList;
@property (nonatomic , assign) NSInteger              showPopUp;
@property (nonatomic , strong) NSArray <THKCalcQuataConfigYangtaiListItem *>              * yangtaiList;
@property (nonatomic , strong) NSArray <THKCalcQuataConfigFangListItem *>              * fangList;
@property (nonatomic , strong) NSArray <THKCalcQuataConfigChuListItem *>              * chuList;
@property (nonatomic , strong) NSArray <THKCalcQuataConfigCityListItem *>              * cityList;
@end

NS_ASSUME_NONNULL_END
