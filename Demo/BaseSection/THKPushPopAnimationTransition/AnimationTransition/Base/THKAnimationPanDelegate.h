//
//  THKAnimationPanDelegate.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKAnimationPanDelegate : NSObject

+(THKAnimationPanDelegate *)setPanDelegate:(UIPanGestureRecognizer *)pan scrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
