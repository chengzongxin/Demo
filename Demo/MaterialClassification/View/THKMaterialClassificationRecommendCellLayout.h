//
//  THKMaterialClassificationViewCellLayout.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialClassificationRecommendCellLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) UIEdgeInsets decorationInset;
@property (nonatomic, assign) CGFloat decorationBottomMargin;
@property (nonatomic, assign) BOOL firstDifferent; // 第一个背景不同

@end

NS_ASSUME_NONNULL_END
