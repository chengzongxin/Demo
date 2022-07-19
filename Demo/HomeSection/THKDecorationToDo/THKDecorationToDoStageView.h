//
//  THKDecorationToDoStageView.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoStageView : THKView

@property (nonatomic, copy) void (^tapItem)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
