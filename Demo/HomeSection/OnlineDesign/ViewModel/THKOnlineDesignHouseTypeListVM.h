//
//  THKOnlineDesignHouseListVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"
#import "THKOnlineDesignSearchHouseRequest.h"
#import "THKStateMechanismsViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignHouseTypeListVM : THKStateMechanismsViewModel

@property (nonatomic, strong) NSString *wd;

//@property (nonatomic, strong) THKRequestCommand *requestCommand;

@end

NS_ASSUME_NONNULL_END
