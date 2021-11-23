//
//  THKSelectMaterialVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKViewController.h"
#import "THKSelectMaterialVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKSelectMaterialVC : THKViewController<TRouterProtocol>

@property (nonatomic, strong, readonly) THKSelectMaterialVM *viewModel;

@end

NS_ASSUME_NONNULL_END
