//
//  THKShadowImageView.h
//  Demo
//
//  Created by Joe.cheng on 2020/12/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKShadowImageView : UIView

@property (nonatomic, strong, readonly) UIImageView *contentImageView;

- (void)setLayerShadow:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
