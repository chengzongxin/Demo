//
//  THKOnlineDesignAreaListModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignAreaListModel.h"

@implementation THKOnlineDesignAreaListDataItem

@end

@implementation THKOnlineDesignAreaListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"items":THKOnlineDesignAreaListDataItem.class};
}

@end
