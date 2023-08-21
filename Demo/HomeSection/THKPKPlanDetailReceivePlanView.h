//
//  THKPKPlanDetailReceivePlanView.h
//  Demo
//
//  Created by Joe.cheng on 2023/8/21.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKPKPlanDetailReceivePlanView : THKView

@property (nonatomic, copy) void (^tapBtn)(UIButton *btn);


@property (nonatomic, copy) void (^tapCloseBtn)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
