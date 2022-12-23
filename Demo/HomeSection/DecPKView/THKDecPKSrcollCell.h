//
//  THKDecPKSrcollCell.h
//  Demo
//
//  Created by Joe.cheng on 2022/12/23.
//

#import <UIKit/UIKit.h>
#import "THKDecPKCompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDecPKSrcollCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *iconImgV1;

@property (nonatomic, strong) UILabel *titleLbl1;

@property (nonatomic, strong) UIImageView *iconImgV2;

@property (nonatomic, strong) UILabel *titleLbl2;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSArray <THKDecPKCompanyModel *> * model;

@end

NS_ASSUME_NONNULL_END
