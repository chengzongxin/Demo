//
//  THKNavigationTitleAvatarViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import "THKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKNavigationAvatarTitleViewModel : THKViewModel

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, assign)NSInteger identificationType;///身份
@property (nonatomic, assign)NSInteger subCategory;///二级身份

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) BOOL followStaus;

@end

NS_ASSUME_NONNULL_END
