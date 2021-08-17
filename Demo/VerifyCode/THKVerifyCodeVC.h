//
//  THKVerifyCodeVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKViewController.h"
#import "THKVerifyCodeVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKVerifyCodeVC : THKViewController

@property (nonatomic, copy) void (^verifySuccess)(NSString *verifyKey,NSString *imgCode);

@end

NS_ASSUME_NONNULL_END
