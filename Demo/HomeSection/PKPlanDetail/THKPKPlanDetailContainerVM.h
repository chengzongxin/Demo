//
//  THKPKPlanDetailContainerVM.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2023/8/18.
//  Copyright © 2023 binxun. All rights reserved.
//

#import "THKViewModel.h"
#import "THKDynamicTabsManager.h"
#import "THKDynamicTabsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKPKPlanDetailContainerVM : THKViewModel

@property (nonatomic, copy, readonly) NSArray<THKDynamicTabsModel *> *segmentTitles;

@end

NS_ASSUME_NONNULL_END
