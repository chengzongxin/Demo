//
//  THKMaterialTabEntranceModel.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import <Foundation/Foundation.h>
#import "THKDynamicTabsModel.h"

NS_ASSUME_NONNULL_BEGIN
@class MaterialTabBannerModel,MaterialTabMajorEntrancesModel,MaterialTabMinorEntrancesModel,MaterialTabSubtabsModel;

@interface THKMaterialTabEntranceModel : NSObject
@property (nonatomic , strong) MaterialTabBannerModel                                   * banner;
@property (nonatomic , strong) NSArray <MaterialTabMajorEntrancesModel *>               * majorEntrances;
@property (nonatomic , strong) NSArray <MaterialTabMinorEntrancesModel *>               * minorEntrances;
@property (nonatomic , strong) NSArray <THKDynamicTabsModel *>                      * tabs;

@end


@interface MaterialTabBannerModel :NSObject
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , assign) NSInteger              brandNum;
@property (nonatomic , assign) NSInteger              realShotNum;
@property (nonatomic , assign) NSInteger              width;
@property (nonatomic , assign) NSInteger              height;

@end

@interface MaterialTabMajorEntrancesModel :NSObject
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , copy) NSString              * subTitle;
@property (nonatomic , assign) NSInteger              width;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * targetUrl;
@property (nonatomic , assign) NSInteger              height;

@end

@interface MaterialTabMinorEntrancesModel :NSObject
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , assign) NSInteger              width;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * targetUrl;
@property (nonatomic , assign) NSInteger              height;

@end

// 不用
@interface MaterialTabSubtabsModel :NSObject
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * targetUrl;

@end






NS_ASSUME_NONNULL_END
