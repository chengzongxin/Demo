//
//  TTagShapeColorView.m
//  xxxx
//
//  Created by nigel.ning on 2018/6/20.
//  Copyright © 2018年 npp. All rights reserved.
//

#import "TTagShapeColorView.h"

@interface TTagShapeColorView()

@end

@implementation TTagShapeColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.backgroundColor = [UIColor clearColor];
    _startPointPosition = CGPointMake(0.5, 0);
    _endPointPosition = CGPointMake(0.5, 1);
}

- (CAShapeLayer *)maskOfPath:(UIBezierPath *)path
{
    if (!path) {
        return nil;
    }
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    //mask.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)].CGPath;
    return mask;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //形状遮罩处理-每次frame变化都需要重新赋值，写在此处更加合理
    UIBezierPath *path = nil;
    if (self.maskPathSetBlock) {
        path = self.maskPathSetBlock(self);
    }
    self.layer.mask = [self maskOfPath:path];
    //因相关渐变色在frame变化时也需要重新绘制，故在此处调用以下方法以便重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //填充渐变色
    if (self.colors.count >= 2) {
        CGGradientRef gradientRef = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)self.colors, NULL);
        CGContextRef ct = UIGraphicsGetCurrentContext();
        CGPoint startP = CGPointMake(rect.size.width * self.startPointPosition.x, rect.size.height * self.startPointPosition.y);
        CGPoint endP = CGPointMake(rect.size.width * self.endPointPosition.x, rect.size.height * self.endPointPosition.y);
        CGContextDrawLinearGradient(ct, gradientRef, startP, endP, kCGGradientDrawsBeforeStartLocation);
        CGGradientRelease(gradientRef);
    }
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    [self updateUI];
}

- (void)setMaskPathSetBlock:(UIBezierPath *(^)(TTagShapeColorView *))maskPathSetBlock
{
    _maskPathSetBlock = maskPathSetBlock;
    [self updateUI];
}

- (void)setStartPointPosition:(CGPoint)startPointPosition
{
    _startPointPosition.x = MAX(0, startPointPosition.x);
    _startPointPosition.x = MIN(1, startPointPosition.x);
    _startPointPosition.y = MAX(0, startPointPosition.y);
    _startPointPosition.y = MIN(1, startPointPosition.y);
    [self updateUI];
}
- (void)setEndPointPosition:(CGPoint)endPointPosition
{
    _endPointPosition.x = MAX(0, endPointPosition.x);
    _endPointPosition.x = MIN(1, endPointPosition.x);
    _endPointPosition.y = MAX(0, endPointPosition.y);
    _endPointPosition.y = MIN(1, endPointPosition.y);
    [self updateUI];
}

- (void)updateUI
{
    if (self.superview) {
        [self setNeedsDisplay];
    }
}
@end

