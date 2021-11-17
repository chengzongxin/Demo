//
//  DynamicTabVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/17.
//

#import "THKViewController.h"
#import "DynamicTabVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicTabVC : THKViewController

@property (nonatomic, strong, readonly) DynamicTabVM *viewModel;

@end

NS_ASSUME_NONNULL_END
