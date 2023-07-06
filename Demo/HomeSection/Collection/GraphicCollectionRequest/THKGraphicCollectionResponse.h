//
//  THKGraphicCollectionResponse.h
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKResponse.h"

NS_ASSUME_NONNULL_BEGIN


@interface THKGraphicCollectionModelList : NSObject

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) NSInteger thumbupNum;

@property (nonatomic, assign) NSInteger likeNum;

@property (nonatomic, assign) NSInteger commentNum;


@end


@interface THKGraphicCollectionModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *brief;

@property (nonatomic, strong) NSArray <THKGraphicCollectionModelList *> *list;

@end

@interface THKGraphicCollectionResponse : THKResponse

@property (nonatomic, strong) THKGraphicCollectionModel *data;

@end

NS_ASSUME_NONNULL_END
