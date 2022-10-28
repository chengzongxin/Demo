//
//  THKIrrgularImageView.m
//  Demo
//
//  Created by Joe.cheng on 2022/10/28.
//

#import "THKIrrgularImageView.h"
#import "CornerPath.h"

@interface THKIrrgularImageView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation THKIrrgularImageView

- (void)setCornerPointArray:(NSArray *)pointArray
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint point0 = CGPointFromString([pointArray objectAtIndex:0]);
    CGPoint point1 = CGPointFromString([pointArray objectAtIndex:1]);
    CGPoint point2 = CGPointFromString([pointArray objectAtIndex:2]);
    CGPoint point3 = CGPointFromString([pointArray objectAtIndex:3]);
    [CornerPath addArcWithLinesFrom:point0 via:point1 to:point2 radius:8 path:path];
    [CornerPath addArcWithLinesFrom:point1 via:point2 to:point3 radius:8 path:path];
    [CornerPath addArcWithLinesFrom:point2 via:point3 to:point0 radius:8 path:path];
    [CornerPath addArcWithLinesFrom:point3 via:point0 to:point1 radius:8 path:path];
    [path closePath];
    self.path = path;
}

// 绘制图形时添加path遮罩
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.path = self.path.CGPath;
    self.layer.mask = shapLayer;
}


// 点击的覆盖方法，点击时判断点是否在path内，YES则响应，NO则不响应
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL res = [super pointInside:point withEvent:event];
    if (res)
    {
        if ([self.path containsPoint:point])
        {
            return YES;
        }
        return NO;
    }
    return NO;
}


@end
