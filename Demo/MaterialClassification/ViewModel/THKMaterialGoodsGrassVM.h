//
//  THKMaterialGoodsGrassVM.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/6/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKViewModel.h"
#import "THKStateMechanismsViewModel.h"
#import "THKMaterialRecommendGoodsGrassRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialGoodsGrassVM : THKStateMechanismsViewModel

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger subCategoryId;

@property (nonatomic, strong) NSString *categoryName;

@end

NS_ASSUME_NONNULL_END
