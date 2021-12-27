//
//  THKMaterialTabEntranceModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import "THKMaterialTabEntranceModel.h"

@implementation THKMaterialTabEntranceModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"banner":MaterialTabBannerModel.class,
        @"majorEntrances":MaterialTabMajorEntrancesModel.class,
        @"minorEntrances":MaterialTabMinorEntrancesModel.class,
        @"tabs":THKDynamicTabsModel.class
    };
}
@end

@implementation MaterialTabBannerModel

@end

@implementation MaterialTabMajorEntrancesModel

@end

@implementation MaterialTabMinorEntrancesModel

@end

@implementation MaterialTabSubtabsModel

@end
