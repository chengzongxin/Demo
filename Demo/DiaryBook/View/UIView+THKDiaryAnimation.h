//
//  UIView+THKDiaryAnimation.h
//  Demo
//
//  Created by Joe.cheng on 2021/9/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (THKDiaryAnimation)

- (CAAnimation *)backgroundGlowAnimationFromColor:(UIColor *)startColor toColor:(UIColor *)destColor;

- (CAAnimation *)imageViewScale;

- (CAAnimation *)heartFlyAnimate1:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (CAAnimation *)heartFlyAnimate2:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (CAAnimation *)heartFlyAnimate3:(CGPoint)startPoint endPoint:(CGPoint)endPoint;


@end

NS_ASSUME_NONNULL_END
