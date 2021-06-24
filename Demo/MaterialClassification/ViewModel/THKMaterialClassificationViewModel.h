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

@interface THKMaterialClassificationViewModel : THKViewModel

//@property (nonatomic, strong, readonly) NSString *imgUrl;
//
//@property (nonatomic, strong, readonly) NSString *title;

@property (nonatomic, assign) NSInteger subCategoryId;

@property (nonatomic, strong, readonly) THKRequestCommand *requestCMD;

@end

NS_ASSUME_NONNULL_END
