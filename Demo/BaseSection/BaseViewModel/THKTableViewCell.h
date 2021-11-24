//
//  THKTableViewCell.h
//  HouseKeeper
//
//  Created by kevin.huang on 15-3-13.
//  Copyright (c) 2015年 binxun. All rights reserved.
//

#import "THKTableViewCellProtocol.h"
#import "THKViewModel.h"

@interface THKTableViewCell : UITableViewCell <THKTableViewCellProtocol>

@property (nonatomic, strong, readonly) THKViewModel *viewModel;

/// 将model绑定到view
/// @param model 数据
- (void)bindWithModel:(id)model;


/// view绑定viewModel
/// @param viewModel
- (void)bindViewModel:(THKViewModel *)viewModel;

@end
