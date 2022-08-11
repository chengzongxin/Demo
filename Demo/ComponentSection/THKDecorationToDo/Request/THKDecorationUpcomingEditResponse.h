//
//  THKDecorationUpcomingEditResponse.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/20.
//

#import "THKResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationUpcomingEditModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSString *desc;

@end

@interface THKDecorationUpcomingEditResponse : THKResponse

@property (nonatomic, strong) THKDecorationUpcomingEditModel *data;

@end

NS_ASSUME_NONNULL_END
