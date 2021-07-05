//
//  THKMaterialClassificationViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKViewModel.h"
#import "THKMaterialRecommendRankRequest.h"
#import "THKRequestCommand.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialClassificationVM : THKViewModel
/// 主分类编号
@property (nonatomic, assign) NSInteger mainCategoryId;
/// 子分类编号 主页进来不传 全部分类页点击子分类传
@property (nonatomic, assign) NSInteger subCategoryId;

@property (nonatomic, strong, readonly) THKRequestCommand *requestCMD;

@end

NS_ASSUME_NONNULL_END
