//
//  THKMaterialClassificationViewRankHeader.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialClassificationRecommendRankHeader : UICollectionReusableView

- (void)setTitle:(NSString *)title;

@property (nonatomic, copy) void (^tapMoreBlock)(void);

@end

NS_ASSUME_NONNULL_END
