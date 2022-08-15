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

- (NSArray<NSString *> *)items{
    switch (self.type) {
        case THKOnlineDesignItemDataType_HouseType:
        {
            return @[self.picUrl];
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
            return @[self.demandDesc?:@[]];
        }
            break;
            
            
        default:
            return nil;
            break;
    }
}

@end
