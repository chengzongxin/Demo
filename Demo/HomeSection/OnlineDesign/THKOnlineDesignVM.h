//
//  THKOnlineDesignVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"
#import "THKOnlineDesignModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignVM : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestCommand;

@property (nonatomic, strong, readonly) NSArray <THKOnlineDesignSectionModel *> *datas;

@end

NS_ASSUME_NONNULL_END
