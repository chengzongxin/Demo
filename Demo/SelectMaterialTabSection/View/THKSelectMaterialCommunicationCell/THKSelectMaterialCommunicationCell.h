//
//  THKSelectMaterialCommunicationCell.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/24.
//

#import <UIKit/UIKit.h>
#import "THKTableViewCell.h"
#import "THKSelectMaterialCommunicationCellVM.h"
#import "THKAvatarView.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKSelectMaterialCommunicationCell : THKTableViewCell

@property (nonatomic, strong, readonly) THKSelectMaterialCommunicationCellVM *viewModel;
/// 头像
@property (nonatomic, strong, readonly) THKAvatarView *avatarView;
/// 名字
@property (nonatomic, strong, readonly) UILabel *nameLabel;
/// 标签
@property (nonatomic, strong, readonly) UILabel *tagsLabel;
/// 内容
@property (nonatomic, strong, readonly) UILabel *contentLabel;
/// 图片集合
//@property (nonatomic, strong, readonly) THKDecorationDiaryImagesView *imagesView;
/// 互动组件
//@property (nonatomic, strong, readonly) TInteractiveToolBar *interactiveToolBar;

- (void)bindViewModel:(THKSelectMaterialCommunicationCellVM *)viewModel;

@end

NS_ASSUME_NONNULL_END
