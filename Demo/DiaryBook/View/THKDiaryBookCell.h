//
//  THKDiaryBookCell.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import <UIKit/UIKit.h>
#import "THKDiaryBookCellVM.h"
NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const UIEdgeInsets kDiaryContentInset;

@protocol THKDiaryBookCellBindVM <NSObject>

/// view绑定viewModel
- (void)bindViewModel:(THKDiaryBookCellVM *)viewModel;

@end

@interface THKDiaryBookCell : UITableViewCell<THKDiaryBookCellBindVM>

@property (nonatomic, strong, readonly) THKDiaryBookCellVM *viewModel;

/// view绑定viewModel
- (void)bindViewModel:(THKDiaryBookCellVM *)viewModel;

@end

NS_ASSUME_NONNULL_END
