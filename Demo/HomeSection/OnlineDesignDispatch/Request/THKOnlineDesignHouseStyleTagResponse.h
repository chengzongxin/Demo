//
//  THKOnlineDesignHouseStyleTagResponse.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/17.
//

#import "THKResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignHouseStyleTagModel : NSObject

@property (nonatomic, strong) NSString *houseTag;

@property (nonatomic, strong) NSString *name;

@end

@interface THKOnlineDesignHouseStyleTagResponse : THKResponse

@property (nonatomic, strong) NSArray <THKOnlineDesignHouseStyleTagModel *> *data;

@end

NS_ASSUME_NONNULL_END
