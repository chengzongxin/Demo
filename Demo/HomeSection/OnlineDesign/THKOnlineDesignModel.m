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
        case 1:
        {
            return @[self.picUrl];
        }
            break;
        case 2:
        {
            return @[self.houseAreaName];
        }
            break;
        case 3:
        {
            return self.houseStyles;
        }
            break;
        case 4:
        {
            return self.houseBudget;
        }
            break;
        case 5:
        {
            return @[self.demandDesc];
        }
            break;
            
            
        default:
            return nil;
            break;
    }
}

@end
