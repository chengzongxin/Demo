//
//  CornerPath.h
//  HouseKeeper
//  生成圆角的Path
//  Created by ben.gan on 2021/8/26.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CornerPath : NSObject

/**
 向path里添加圆角
 @param from 起点
 @param via 经过点
 @param to 终点
 @param radius 圆角
 @param path 待添加的path
 */
+ (void)addArcWithLinesFrom:(CGPoint)from via:(CGPoint)via to:(CGPoint)to radius:(CGFloat)radius path:(UIBezierPath *)path;

@end

NS_ASSUME_NONNULL_END
