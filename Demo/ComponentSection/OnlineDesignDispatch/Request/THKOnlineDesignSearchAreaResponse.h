//
//  THKOnlineDesignSearchAreaResponse.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKResponse.h"
#import "THKOnlineDesignAreaListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSearchAreaResponse : THKResponse

@property (nonatomic, strong) THKOnlineDesignAreaListModel *data;

@end

NS_ASSUME_NONNULL_END
