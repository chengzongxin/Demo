//
//  THKMaterialHotListRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialHotListRequest : THKBaseRequest
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, assign)   NSInteger size;
@end

NS_ASSUME_NONNULL_END
