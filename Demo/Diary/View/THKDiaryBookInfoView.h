//
//  THKDiaryBookInfoView.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import "THKView.h"
#import "THKDiaryBookInfoViewModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 ⚠ 1.修改tableView的tableHeaderView界面时，界面并不能及时刷新，可手动调用layoutIfNeeded 此时view高度为理想高度

     2.tableViewHeader高度变化时，界面也不能及时刷新 需要重新将headerView设置为tableView的tableHeaderView,界面即可正确显示了

     3.当然，使用auto layout时，约束条件必须充分 才能计算出正确高度哦^^
 */

@interface THKDiaryBookInfoView : THKView

@property (nonatomic, strong, readonly) THKDiaryBookInfoViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
