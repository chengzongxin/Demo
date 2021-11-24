//
//  THKSelectMaterialCommunicationVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/24.
//

#import "THKViewController.h"
#import "THKSelectMaterialCommunicationVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKSelectMaterialCommunicationVC : THKViewController<TRouterProtocol>
@property (nonatomic, strong, readonly) THKSelectMaterialCommunicationVM *viewModel;
@end

NS_ASSUME_NONNULL_END
