//
//  THKOnlineDesignHouseListModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignHouseListItemModel :NSObject
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * community_name;
@property (nonatomic , copy) NSString              * structure;
@property (nonatomic , copy) NSString              * building_area;
@property (nonatomic , copy) NSString              * image;

@end


@interface THKOnlineDesignHouseListModel : NSObject
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , strong) NSArray <THKOnlineDesignHouseListItemModel *>              * items;
@end

NS_ASSUME_NONNULL_END
