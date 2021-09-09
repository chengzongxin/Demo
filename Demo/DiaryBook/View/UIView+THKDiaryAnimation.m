//
//  UIView+THKDiaryAnimation.m
//  Demo
//
//  Created by Joe.cheng on 2021/9/6.
//

#import "UIView+THKDiaryAnimation.h"

const CGFloat kDiaryAnimationDuration = 1.5;


@implementation UIView (THKDiaryAnimation)

- (CAAnimation *)backgroundGlowAnimationFromColor:(UIColor *)startColor toColor:(UIColor *)destColor{
    CABasicAnimation *bgAnim1 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    bgAnim1.beginTime = 0;
    bgAnim1.duration = 0.2;
    bgAnim1.autoreverses = NO;
    bgAnim1.fromValue = (id) startColor.CGColor;
    bgAnim1.toValue = (id) destColor.CGColor;
    bgAnim1.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *bgAnim2 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    bgAnim2.beginTime = 0.2;
    bgAnim2.duration = 0.2;
    bgAnim2.autoreverses = NO;
    bgAnim2.fromValue = (id) destColor.CGColor;
    bgAnim2.toValue = (id) startColor.CGColor;
    bgAnim2.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *stopAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    stopAnim.fromValue = [NSNumber numberWithFloat:1];
    stopAnim.toValue = [NSNumber numberWithFloat:1];
    stopAnim.removedOnCompletion = NO;
    stopAnim.fillMode = kCAFillModeForwards;
    stopAnim.beginTime = 0.4;
    stopAnim.duration = 0.2;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[bgAnim1, bgAnim2, stopAnim];
    animGroup.duration = 0.6;
    animGroup.repeatCount = 1;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animGroup;
}

- (CAAnimation *)imageViewScale{
    CGFloat duration = 0.4;
    float stopDuration = 0.2;
    float scale = 1.3;
    // 比例
    float stayScale1Sec = duration / 2.0;
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim1.toValue = [NSNumber numberWithFloat:scale];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = stayScale1Sec;
    
    CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim2.fromValue = [NSNumber numberWithFloat:scale];
    scaleAnim2.toValue = [NSNumber numberWithFloat:1];
    scaleAnim2.removedOnCompletion = NO;
    scaleAnim2.fillMode = kCAFillModeForwards;
    scaleAnim2.beginTime = stayScale1Sec;
    scaleAnim2.duration = duration - stayScale1Sec;
    
    CABasicAnimation *stopAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    stopAnim.fromValue = [NSNumber numberWithFloat:1];
    stopAnim.toValue = [NSNumber numberWithFloat:1];
    stopAnim.removedOnCompletion = NO;
    stopAnim.fillMode = kCAFillModeForwards;
    stopAnim.beginTime = duration;
    stopAnim.duration = stopDuration;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[scaleAnim1, scaleAnim2, stopAnim];
    animGroup.duration = duration + stopDuration;
    animGroup.repeatCount = 1;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animGroup;
}


