//
//  THKHouseCardConfigModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKHouseCardConfigDecorateTypeListItem :NSObject
@property (nonatomic , copy) NSString              * decorateTypeName;
@property (nonatomic , assign) NSInteger              decorateTypeId;

@end


@interface THKHouseCardConfigHouseListItem :NSObject
@property (nonatomic , copy) NSString              * houseTag;
@property (nonatomic , copy) NSString              * name;

@end


@interface THKHouseCardConfigStyleListItem :NSObject
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * wholeCode;

@end


@interface THKHouseCardConfigBudgetListItem :NSObject
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * wholeCode;

@end


@interface THKHouseCardConfigPopulationTypeListItem :NSObject
@property (nonatomic , assign) NSInteger              populationTypeId;
@property (nonatomic , copy) NSString              * populationTypeName;

@end


@interface THKHouseCardConfigModel : NSObject

@property (nonatomic , strong) NSArray <THKHouseCardConfigDecorateTypeListItem *>              * decorateTypeList;
@property (nonatomic , strong) NSArray <THKHouseCardConfigHouseListItem *>              * houseList;
@property (nonatomic , strong) NSArray <THKHouseCardConfigStyleListItem *>              * styleList;
@property (nonatomic , strong) NSArray <THKHouseCardConfigBudgetListItem *>              * budgetList;
@property (nonatomic , strong) NSArray <THKHouseCardConfigPopulationTypeListItem *>              * populationTypeList;

@end

NS_ASSUME_NONNULL_END
