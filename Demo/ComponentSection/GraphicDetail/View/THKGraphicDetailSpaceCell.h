//
//  THKGraphicDetailSpaceCell.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/21.
//

#import <UIKit/UIKit.h>
#import "THKGraphicDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicDetailSpaceCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *titleLbl;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) THKGraphicDetailImgInfoItem *model;

@end

NS_ASSUME_NONNULL_END
