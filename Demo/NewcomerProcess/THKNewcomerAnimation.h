//
//  THKNewcomerAnimation.h
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKNewcomerAnimation : NSObject
+ (CAAnimation *)cellDismiss:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
+ (CAAnimation *)selectBgViewScale;
+ (CAAnimation *)cellMove:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
@end

NS_ASSUME_NONNULL_END
