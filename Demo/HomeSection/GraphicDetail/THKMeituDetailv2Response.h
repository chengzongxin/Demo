//
//  THKMeituDetailv2Response.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKResponse.h"
#import "THKGraphicDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKMeituDetailv2Response : THKResponse

@property (nonatomic, strong) THKGraphicDetailModel *data;

@end

NS_ASSUME_NONNULL_END
