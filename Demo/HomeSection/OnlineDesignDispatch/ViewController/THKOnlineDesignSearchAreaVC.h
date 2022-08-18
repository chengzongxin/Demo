//
//  THKOnlineDesignSearchAreaVC.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKViewController.h"
#import "THKOnlineDesignSearchAreaVM.h"
#import "THKOnlineDesignModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSearchAreaVC : THKViewController

@property (nonatomic, strong, readonly) THKOnlineDesignSearchAreaVM *viewModel;

@property (nonatomic, copy) void (^selectHouseTypeBlock)(THKOnlineDesignItemHouseTypeModel *houseTypeMdel);

@end

NS_ASSUME_NONNULL_END
