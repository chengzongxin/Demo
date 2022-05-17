//
//  TMUICycleCardView.h
//  Demo
//
//  Created by Joe.cheng on 2022/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@protocol TMUICycleCardViewDataSource <NSObject>
//
//
//@end

typedef void(^TMUICycleCardViewConfigCellBlock)(UICollectionViewCell *cell,NSIndexPath *indexPath,id model);

@interface TMUICycleCardView : UIView

@property (nonatomic, strong) NSArray *models;

- (void)registerCell:(Class)cellClass;

- (void)configCell:(TMUICycleCardViewConfigCellBlock)configBlock;

@end

NS_ASSUME_NONNULL_END
