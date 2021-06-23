//
//  THKPersonalDesignerResponse.h
//  HouseKeeper
//
//  Created by cl w on 2021/2/4.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKResponse.h"
#import "THKIdentityTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKPersonalDesignerConfigResponse : THKResponse

@property (nonatomic, strong) THKIdentityTypeModel *data;

@end

NS_ASSUME_NONNULL_END
