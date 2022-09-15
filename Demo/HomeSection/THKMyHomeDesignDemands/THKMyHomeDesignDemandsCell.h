//
//  THKMyHomeDesignDemandsCell.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import <UIKit/UIKit.h>
#import "THKMyHomeDesignDemandsModel.h"
#import "THKTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
@class THKMyHomeDesignDemandsCell;

@protocol THKMyHomeDesignDemandsCellDelegate <NSObject>

- (void)editCell:(THKMyHomeDesignDemandsCell *)cell type:(THKMyHomeDesignDemandsModelType)type data:(id)data;

@end

@interface THKMyHomeDesignDemandsCell : UITableViewCell

- (void)bindWithModel:(THKMyHomeDesignDemandsModel *)model;

@property (nonatomic, weak) id <THKMyHomeDesignDemandsCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
