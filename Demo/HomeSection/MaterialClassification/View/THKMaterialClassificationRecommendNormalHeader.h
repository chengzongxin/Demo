//
//  THKMaterialClassificationViewNormalHeader.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialClassificationRecommendNormalHeader : UICollectionReusableView

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle;

@property (nonatomic, copy) void (^tapMoreBlock)(void);

@end

NS_ASSUME_NONNULL_END
