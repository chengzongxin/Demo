//
//  THKOnlineDesignAreaListModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignAreaListDataItem :NSObject
@property (nonatomic , assign) NSInteger              total;
@property (nonatomic , copy) NSString              * community_name;
@property (nonatomic , copy) NSString              * district;
@property (nonatomic , assign) NSInteger              id;

@end

@interface THKOnlineDesignAreaListModel : NSObject


@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , strong) NSArray <THKOnlineDesignAreaListDataItem *>              * items;

@end

NS_ASSUME_NONNULL_END
