//
//  THKCalcConfigResponse.h
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKResponse.h"
#import "THKCalcQuataConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKCalcConfigResponse : THKResponse

@property (nonatomic, strong) THKCalcQuataConfigModel *data;

@end

NS_ASSUME_NONNULL_END
