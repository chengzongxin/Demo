//
//  THKOnlineDesignHouseListVC.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKViewController.h"
#import "THKOnlineDesignHouseTypeListVM.h"
#import "THKOnlineDesignModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignHouseTypeListVC : THKViewController

@property (nonatomic, strong, readonly) THKOnlineDesignHouseTypeListVM *viewModel;

@property (nonatomic, copy) void (^selectHouseTypeBlock)(THKOnlineDesignItemHouseTypeModel * houseTypeMdel);

@end

NS_ASSUME_NONNULL_END
