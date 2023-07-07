//
//  THKGraphicCollectionRequest.h
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKCommonBaseRequest.h"
#import "THKGraphicCollectionResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicCollectionRequest : THKCommonBaseRequest

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger size;

@end

NS_ASSUME_NONNULL_END