- (CAAnimation *)heartFlyAnimate1:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGPoint controlPoint = CGPointMake(startPoint.x + arc4random()%200, (startPoint.y - endPoint.y)/2);
    CGFloat duration = kDiaryAnimationDuration;
    
    // 位置
    CAKeyframeAnimation *positionAnim =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.beginTime = 0;
    positionAnim.duration = duration;
    positionAnim.removedOnCompletion = YES;
    positionAnim.fillMode = kCAFillModeRemoved;
    positionAnim.repeatCount = 0;
    positionAnim.calculationMode = kCAAnimationCubicPaced;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint point0 = startPoint;
    CGPoint point1 = endPoint;
    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint.x, controlPoint.y, point1.x, point1.y);
    positionAnim.path = curvedPath;
    
    CGPathRelease(curvedPath);
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    float stayAlpha1Sec = kDiaryAnimationDuration / 2.0;
    CABasicAnimation *opacity1Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity1Anim.fromValue = [NSNumber numberWithFloat:0.1];
    opacity1Anim.toValue = [NSNumber numberWithFloat:1.0];
    opacity1Anim.removedOnCompletion = NO;
    opacity1Anim.beginTime = 0;
    opacity1Anim.duration = stayAlpha1Sec;
    
    //正常显示stayAlpha1Sec秒后，再渐变alpha消失
    CABasicAnimation *opacity2Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity2Anim.fromValue = [NSNumber numberWithFloat:1.0];
    opacity2Anim.toValue = [NSNumber numberWithFloat:0];
    opacity2Anim.removedOnCompletion = NO;
    opacity2Anim.beginTime = stayAlpha1Sec;
    opacity2Anim.duration = duration - stayAlpha1Sec;
    
    // 比例
    float stayScale1Sec = kDiaryAnimationDuration / 2.0;
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:0.1];
    scaleAnim1.toValue = [NSNumber numberWithFloat:1];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = stayScale1Sec;
    
    CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim2.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim2.toValue = [NSNumber numberWithFloat:0.2];
    scaleAnim2.removedOnCompletion = NO;
    scaleAnim2.fillMode = kCAFillModeForwards;
    scaleAnim2.beginTime = duration - stayScale1Sec;
    scaleAnim2.duration = duration - stayScale1Sec;
    
    // 旋转
    float stayRotation1Sec = kDiaryAnimationDuration / 2.0;
    CABasicAnimation *rotationAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnim1.fromValue = [NSNumber numberWithFloat:0.5 * M_PI];
    rotationAnim1.toValue = [NSNumber numberWithFloat:0];
    rotationAnim1.removedOnCompletion = NO;
    rotationAnim1.fillMode = kCAFillModeForwards;
    rotationAnim1.beginTime = 0;
    rotationAnim1.duration = stayRotation1Sec;
    
    CABasicAnimation *rotationAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnim2.fromValue = [NSNumber numberWithFloat:0];
    rotationAnim2.toValue = [NSNumber numberWithFloat:-0.3 * M_PI];
    rotationAnim2.removedOnCompletion = NO;
    rotationAnim2.fillMode = kCAFillModeForwards;
    rotationAnim2.beginTime = duration - stayRotation1Sec;
    rotationAnim2.duration = duration - stayRotation1Sec;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[scaleAnim1, scaleAnim2, rotationAnim1, rotationAnim2, opacity1Anim, opacity2Anim, positionAnim];
    animGroup.duration = duration;
    
    return animGroup;
}

- (CAAnimation *)heartFlyAnimate2:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGPoint controlPoint = CGPointMake(startPoint.x - arc4random()%100, startPoint.y);
    CGFloat duration = kDiaryAnimationDuration;
    
    // 位置
    CAKeyframeAnimation *positionAnim =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.beginTime = 0;
    positionAnim.duration = duration;
    positionAnim.removedOnCompletion = YES;
    positionAnim.fillMode = kCAFillModeRemoved;
    positionAnim.repeatCount = 0;
    positionAnim.calculationMode = kCAAnimationCubicPaced;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint point0 = startPoint;
    CGPoint point1 = endPoint;
    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint.x, controlPoint.y, point1.x, point1.y);
    positionAnim.path = curvedPath;
    
    CGPathRelease(curvedPath);
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    float stayAlpha1Sec = kDiaryAnimationDuration / 2.0;
    CABasicAnimation *opacity1Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity1Anim.fromValue = [NSNumber numberWithFloat:0.1];
    opacity1Anim.toValue = [NSNumber numberWithFloat:1.0];
    opacity1Anim.removedOnCompletion = NO;
    opacity1Anim.beginTime = 0;
    opacity1Anim.duration = stayAlpha1Sec;
    
    //正常显示stayAlpha1Sec秒后，再渐变alpha消失
    CABasicAnimation *opacity2Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity2Anim.fromValue = [NSNumber numberWithFloat:1.0];
    opacity2Anim.toValue = [NSNumber numberWithFloat:0];
    opacity2Anim.removedOnCompletion = NO;
    opacity2Anim.beginTime = stayAlpha1Sec;
    opacity2Anim.duration = duration - stayAlpha1Sec;
    
    // 比例
    float stayScale1Sec = kDiaryAnimationDuration / 2.0;
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:0.1];
    scaleAnim1.toValue = [NSNumber numberWithFloat:1];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = stayScale1Sec;
    
    CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim2.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim2.toValue = [NSNumber numberWithFloat:0.2];
    scaleAnim2.removedOnCompletion = NO;
    scaleAnim2.fillMode = kCAFillModeForwards;
    scaleAnim2.beginTime = duration - stayScale1Sec;
    scaleAnim2.duration = duration - stayScale1Sec;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[scaleAnim1, scaleAnim2, opacity1Anim, opacity2Anim, positionAnim];
    animGroup.duration = duration;
    
    return animGroup;
}

