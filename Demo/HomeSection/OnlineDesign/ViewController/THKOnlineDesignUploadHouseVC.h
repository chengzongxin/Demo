//
//  THKOnlineDesignUploadHouseVC.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKViewController.h"
#import "THKOnlineDesignUploadHouseVM.h"
#import "THKOnlineDesignModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignUploadHouseVC : THKViewController

@property (nonatomic, strong, readonly) THKOnlineDesignUploadHouseVM *viewModel;

@property (nonatomic, copy) void (^selectHouseTypeBlock)(THKOnlineDesignItemHouseTypeModel *houseTypeMdel);

@end

NS_ASSUME_NONNULL_END
