//
//  THKGraphicCollectionVM.h
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKViewModel.h"
#import "THKStateMechanismsViewModel.h"
#import "THKGraphicCollectionRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicCollectionVM : THKStateMechanismsViewModel

@property (nonatomic, strong, readonly) NSString *titleStr;

@property (nonatomic, strong, readonly) NSString *briefStr;


@end

NS_ASSUME_NONNULL_END
