//
//  THKMaterialRecommendRankVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKStateMechanismsViewModel.h"
#import "THKMaterialRecommendRankRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialRecommendRankVM : THKStateMechanismsViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestCommand;

@property (nonatomic, strong, readonly, nullable) NSArray *data;


/// DEBUG Datas
//@property (nonatomic, strong, readonly) NSArray <NSArray *> *headerTitles;
//@property (nonatomic, strong, readonly) NSArray <NSArray *> *icons;
//@property (nonatomic, strong, readonly) NSArray <NSArray *> *titles;
//@property (nonatomic, strong, readonly) NSArray <NSArray *> *subtitles;

@end

NS_ASSUME_NONNULL_END
