//
//  THKOnlineDesignVC.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKViewController.h"
#import "THKOnlineDesignVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignVC : THKViewController<TRouterProtocol>

@property (nonatomic, strong, readonly) THKOnlineDesignVM *viewModel;

@end

NS_ASSUME_NONNULL_END
