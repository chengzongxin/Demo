//
//  THKDecorationToDoStageView.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKView.h"
#import "THKDecorationToDoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoStageView : THKView

@property (nonatomic, strong) NSArray <THKDecorationUpcomingModel *> *model;

@property (nonatomic, copy) void (^tapItem)(NSInteger index);

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) void (^exposeItem)(NSInteger index);

- (void)setGradientPercent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
