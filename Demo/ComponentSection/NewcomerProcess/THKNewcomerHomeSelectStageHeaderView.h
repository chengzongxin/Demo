//
//  THKNewcomerHomeSelectStageHeaderView.h
//  Demo
//
//  Created by Joe.cheng on 2021/12/7.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKNewcomerHomeSelectStageHeaderView : THKView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *contentLabel;
@property (nonatomic, strong, readonly) UIButton *unfoldBtn;

@property (nonatomic, copy) void (^tapItem)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
