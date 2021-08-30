//
//  THKDiaryCircle.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/30.
//

#import "THKDiaryCircle.h"

@implementation THKDiaryCircle
#pragma mark - Life Cycle
- (void)dealloc{
    NSLog(@"%@ did dealloc",self);
}

/// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

/// init or initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)drawRect:(CGRect)rect{
    [self drawCircle:UIGraphicsGetCurrentContext()];
}

//画圆、圆弧
- (void)drawCircle:(CGContextRef)ctx{
    CGContextSetStrokeColorWithColor(ctx, UIColorHex(22C787).CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
     /* 绘制路径 方法一
      void CGContextAddArc (
      CGContextRef c,
      CGFloat x,             //圆心的x坐标
      CGFloat y,    //圆心的x坐标
      CGFloat radius,   //圆的半径
      CGFloat startAngle,    //开始弧度
      CGFloat endAngle,   //结束弧度
      int clockwise          //0表示顺时针，1表示逆时针
      );
      */
    CGFloat x = self.bounds.size.width / 2.0;
    CGFloat y = self.bounds.size.height / 2.0;
    CGFloat raduis = self.bounds.size.height / 2;  //6+1 , 10+3
     //圆
    CGContextAddArc (ctx, x, y, raduis, 0, M_PI * 2 , 0);
    CGContextSetLineWidth(ctx, 1);
    CGContextDrawPath(ctx,kCGPathFillStroke);
 }



#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{

}


#pragma mark - Private



#pragma mark - Getter && Setter


@end
