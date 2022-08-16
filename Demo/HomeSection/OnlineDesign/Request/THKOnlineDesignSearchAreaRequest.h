//
//  THKOnlineDesignSearchAreaRequest.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKBaseRequest.h"
#import "THKOnlineDesignSearchAreaResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSearchAreaRequest : THKBaseRequest

@property (nonatomic, assign) NSInteger city;

@property (nonatomic, strong) NSString *wd;

@end

NS_ASSUME_NONNULL_END
