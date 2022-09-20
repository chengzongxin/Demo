//
//  THKMyHomeDesignDemandsBaseCell.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/16.
//

#import <UIKit/UIKit.h>
#import "THKMyHomeDesignDemandsModel.h"
NS_ASSUME_NONNULL_BEGIN
@class THKMyHomeDesignDemandsBaseCell;

@protocol THKMyHomeDesignDemandsCellDelegate <NSObject>

- (void)editCell:(THKMyHomeDesignDemandsBaseCell *)cell type:(THKMyHomeDesignDemandsModelType)type model:(THKMyHomeDesignDemandsModel *)model data:(nullable id)data;

@end

@protocol THKMyHomeDesignDemandsBaseCellProtocol <NSObject>

@property (nonatomic, weak) id <THKMyHomeDesignDemandsCellDelegate> delegate;

@property (nonatomic, strong) THKMyHomeDesignDemandsModel *model;

- (void)setupSubviews;

- (void)bindWithModel:(THKMyHomeDesignDemandsModel *)model;

+ (CGFloat)cellHeightWithModel:(THKMyHomeDesignDemandsModel *)model;

@end

@interface THKMyHomeDesignDemandsBaseCell : UITableViewCell<THKMyHomeDesignDemandsBaseCellProtocol>

+ (CGFloat)cellHeightWithModel:(THKMyHomeDesignDemandsModel *)model;

@end

NS_ASSUME_NONNULL_END
