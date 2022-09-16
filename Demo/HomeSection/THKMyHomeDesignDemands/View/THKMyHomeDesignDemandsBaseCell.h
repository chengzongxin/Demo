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

- (void)editCell:(THKMyHomeDesignDemandsBaseCell *)cell type:(THKMyHomeDesignDemandsModelType)type data:(id)data;

@end

@protocol THKMyHomeDesignDemandsBaseCellProtocol <NSObject>

- (void)setupSubviews;

- (void)bindWithModel:(THKMyHomeDesignDemandsModel *)model;

@property (nonatomic, weak) id <THKMyHomeDesignDemandsCellDelegate> delegate;

- (CGFloat)cellHeight;

@end

@interface THKMyHomeDesignDemandsBaseCell : UITableViewCell<THKMyHomeDesignDemandsBaseCellProtocol>


@end

NS_ASSUME_NONNULL_END
