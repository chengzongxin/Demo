//
//  THKOnlineDesignSearchHouseRequest.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKBaseRequest.h"
#import "THKOnlineDesignSearchHouseResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSearchHouseRequest : THKBaseRequest

@property (nonatomic, strong) NSString *wd;

@property (nonatomic, assign) NSInteger city;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger perPage;

@end

NS_ASSUME_NONNULL_END