- (CAAnimation *)heartFlyAnimate3:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGPoint controlPoint0 = CGPointMake(startPoint.x, (startPoint.y + endPoint.y) / 2);
    CGPoint controlPoint1 = CGPointMake((startPoint.x + endPoint.x) /2, endPoint.y - 50);
    CGFloat duration = kDiaryAnimationDuration;
    
    // 位置
    CAKeyframeAnimation *positionAnim =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.beginTime = 0;
    positionAnim.duration = duration;
    positionAnim.removedOnCompletion = YES;
    positionAnim.fillMode = kCAFillModeRemoved;
    positionAnim.repeatCount = 0;
    positionAnim.calculationMode = kCAAnimationCubicPaced;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint point0 = startPoint;
    CGPoint point1 = endPoint;
    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint0.x, controlPoint0.y, point0.x, point1.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint1.x, controlPoint1.y, point1.x, point1.y);
    positionAnim.path = curvedPath;
    
    CGPathRelease(curvedPath);
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    float stayAlpha1Sec = kDiaryAnimationDuration / 2.0;
    CABasicAnimation *opacity1Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity1Anim.fromValue = [NSNumber numberWithFloat:0.1];
    opacity1Anim.toValue = [NSNumber numberWithFloat:1.0];
    opacity1Anim.removedOnCompletion = NO;
    opacity1Anim.beginTime = 0;
    opacity1Anim.duration = stayAlpha1Sec;
    
    //正常显示stayAlpha1Sec秒后，再渐变alpha消失
    CABasicAnimation *opacity2Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity2Anim.fromValue = [NSNumber numberWithFloat:1.0];
    opacity2Anim.toValue = [NSNumber numberWithFloat:0];
    opacity2Anim.removedOnCompletion = NO;
    opacity2Anim.beginTime = stayAlpha1Sec;
    opacity2Anim.duration = duration - stayAlpha1Sec;
    
    // 比例
    float stayScale1Sec = kDiaryAnimationDuration / 2.0;
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:0.1];
    scaleAnim1.toValue = [NSNumber numberWithFloat:1];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = stayScale1Sec;
    
    CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim2.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim2.toValue = [NSNumber numberWithFloat:0.2];
    scaleAnim2.removedOnCompletion = NO;
    scaleAnim2.fillMode = kCAFillModeForwards;
    scaleAnim2.beginTime = duration - stayScale1Sec;
    scaleAnim2.duration = duration - stayScale1Sec;
    
    // 旋转
    float stayRotation1Sec = kDiaryAnimationDuration / 2.0;
    CABasicAnimation *rotationAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnim1.fromValue = [NSNumber numberWithFloat:-0.5 * M_PI];
    rotationAnim1.toValue = [NSNumber numberWithFloat:0];
    rotationAnim1.removedOnCompletion = NO;
    rotationAnim1.fillMode = kCAFillModeForwards;
    rotationAnim1.beginTime = 0;
    rotationAnim1.duration = stayRotation1Sec;
    
    CABasicAnimation *rotationAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnim2.fromValue = [NSNumber numberWithFloat:0];
    rotationAnim2.toValue = [NSNumber numberWithFloat:0.3 * M_PI];
    rotationAnim2.removedOnCompletion = NO;
    rotationAnim2.fillMode = kCAFillModeForwards;
    rotationAnim2.beginTime = duration - stayRotation1Sec;
    rotationAnim2.duration = duration - stayRotation1Sec;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[scaleAnim1, scaleAnim2, opacity1Anim, opacity2Anim, rotationAnim1, rotationAnim2,positionAnim];
    animGroup.duration = duration;
    
    return animGroup;
}


- (CAAnimation *)opacityAnimation{
    CGFloat duration = 2.0;
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    float stayAlpha1Sec = 1;
    CABasicAnimation *opacity1Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity1Anim.fromValue = [NSNumber numberWithFloat:0];
    opacity1Anim.toValue = [NSNumber numberWithFloat:1.0];
//    opacity1Anim.removedOnCompletion = NO;
    opacity1Anim.beginTime = 0;
    opacity1Anim.duration = stayAlpha1Sec;
    
    //正常显示stayAlpha1Sec秒后，再渐变alpha消失
    CABasicAnimation *opacity2Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity2Anim.fromValue = [NSNumber numberWithFloat:1.0];
    opacity2Anim.toValue = [NSNumber numberWithFloat:0];
//    opacity2Anim.removedOnCompletion = NO;
    opacity2Anim.beginTime = stayAlpha1Sec;
    opacity2Anim.duration = duration - stayAlpha1Sec;
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[opacity1Anim, opacity2Anim];
    animGroup.duration = duration;
    animGroup.removedOnCompletion = YES;
    
    return animGroup;
}

@end
