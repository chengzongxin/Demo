//
//  THKGraphicCollectionVC.h
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKViewController.h"
#import "THKPresentViewController.h"
#import "THKGraphicCollectionVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicCollectionVC : THKPresentViewController

@property (nonatomic, strong, readonly) THKGraphicCollectionVM *viewModel;

@end

NS_ASSUME_NONNULL_END
