//
//  THKPersonalDesignerConfigRequest.h
//  HouseKeeper
//
//  Created by cl w on 2021/2/4.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKBaseRequest.h"
#import "THKPersonalDesignerConfigResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKPersonalDesignerConfigRequest : THKBaseRequest

/// 0-正常访问，1-固定ip访问
@property (nonatomic, assign) NSInteger accessType;

+(NSString*)thk_requestPath;

@end

NS_ASSUME_NONNULL_END
