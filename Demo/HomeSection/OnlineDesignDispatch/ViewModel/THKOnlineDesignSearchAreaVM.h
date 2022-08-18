//
//  THKOnlineDesignSearchAreaVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"
#import "THKOnlineDesignSearchAreaRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSearchAreaVM : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestCommand;

@end

NS_ASSUME_NONNULL_END
