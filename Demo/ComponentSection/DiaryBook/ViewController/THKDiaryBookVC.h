//
//  THKDiaryBookVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import "THKViewController.h"
#import "THKDiaryBookVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKDiaryBookVC : THKViewController

@property (nonatomic, strong, readonly) THKDiaryBookVM *viewModel;

@end

NS_ASSUME_NONNULL_END
