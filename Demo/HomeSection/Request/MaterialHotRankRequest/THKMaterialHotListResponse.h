//
//  THKMaterialHotListResponse.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKResponse.h"

NS_ASSUME_NONNULL_BEGIN

@class THKMaterialHotListModel;
@class THKMaterialHotBrandModel;

@interface THKMaterialHotListResponse : THKResponse

@property (nonatomic, strong) NSArray <THKMaterialHotListModel *> *data;

@end

@interface THKMaterialHotListModel :NSObject
@property (nonatomic , copy) NSString              * cover;
@property (nonatomic , assign) NSInteger              coverHeight;
@property (nonatomic , assign) NSInteger              coverWidth;
@property (nonatomic , strong) NSArray <THKMaterialHotBrandModel *>              * brandList;
@property (nonatomic , copy) NSString              * categoryName;
@property (nonatomic , assign) NSInteger              categoryId;

@end


@interface THKMaterialHotBrandModel :NSObject
@property (nonatomic , copy) NSString              * logoHeight;
@property (nonatomic , assign) NSInteger              uid;
@property (nonatomic , assign) NSInteger              score;
@property (nonatomic , copy) NSString              * brandName;
@property (nonatomic , copy) NSString              * logoWidth;
@property (nonatomic , assign) NSInteger              brandId;
@property (nonatomic , copy) NSString              * logoUrl;
@property (nonatomic , copy) NSString              * headUrl;
@property (nonatomic, assign) BOOL isExposed;

@end


NS_ASSUME_NONNULL_END
