//
//  THKGraphicDetailStageView.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKView.h"
#import "THKGraphicDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicDetailStageView : THKView

@property (nonatomic, strong) NSArray <THKGraphicDetailContentListItem *> *model;

@property (nonatomic, copy) void (^tapItem)(NSInteger index);

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) void (^exposeItem)(NSInteger index);

- (void)setGradientPercent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
