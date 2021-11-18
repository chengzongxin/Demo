//
//  DynamicTabLevelVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import "THKViewController.h"
#import "DynamicTabLevelVM.h"
#import "YNPageViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface DynamicTabLevelVC : THKViewController <TRouterProtocol>


@property (nonatomic, strong, readonly) DynamicTabLevelVM *viewModel;
@end

NS_ASSUME_NONNULL_END
