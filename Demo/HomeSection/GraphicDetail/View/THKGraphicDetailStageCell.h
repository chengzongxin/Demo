//
//  THKGraphicDetailStageCell.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import <UIKit/UIKit.h>
#import "THKGraphicDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicDetailStageCell : UICollectionViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) THKGraphicDetailContentListItem *model;


@end

NS_ASSUME_NONNULL_END
