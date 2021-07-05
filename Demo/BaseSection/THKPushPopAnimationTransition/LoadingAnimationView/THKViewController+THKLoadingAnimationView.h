//
//  THKViewController+THKLoadingAnimationView.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKViewController.h"
#import "THKLoadingAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKLoadingAnimationViewStyleNone,
    THKLoadingAnimationViewStyleCaseDetail,
    THKLoadingAnimationViewStyleDiaryDetail,
    THKLoadingAnimationViewStyleUGCGraphicDetail,
} THKLoadingAnimationViewStyle;

@interface THKViewController (THKLoadingAnimationView)

@property (nonatomic, strong) THKLoadingAnimationView * _Nullable loadingAnimationView;


- (void)addLoadingAnimationView:(THKLoadingAnimationViewStyle)style insets:(UIEdgeInsets)insets;
- (void)removeLoadingAnimationView;

@end

NS_ASSUME_NONNULL_END
