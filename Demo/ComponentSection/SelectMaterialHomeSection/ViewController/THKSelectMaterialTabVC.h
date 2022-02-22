//
//  THKSelectMaterialVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKViewController.h"
#import "THKSelectMaterialTabVM.h"
#import "THKDynamicTabsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKSelectMaterialTabVC : THKViewController<TRouterProtocol>

@property (nonatomic, strong, readonly) THKSelectMaterialTabVM *viewModel;

@property (nonatomic, strong, readonly) THKDynamicTabsManager *dynamicTabsManager;

@end

NS_ASSUME_NONNULL_END
