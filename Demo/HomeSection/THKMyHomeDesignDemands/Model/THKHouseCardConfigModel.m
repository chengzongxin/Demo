//
//  THKHouseCardConfigModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKHouseCardConfigModel.h"

@implementation THKHouseCardConfigDecorateTypeListItem
@end


@implementation THKHouseCardConfigHouseListItem
@end


@implementation THKHouseCardConfigStyleListItem
@end


@implementation THKHouseCardConfigBudgetListItem
@end


@implementation THKHouseCardConfigPopulationTypeListItem
@end


@implementation THKHouseCardConfigModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"decorateTypeList":THKHouseCardConfigDecorateTypeListItem.class,
             @"houseList":THKHouseCardConfigHouseListItem.class,
             @"styleList":THKHouseCardConfigStyleListItem.class,
             @"budgetList":THKHouseCardConfigBudgetListItem.class,
             @"populationTypeList":THKHouseCardConfigPopulationTypeListItem.class,
    };
}

@end
