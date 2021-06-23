//
//  THKMaterialHotRankVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialHotRankVM : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestCommand;

@end

NS_ASSUME_NONNULL_END
