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

@property (nonatomic, copy) void (^tapSelectBlock)(UIButton *btn);

@property (nonatomic, copy) void (^tapStragegyBlock)(UILabel *lbl);

@property (nonatomic, copy) void (^tapServiceBlock)(UILabel *lbl);

@property (nonatomic, strong, readonly) UIButton *selectBtn;

@property (nonatomic, strong, readonly) UILabel *titleLbl;

@property (nonatomic, strong, readonly) UILabel *descLbl;

@property (nonatomic, strong, readonly) UILabel *strategyLbl;

@property (nonatomic, strong, readonly) UILabel *serviceLbl;

//- (void)isFirstCell:(BOOL)isFirst;

@end

NS_ASSUME_NONNULL_END
