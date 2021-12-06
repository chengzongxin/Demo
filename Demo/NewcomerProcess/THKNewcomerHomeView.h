//
//  THKNewcomerHomeView.h
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKView.h"
#import "THKNewcomerHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKNewcomerHomeView : THKView

@property (nonatomic, strong, readonly) THKNewcomerHomeViewModel *viewModel;

@property (nonatomic, copy) void (^tapItem)(NSInteger idx,UILabel *label);

@end

NS_ASSUME_NONNULL_END
