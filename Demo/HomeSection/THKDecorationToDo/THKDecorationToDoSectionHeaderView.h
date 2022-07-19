//
//  THKDecorationToDoSectionHeaderView.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;

@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, copy) void (^tapSection)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
