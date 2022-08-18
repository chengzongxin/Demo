//
//  THKOnlineDesignModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignModel.h"

@implementation THKOnlineDesignModel

@end

@implementation THKOnlineDesignSectionModel

@end

@implementation THKOnlineDesignItemModel

- (NSArray *)items{
    switch (self.type) {
        case THKOnlineDesignItemDataType_HouseType:
        case THKOnlineDesignItemDataType_HouseTypeModel:
        {
            return @[self.houseType?:@[]];
        }
            break;
        case THKOnlineDesignItemDataType_HouseStyle:
        {
            return self.houseStyles;
        }
            break;
        case THKOnlineDesignItemDataType_HouseBudget:
        {
            return self.houseBudget;
        }
            break;
        case THKOnlineDesignItemDataType_HouseDemand:
        {
            return @[self.demandModel?:@[]];
        }
            break;
            
            
        default:
            return nil;
            break;
    }
}

@end

@implementation THKOnlineDesignItemHouseTypeModel

@end

@implementation THKOnlineDesignItemDemandModel

@end
