//
//  THKLoadingAnimationView.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKView.h"
#import "THKComponentLayer.h"
#import "THKLoadingAnimationDecorate.h"
#import "THKTextComponentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKLoadingAnimationView : THKView

@property (nonatomic, strong) NSMutableArray <THKComponentLayer *> *layers;

@property (nonatomic, strong) id <THKLoadingAnimationDecorate> decorate;

@end

NS_ASSUME_NONNULL_END
