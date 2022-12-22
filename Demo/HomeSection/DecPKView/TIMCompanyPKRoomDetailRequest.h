//
//  TIMCompanyPKRoomDetailRequest.h
//  Demo
//
//  Created by Joe.cheng on 2022/12/22.
//

#import "THKBaseRequest.h"
#import "THKDecPKCompanyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TIMCompanyPKRoomDetailRequest : THKBaseRequest

@end

@interface TIMCompanyPKRoomDetailResponse : THKResponse

@property (nonatomic, strong) THKDecPKModel *data;

@end

NS_ASSUME_NONNULL_END
