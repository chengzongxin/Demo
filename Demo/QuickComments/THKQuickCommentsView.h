//
//  THKQuickCommentsView.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/22.
//

#import "THKView.h"
#import "THKQuickCommentsViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKQuickCommentsView : THKView

@property (nonatomic, strong, readonly) THKQuickCommentsViewModel *viewModel;

@property (nonatomic, copy) void (^tapItem)(NSString *text);

@end

NS_ASSUME_NONNULL_END
