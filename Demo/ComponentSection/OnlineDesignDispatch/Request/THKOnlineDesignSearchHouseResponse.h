//
//  THKOnlineDesignSearchHouseResponse.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKResponse.h"
#import "THKOnlineDesignHouseListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSearchHouseResponse : THKResponse

@property (nonatomic, strong) THKOnlineDesignHouseListModel *data;

@end

NS_ASSUME_NONNULL_END
