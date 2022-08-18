//
//  THKOnlineDesignHouseListModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignHouseListModel.h"

@implementation THKOnlineDesignHouseListItemModel

@end

@implementation THKOnlineDesignHouseListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"items":THKOnlineDesignHouseListItemModel.class};
}

@end
