//
//  THKDecorationToDoHeaderView.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKView.h"
#import "THKDecorationToDoHeaderViewModel.h"
#import "THKDecorationToDoStageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoHeaderView : THKView

@property (nonatomic, strong, readonly) THKDecorationToDoHeaderViewModel *viewModel;

@property (nonatomic, copy) void (^tapItem)(NSInteger index);
@property (nonatomic, copy) void (^exposeItem)(NSInteger index);

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong, readonly) THKDecorationToDoStageView *stageView;
@end

NS_ASSUME_NONNULL_END
