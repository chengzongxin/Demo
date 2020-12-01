//
//  THKUserCenterHeaderViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2020/12/1.
//

#import "THKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKUserCenterHeaderViewModel : THKViewModel

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *tagName;
@property (nonatomic, strong, readonly) NSString *signature;
@property (nonatomic, strong, readonly) NSString *followText;
@property (nonatomic, strong, readonly) NSString *fansText;
@property (nonatomic, strong, readonly) NSString *befollowText;

@end

NS_ASSUME_NONNULL_END
