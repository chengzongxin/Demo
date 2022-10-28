//
//  CornerPath.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/8/26.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "CornerPath.h"

typedef struct {
    CGPoint centerPoint;
    CGFloat startAngle;
    CGFloat endAngle;
} CornerPoint;

@implementation CornerPath

#pragma mark - Public

+ (void)addArcWithLinesFrom:(CGPoint)from via:(CGPoint)via to:(CGPoint)to radius:(CGFloat)radius path:(UIBezierPath *)path {
    CornerPoint corner  = [self roundedCornerWithLinesFrom:from
                                                       via:via
                                                        to:to
                                                withRadius:radius
                                                 clockwise:NO];
    [path addArcWithCenter:corner.centerPoint radius:radius startAngle:corner.startAngle endAngle:corner.endAngle clockwise:NO];
}


#pragma mark - Private

+ (CornerPoint)roundedCornerWithLinesFrom:(CGPoint)from
                                      via:(CGPoint)via
                                       to:(CGPoint)to
                               withRadius:(CGFloat)radius
                                clockwise:(BOOL)clockwise {
    CGFloat fromAngle = atan2f(via.y - from.y,
                               via.x - from.x);
    CGFloat toAngle   = atan2f(to.y  - via.y,
                               to.x  - via.x);
    
    CGVector fromOffset = CGVectorMake(sinf(fromAngle)*radius,
                                       -cosf(fromAngle)*radius);
    CGVector toOffset   = CGVectorMake(sinf(toAngle)*radius,
                                       -cosf(toAngle)*radius);
    
    if (clockwise) {
        fromOffset = CGVectorMake(-sinf(fromAngle)*radius,
                                  cosf(fromAngle)*radius);
        toOffset   = CGVectorMake(-sinf(toAngle)*radius,
                                  cosf(toAngle)*radius);
    }
    
    CGFloat x1 = from.x + fromOffset.dx;
    CGFloat y1 = from.y + fromOffset.dy;
    
    CGFloat x2 = via.x + fromOffset.dx;
    CGFloat y2 = via.y + fromOffset.dy;
    
    CGFloat x3 = via.x + toOffset.dx;
    CGFloat y3 = via.y + toOffset.dy;
    
    CGFloat x4 = to.x + toOffset.dx;
    CGFloat y4 = to.y + toOffset.dy;
    
    CGFloat intersectionX = ((x1*y2-y1*x2)*(x3-x4) - (x1-x2)*(x3*y4-y3*x4)) / ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
    CGFloat intersectionY = ((x1*y2-y1*x2)*(y3-y4) - (y1-y2)*(x3*y4-y3*x4)) / ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
    CGPoint intersection = CGPointMake(intersectionX, intersectionY);
    
    CornerPoint corner;
    corner.centerPoint = intersection;
    corner.startAngle  = fromAngle + M_PI_2;
    corner.endAngle    = toAngle   + M_PI_2;
    
    return corner;
}

@end
