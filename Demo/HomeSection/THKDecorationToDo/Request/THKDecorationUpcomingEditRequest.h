//
//  THKDecorationUpcomingEditRequest.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/20.
//

#import "THKBaseRequest.h"
#import "THKDecorationUpcomingEditResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationUpcomingEditRequest : THKBaseRequest

@property (nonatomic, assign) NSInteger childId;  /// < 子项id
@property (nonatomic, strong) NSString *todoStatus;  /// < 待办状态 0-未办理 1-已办理

@end

NS_ASSUME_NONNULL_END
