//
//  THKMaterialClassificationViewCellLayout.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const Full_BackGround_ReuseId;
extern NSString* const Header_BackGround_ReuseId;

@protocol THKMaterialClassificationRecommendCellLayoutDecorationDelegate <NSObject>


/// 是否显示全部Decoration背景
/// @param indexPath indexPath
- (BOOL)isFullDecorationAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface THKMaterialClassificationRecommendCellLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) UIEdgeInsets decorationInset;

@property (nonatomic, weak) id<THKMaterialClassificationRecommendCellLayoutDecorationDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
