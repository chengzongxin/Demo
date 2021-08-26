//
//  THKDiaryBookCellHeaderView.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/26.
//

#import <UIKit/UIKit.h>
#import "THKDiaryIndexView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDiaryBookCellHeaderView : UITableViewHeaderFooterView
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, assign) THKDiaryIndexPosition position;
@end

NS_ASSUME_NONNULL_END
