//
//  THKOnlineDesignHouseListVC.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKViewController.h"
#import "THKOnlineDesignHouseTypeListVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignHouseTypeListVC : THKViewController

@property (nonatomic, copy) void (^selectHouseTypeBlock)(id houseTypeMdel);

@end

NS_ASSUME_NONNULL_END
