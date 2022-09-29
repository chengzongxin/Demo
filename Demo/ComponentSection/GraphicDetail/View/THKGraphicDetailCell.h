//
//  THKGraphicDetailCell.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKTableViewCell.h"
#import "THKGraphicDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicDetailCell : THKTableViewCell

@property (nonatomic, strong) UILabel *titleLbl;


@property (nonatomic, strong) THKGraphicDetailContentListItem *model;

+ (CGFloat)heightWithModel:(THKGraphicDetailContentListItem *)model;

@end

NS_ASSUME_NONNULL_END
