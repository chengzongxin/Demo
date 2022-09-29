//
//  THKGraphicDetailSpaceView.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/21.
//

#import "THKView.h"
#import "THKGraphicDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicDetailSpaceView : THKView

@property (nonatomic , strong) NSArray <THKGraphicDetailImgInfoItem *>              * model;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) void (^tapItem)(NSInteger index);

@property (nonatomic, copy) void (^exposeItem)(NSInteger index);

- (void)setGradientPercent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
