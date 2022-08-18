//
//  THKOnlineDesignHomeConfigResponse.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/15.
//

#import "THKResponse.h"
#import "THKOnlineDesignHomeConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignHomeConfigResponse : THKResponse

@property (nonatomic, strong) THKOnlineDesignHomeConfigModel *data;

@end

NS_ASSUME_NONNULL_END
