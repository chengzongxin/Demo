//
//  THKLoadingAnimationDecorate.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THKComponentLayer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol THKLoadingAnimationDecorate <NSObject>

// layer装饰期
- (void)addAnimationWithLayers:(NSArray <THKComponentLayer *> *)layers;

@end

NS_ASSUME_NONNULL_END
