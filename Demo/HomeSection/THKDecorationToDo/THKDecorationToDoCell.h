//
//  THKDecorationToDoCell.h
//  testTmuikit
//
//  Created by Joe.cheng on 2022/7/19.
//

#import <UIKit/UIKit.h>
#import "THKDecorationToDoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoCell : UITableViewCell

@property (nonatomic, strong) THKDecorationUpcomingChildListModel *model;

@property (nonatomic, copy) void (^tapItem)(UIButton *btn);


//- (void)isFirstCell:(BOOL)isFirst;

@end

NS_ASSUME_NONNULL_END
