//
//  THKOnlineDesignUploadHouseVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"
#import "THKOnlineDesignHouseStyleTagRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignUploadHouseVM : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestHoustTagCommand;

@property (nonatomic, strong, readonly) NSArray <THKOnlineDesignHouseStyleTagModel *>*styleTags;

@end

NS_ASSUME_NONNULL_END
