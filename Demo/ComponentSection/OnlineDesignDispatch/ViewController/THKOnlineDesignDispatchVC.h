//
//  THKOnlineDesignVC.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKViewController.h"
#import "THKOnlineDesignDispatchVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignDispatchVC : THKViewController<TRouterProtocol>

@property (nonatomic, strong, readonly) THKOnlineDesignDispatchVM *viewModel;

@end

NS_ASSUME_NONNULL_END
