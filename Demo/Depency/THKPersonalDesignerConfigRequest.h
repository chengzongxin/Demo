//
//  THKPersonalDesignerConfigRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/2/8.
//

#import <Foundation/Foundation.h>
#import "THKPersonalDesignerConfigResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKPersonalDesignerConfigRequest : NSObject
- (RACSignal *)rac_requestSignal;
@end

NS_ASSUME_NONNULL_END
