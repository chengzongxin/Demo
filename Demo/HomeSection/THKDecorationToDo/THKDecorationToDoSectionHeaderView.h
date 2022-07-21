//
//  THKDecorationToDoSectionHeaderView.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import <UIKit/UIKit.h>
#import "THKDecorationToDoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoSectionHeaderView : UITableViewHeaderFooterView


@property (nonatomic, copy) void (^tapSection)(UIButton *btn);

@property (nonatomic, strong) THKDecorationUpcomingListModel *model;

@end

NS_ASSUME_NONNULL_END
