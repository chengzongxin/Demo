//
//  THKHouseCardConfigResponse.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKResponse.h"
#import "THKHouseCardConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKHouseCardConfigResponse : THKResponse

@property (nonatomic, strong) THKHouseCardConfigModel *data;

@end

NS_ASSUME_NONNULL_END
