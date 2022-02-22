//
//  THKNewcomerHomeView.h
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKView.h"
#import "THKNewcomerHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKNewcomerHomeSelectStageCell : UITableViewCell
@property (nonatomic, strong) UIView *bgView;
/// icon
@property (nonatomic, strong) UIImageView *iconView;
/// title
@property (nonatomic, strong) UILabel  *titleLabel;
/// 箭头
@property (nonatomic, strong) UIImageView  *arrowView;

@end


@interface THKNewcomerHomeView : THKView

@property (nonatomic, strong, readonly) THKNewcomerHomeViewModel *viewModel;

@property (nonatomic, copy) void (^tapItem)(NSInteger idx,THKNewcomerHomeSelectStageCell *cell);


@property (nonatomic, copy) void (^animateView)(NSInteger idx,THKNewcomerHomeSelectStageCell *cell);

@end

NS_ASSUME_NONNULL_END
