//
//  THKMyHomeDesignDemandsVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMyHomeDesignDemandsVM : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *configCommand;

@property (nonatomic, strong, readonly) THKRequestCommand *queryCommand;

@property (nonatomic, strong, readonly) THKRequestCommand *editCommand;

@end

NS_ASSUME_NONNULL_END
