//
//  THKDecorationToDoVC.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKViewController.h"
#import "THKDecorationToDoVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoVC : THKViewController<TRouterProtocol>

@property (nonatomic, strong, readonly) THKDecorationToDoVM *viewModel;

@end

NS_ASSUME_NONNULL_END
