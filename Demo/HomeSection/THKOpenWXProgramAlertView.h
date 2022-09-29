//
//  THKOpenWXProgramAlertView.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/29.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOpenWXProgramAlertView : THKView

+ (void)showAlertWithConfirmBlock:(void (^)(THKOpenWXProgramAlertView *alertView))confirmBlock cancelBlock:(void (^)(THKOpenWXProgramAlertView *alertView))cancelBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
