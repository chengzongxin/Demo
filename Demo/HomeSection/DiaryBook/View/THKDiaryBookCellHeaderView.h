//
//  THKDiaryBookCellHeaderView.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/26.
//

#import <UIKit/UIKit.h>
#import "THKDiaryCircleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDiaryBookCellHeaderView : UITableViewHeaderFooterView
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
