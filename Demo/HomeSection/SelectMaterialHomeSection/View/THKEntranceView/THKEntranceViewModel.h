//
//  THKEntranceViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKViewModel.h"
#import "THKMaterialTabEntranceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKEntranceViewModel : THKViewModel

@property (nonatomic, assign) BOOL isFirstLevelEntrance;

@property (nonatomic , strong)  NSArray <MaterialTabMajorEntrancesModel *> *entranceList;

@end

NS_ASSUME_NONNULL_END
