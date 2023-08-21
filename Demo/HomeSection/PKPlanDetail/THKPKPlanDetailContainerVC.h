//
//  THKPKPlanDetailContainerVC.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2023/8/18.
//  Copyright © 2023 binxun. All rights reserved.
//

#import "THKViewController.h"
#import "THKPKPlanDetailContainerVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKPKPlanDetailContainerVC : THKViewController<TRouterProtocol>


@property (nonatomic, strong, readonly) THKPKPlanDetailContainerVM *viewModel;

@end

NS_ASSUME_NONNULL_END
