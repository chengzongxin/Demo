//
//  THKDecorationToDoVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKViewModel.h"
#import "THKStateMechanismsViewModel.h"
#import "THKDecorationToDoModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface THKDecorationToDoVM : THKStateMechanismsViewModel

@property (nonatomic, copy, readonly) NSArray <THKDecorationToDoSection *>*sections;

@end

NS_ASSUME_NONNULL_END
