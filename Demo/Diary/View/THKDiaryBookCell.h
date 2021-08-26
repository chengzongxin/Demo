//
//  THKDiaryBookCell.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import <UIKit/UIKit.h>
#import "THKDiaryBookCellVM.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKDiaryBookCell : UITableViewCell

@property (nonatomic, strong, readonly) THKDiaryBookCellVM *viewModel;

/// view绑定viewModel
- (void)bindViewModel:(THKDiaryBookCellVM *)viewModel;

@end

NS_ASSUME_NONNULL_END
