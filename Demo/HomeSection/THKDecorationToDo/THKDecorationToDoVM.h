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

@property (nonatomic, strong ,readonly) RACSubject *emptySignal;

@property (nonatomic, strong, readonly) RACSubject *nodataSignal;

@property (nonatomic, strong, readonly) THKRequestCommand *editCommand;
//
//@property (nonatomic, strong, readonly) THKRequestCommand *listCommand;

@end

NS_ASSUME_NONNULL_END
