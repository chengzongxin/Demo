//
//  THKDiaryBookVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import "THKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDiaryBookVM : THKViewModel

@property (nonatomic, copy) NSArray <NSString *>*sections;
@property (nonatomic, copy) NSArray *rows;

@end

NS_ASSUME_NONNULL_END
