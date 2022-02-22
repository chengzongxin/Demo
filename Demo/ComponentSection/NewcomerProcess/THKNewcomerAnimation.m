//
//  THKNewcomerAnimation.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKNewcomerAnimation.h"

@implementation THKNewcomerAnimation



+ (CAAnimation *)cellDismiss:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    // 位置
    CASpringAnimation *positionAnim1 = [CASpringAnimation animationWithKeyPath:@"position.y"];
    positionAnim1.beginTime = 0;
    positionAnim1.duration = 1;
    positionAnim1.removedOnCompletion = YES;
    positionAnim1.fillMode = kCAFillModeRemoved;
    positionAnim1.repeatCount = 0;
    positionAnim1.damping = 100;
    positionAnim1.stiffness = 50;
    positionAnim1.mass = 1;
    positionAnim1.initialVelocity = 0;
    positionAnim1.fromValue = @(startPoint.y);
    positionAnim1.toValue = @(endPoint.y);
    positionAnim1.duration = 1;
    
    // 比例
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:0.95];
    scaleAnim1.toValue = [NSNumber numberWithFloat:1];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = 0.33;
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim1.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim1.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnim1.removedOnCompletion = NO;
    opacityAnim1.beginTime = 0;
    opacityAnim1.duration = 1;

    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[positionAnim1,opacityAnim1,scaleAnim1];
    animGroup.duration = 1;
    
    return animGroup;
}


+ (CAAnimation *)selectBgViewScale{
    // 比例
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim1.toValue = [NSNumber numberWithFloat:10];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = 1;

    return scaleAnim1;
}


+ (CAAnimation *)cellMove:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    // 位置
    CASpringAnimation *positionAnim1 = [CASpringAnimation animationWithKeyPath:@"position"];
    positionAnim1.beginTime = 0;
    positionAnim1.duration = 1;
    positionAnim1.removedOnCompletion = YES;
    positionAnim1.fillMode = kCAFillModeRemoved;
    positionAnim1.repeatCount = 0;
    positionAnim1.damping = 100;
    positionAnim1.stiffness = 50;
    positionAnim1.mass = 1;
    positionAnim1.initialVelocity = 0;
    positionAnim1.fromValue = @(startPoint);
    positionAnim1.toValue = @(endPoint);
    positionAnim1.duration = 1;
    positionAnim1.removedOnCompletion = NO;
    
    // 比例
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:0.95];
    scaleAnim1.toValue = [NSNumber numberWithFloat:1];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = 0.33;
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim1.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim1.toValue = [NSNumber numberWithFloat:1.0];
    opacityAnim1.removedOnCompletion = NO;
    opacityAnim1.beginTime = 0;
    opacityAnim1.duration = 1;

    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[positionAnim1,opacityAnim1,scaleAnim1];
    animGroup.duration = 1;
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
        /* 动画完成后是否以动画形式回到初始值 */
    animGroup.autoreverses = NO;
    return animGroup;
}


@end
