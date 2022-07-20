//
//  THKDecorationUpcomingListResponse.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/20.
//

#import "THKResponse.h"
#import "THKDecorationToDoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationUpcomingListResponse : THKResponse

@property (nonatomic, strong) NSArray <THKDecorationUpcomingModel *> *data;


@end

NS_ASSUME_NONNULL_END
