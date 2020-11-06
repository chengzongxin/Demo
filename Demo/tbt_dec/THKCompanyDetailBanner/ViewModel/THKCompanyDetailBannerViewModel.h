//
//  THKCompanyDetailBannerViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import <Foundation/Foundation.h>
#import "THKViewModel.h"
#import "TDecDetailFirstModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKCompanyDetailBannerViewModel : THKViewModel

@property (nonatomic, strong) TDecDetailFirstModel *model;

@property (nonatomic, strong) id mainViewModel;
@property (nonatomic, strong) id rollModel;
@property (nonatomic, strong) id entryModel;

@property (nonatomic, strong, readonly) RACSubject *tapItemSubject;
@property (nonatomic, strong, readonly) RACSubject *tapRemindLiveSubject;
@property (nonatomic, strong, readonly) RACSubject *tapVideoImageTagSubject;

@end

NS_ASSUME_NONNULL_END
