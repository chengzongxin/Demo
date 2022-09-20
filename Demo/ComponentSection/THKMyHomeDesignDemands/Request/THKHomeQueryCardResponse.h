//
//  THKHomeQueryCardResponse.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKResponse.h"
#import "THKHomeQueryCardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKHomeQueryCardResponse : THKResponse

@property (nonatomic, strong) THKHomeQueryCardModel *data;

@end

NS_ASSUME_NONNULL_END
