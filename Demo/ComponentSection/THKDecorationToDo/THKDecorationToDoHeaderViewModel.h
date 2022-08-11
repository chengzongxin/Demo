//
//  THKDecorationToDoHeaderViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKViewModel.h"
#import "THKDecorationToDoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoHeaderViewModel : THKViewModel

@property (nonatomic, strong, readonly) NSArray <THKDecorationUpcomingModel *> *model;

@property (nonatomic, strong) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
