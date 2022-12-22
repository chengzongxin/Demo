//
//  THKDecPKSrcollView.h
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import <UIKit/UIKit.h>
#import "THKDecPKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDecPKSrcollView : UIView

@property (nonatomic, strong) NSArray *model;

@property (nonatomic, copy) void (^didScrollToDecs)(NSArray <THKDecPKCompanyModel *>* models);

@end

NS_ASSUME_NONNULL_END
