//
//  TMCardComponentCellExposeFlagDataProtocol.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMCardComponentMacro.h"

NS_ASSUME_NONNULL_BEGIN

#define TMCardComponentCellExposeFlagDataProtocolSyntheSizeAutoImplementation \
TMCardComponentProtocolSyntheSize(exposeFlag) \

/**天眼暴光的标记，用于防止重复上报*/
@protocol TMCardComponentCellExposeFlagDataProtocol <NSObject>

@property (nonatomic, assign)BOOL exposeFlag;///< cell暴光相关标记值---天眼上报用

@end

NS_ASSUME_NONNULL_END
