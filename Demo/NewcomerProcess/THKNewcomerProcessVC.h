//
//  THKNewcomerProcessVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKViewController.h"
#import "THKNewcomerProcessVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKNewcomerProcessVC : THKViewController

@property (nonatomic, strong, readonly) THKNewcomerProcessVM *viewModel;

- (void)showInSomeRootVC:(UIViewController *)rootVC;

@property (nonatomic, copy) void (^dismissBlock)(id data);

@end

NS_ASSUME_NONNULL_END
