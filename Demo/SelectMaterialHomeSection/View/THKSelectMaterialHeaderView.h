//
//  THKSelectMaterialHeaderView.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKView.h"
#import "THKSelectMaterialHeaderViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKSelectMaterialHeaderView : THKView

@property (nonatomic, strong, readonly) THKSelectMaterialHeaderViewModel *viewModel;


@property (nonatomic, strong, readonly) RACSubject *tapCoverSubject;

@property (nonatomic, strong, readonly) RACSubject *tapEntrySubject;

@end

NS_ASSUME_NONNULL_END
