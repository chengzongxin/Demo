//
//  FLRadarChartView.m
//  FLRadarChart
//
//  Created by 冯洁亮 on 2018/12/16.
//  Copyright © 2018 FJL. All rights reserved.
//

#import "FLRadarChartView.h"
//category
#import "UIView+FLFrame.h"
#import "NSString+FLTextSize.h"
//model
#import "FLRadarChartModel.h"

//由角度转换弧度
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

@interface FLRadarChartView ()

/**
 半径
 */
@property (nonatomic, assign) CGFloat chartRadius;

/**
 图表中心位置
 */
@property (nonatomic, assign) CGPoint chartCenter;

/**
 背景虚线layer
 */
@property (nonatomic, strong) CAShapeLayer *backgroundLineLayer;

/**
 背景边框线layer
 */
@property (nonatomic, strong) CAShapeLayer *backgroundBorderLineLayer;

/**
 背景边界圆点layer
 */
@property (nonatomic, strong) CAShapeLayer *backgroundBorderCircleLayer;

/**
 背景边界横线layer
 */
@property (nonatomic, strong) CAShapeLayer *backgroundValueLineLayer;

/**
 需要绘制的雷达图
 */
@property (nonatomic, strong) CAShapeLayer *valueLayer;

/**
 分类颜色描述
 */
@property (nonatomic, strong) CAShapeLayer *colorDescribeLayer;

@end

@implementation FLRadarChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupDefaultRadarChart];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self p_setupDefaultRadarChart];
    }
    return self;
}

- (void)p_setupDefaultRadarChart {
    self.minValue = 0;
    self.maxValue = 100;
    self.allowOverflow = NO;
    self.lineInterval = 20;
    self.radarChartLineWidth = 1;
    self.radarChartLineColor = [UIColor colorWithRed:46/255.0 green:110/255.0 blue:242/255.0 alpha:255/255.0];
    self.classifyTextFont = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.classifyTextColor = [UIColor colorWithRed:51/255.0 green:53/255.0 blue:51/255.0 alpha:255/255.0];
;
    
    self.backgroundColor = [UIColor whiteColor];
}


#pragma mark - setter
- (void)setClassifyDataArray:(NSArray<NSString *> *)classifyDataArray {
    _classifyDataArray = classifyDataArray;
    NSAssert(classifyDataArray.count >= 3, @"分类数据不能小于三组");
}

#pragma mark - Layer Display

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (self.classifyDataArray.count >= 3) {
        if (!_backgroundLineLayer) {
            [self fl_drawRadarChartBackgroundLine];
        }
    }
    if (self.dataArray.count) {
        if (!_valueLayer) {
            [self fl_drawRadarChartWithValue];
        }
        if (!_colorDescribeLayer) {
            [self fl_drawRadarChartWithColorDescribe];
        }
    }
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    //上下预留30的间距，做文字和颜色描述描述
    self.chartRadius = MIN(self.fl_width, self.fl_height) / 2  - 40;
    //    self.chartCenter = CGPointMake(MIN(self.fl_width, self.fl_height)/2, MIN(self.fl_width, self.fl_height)/2);
    //    self.chartCenter = CGPointMake(MAX(self.fl_width, self.fl_height)/2, MAX(self.fl_width, self.fl_height)/2);
    self.chartCenter = CGPointMake(self.fl_width / 2, self.fl_height / 2);
}

#pragma mark - methods

- (void)fl_redrawRadarChart {
    [_backgroundLineLayer removeFromSuperlayer];
    _backgroundLineLayer = nil;
    
    [_backgroundBorderLineLayer removeFromSuperlayer];
    _backgroundBorderLineLayer = nil;
    
    [_backgroundBorderCircleLayer removeFromSuperlayer];
    _backgroundBorderCircleLayer = nil;

    [_backgroundValueLineLayer removeFromSuperlayer];
    _backgroundValueLineLayer = nil;
    
    [_valueLayer removeFromSuperlayer];
    _valueLayer = nil;
    
    [_colorDescribeLayer removeFromSuperlayer];
    _colorDescribeLayer = nil;
    
    //间接调用drawRect方法
    [self.layer setNeedsDisplay];
}



/**
 绘制雷达图
 */
- (void)fl_drawRadarChartWithValue {
    for (FLRadarChartModel *dataModel in self.dataArray) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = self.radarChartLineWidth;
        layer.strokeColor = dataModel.strokeColor.CGColor;
        layer.fillColor = dataModel.fillColor.CGColor;
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        //不能使用forin遍历 如果数组中存在相同数据 indexOfObject 获取的 index 是错误的
        for (NSInteger i = 0; i < dataModel.valueArray.count; i ++) {
            NSNumber *value = dataModel.valueArray[i];
            CGFloat numeric = value.floatValue;
            
            if (!self.allowOverflow) {
                //判断当前值是否超过最大最小值
                if (value.floatValue > self.maxValue) {
                    numeric = MIN(value.floatValue, self.maxValue);
                } else if (value.floatValue < self.minValue) {
                    numeric = MAX(value.floatValue, self.minValue);
                }
            }
            
            NSInteger subAngle = 360 / self.classifyDataArray.count;
            
            
            //NSInteger index = [dataModel.values indexOfObject:value];
            
            NSInteger angle = i * subAngle;
            CGFloat radian = kDegreesToRadian(angle);
            //每个数值的最小半径
            CGFloat minValueRadius = (self.maxValue - self.minValue) / self.chartRadius;
            
            CGFloat x = self.chartCenter.x + sinf(radian) * (numeric / minValueRadius);
            CGFloat y = self.chartCenter.y - cosf(radian) * (numeric / minValueRadius);
            
            CGPoint valuePoint = CGPointMake(x, y);
            if (i == 0) {
                [bezierPath moveToPoint:valuePoint];
            } else {
                [bezierPath addLineToPoint:valuePoint];
            }
        }
        
        [bezierPath closePath];
        layer.path = bezierPath.CGPath;
        [self.valueLayer addSublayer:layer];
    }
    [self.layer addSublayer:self.valueLayer];
}

/**
 绘制颜色描述
 */
- (void)fl_drawRadarChartWithColorDescribe {
    
    CGFloat textInterval = 30;
    CGFloat potW = 7;
    CGFloat ptInterval = 4;
    
    CGFloat textY = 0;
    CGFloat potY = 0;
    CGFloat potYOffset = 2;
    
    CGRect contentFrames = CGRectZero;
    for (int i = 0; i < self.dataArray.count; i++) {
        CGRect textFrame;
        CGRect potFrame;
        FLRadarChartModel *model = self.dataArray[i];
        CGSize textSize = [model.name fl_sizeForFont:self.classifyTextFont];
        textY = self.fl_height - 11 - textSize.height;
        potY = textY + (textSize.height - potW) / 2;
        
        CGFloat contentW = textSize.width + potW + ptInterval;
        
        
        CGFloat x = 0;
        if (i == 0) {
            BOOL isOdd = self.dataArray.count % 2 == 1;
            if (isOdd) {
                // 居中
                x = (self.fl_width - contentW)/2;
                
                contentFrames = CGRectMake(x, textY, contentW, textSize.height);
            }else{
                // 放左边
                x = self.fl_width/2 - textInterval / 2 - contentW;
                
                contentFrames = CGRectMake(x, textY, contentW, textSize.height);
            }
        }else{
            
            if (CGRectGetCenter(contentFrames).x >= self.center.x) {
                // 在右边，要往左填充
                x = CGRectGetMinX(contentFrames) - textInterval - contentW;
                
                contentFrames = CGRectMake(x, textY, CGRectGetWidth(contentFrames) + textInterval + contentW, textSize.height);
            }else{
                // 在左边，要往右填充
                x = CGRectGetMaxX(contentFrames) + textInterval;
                
                contentFrames = CGRectMake(CGRectGetMinX(contentFrames), textY, CGRectGetWidth(contentFrames) + textInterval + contentW, textSize.height);
            }
        }
        
        
        potFrame = CGRectMake(x, potY + potYOffset, potW, potW);
        textFrame = CGRectMake(x + potW + ptInterval, textY, textSize.width, textSize.height);
        
        CAShapeLayer *colorCircleLayer = [self fl_getColorCircleLayerWithColor:model.strokeColor frame:potFrame];
        [self.colorDescribeLayer addSublayer:colorCircleLayer];
        
        CATextLayer *colorDescribeLayer = [self fl_getTextLayerWithString:model.name backgroundColor:[UIColor clearColor] frame:textFrame];
        [self.colorDescribeLayer addSublayer:colorDescribeLayer];
        
        
    }
    
//    for (FLRadarChartModel *model in self.dataArray) {
//        NSInteger index = [self.dataArray indexOfObject:model];
//        CGSize textSize = [model.name fl_sizeForFont:self.classifyTextFont];
//        CGFloat textInterval = 5;
//
//        CGRect textFrame = CGRectMake(self.fl_width - textSize.width - 3 * textInterval, self.fl_height - (index + 1) * textSize.height - 2 * (index + 1) * textInterval, textSize.width, textSize.height);
//        CGRect colorCircleFrame = CGRectMake(textFrame.origin.x - textInterval - textSize.height, textFrame.origin.y, textSize.height, textSize.height);
//
//        CAShapeLayer *colorCircleLayer = [self fl_getColorCircleLayerWithColor:model.strokeColor frame:colorCircleFrame];
//        [self.colorDescribeLayer addSublayer:colorCircleLayer];
//
//        CATextLayer *colorDescribeLayer = [self fl_getTextLayerWithString:model.name backgroundColor:[UIColor clearColor] frame:textFrame];
//        [self.colorDescribeLayer addSublayer:colorDescribeLayer];
//    }
    [self.layer addSublayer:self.colorDescribeLayer];
}

/**
 绘制雷达图背景
 */
- (void)fl_drawRadarChartBackgroundLine {
    //雷达图需要绘制的底线数量
    NSInteger radarCount = self.classifyDataArray.count;
    //半径
    CGFloat radius = self.chartRadius;
    //子角度
    //1/360 的角度
    NSInteger subAngle = 360 / radarCount;
    
    //雷达图间隔可以画的次数
    NSInteger lines = ceilf(radius / self.lineInterval);
    
    NSMutableArray *borderPointArray = [NSMutableArray array];
    
    self.backgroundBorderLineLayer = [CAShapeLayer layer];
    self.backgroundBorderLineLayer.lineWidth = 3;
    self.backgroundBorderLineLayer.strokeColor = [self.radarChartLineColor colorWithAlphaComponent:0.3].CGColor;
    self.backgroundBorderLineLayer.fillColor = [UIColor clearColor].CGColor;
    
    self.backgroundBorderCircleLayer = [CAShapeLayer layer];
    self.backgroundBorderCircleLayer.lineWidth = 1;
    self.backgroundBorderCircleLayer.strokeColor = [self.radarChartLineColor colorWithAlphaComponent:0.3].CGColor;
    self.backgroundBorderCircleLayer.fillColor = [self.radarChartLineColor colorWithAlphaComponent:0.3].CGColor;
        
    self.backgroundLineLayer = [CAShapeLayer layer];
    self.backgroundLineLayer.lineWidth = self.radarChartLineWidth;
    self.backgroundLineLayer.strokeColor = [self.radarChartLineColor colorWithAlphaComponent:0.3].CGColor;
    self.backgroundLineLayer.fillColor = [UIColor clearColor].CGColor;
    self.backgroundLineLayer.lineDashPattern = @[@2,@2];
    
    self.backgroundValueLineLayer = [CAShapeLayer layer];
    self.backgroundValueLineLayer.lineWidth = 0.5;
    self.backgroundValueLineLayer.strokeColor = [self.radarChartLineColor colorWithAlphaComponent:0.3].CGColor;
    self.backgroundValueLineLayer.fillColor = [UIColor clearColor].CGColor;
    
    
    UIBezierPath *backgroundBorderLinePath = [UIBezierPath bezierPath];
    UIBezierPath *backgroundBorderCircleLayer = [UIBezierPath bezierPath];
    UIBezierPath *backgroundLinePath = [UIBezierPath bezierPath];
    UIBezierPath *backgroundValueLineLayer = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i < lines; i ++) {
        //循环绘制每一圈的背景线
        NSMutableArray<NSValue *> *pointArray = [NSMutableArray array];
        for (NSInteger idx = 0; idx < radarCount; idx++ ) {
            NSInteger angle = idx * subAngle;
            CGFloat radian = kDegreesToRadian(angle);
            
            CGFloat x = self.chartCenter.x + sinf(radian) * radius;
            CGFloat y = self.chartCenter.y - cosf(radian) * radius;
            
            //CGFloat x = self.view.center.x + cos(radian) * radius;
            //CGFloat y = self.view.center.y + sin(radian) * radius;
            
            CGPoint point = CGPointMake(x, y);
            [pointArray addObject:[NSValue valueWithCGPoint:point]];
            
//            if (idx == 0) {
//                [backgroundLinePath moveToPoint:point];
//            } else {
//                [backgroundLinePath addLineToPoint:point];
//            }
        }
        //重新连接第一个点
        //        [backgroundLinePath addLineToPoint:pointArray.firstObject.CGPointValue];
//        [backgroundLinePath closePath];
        
        if (i == 0) {
            [backgroundBorderLinePath moveToPoint:CGPointMake(self.chartCenter.x + radius, self.chartCenter.y)];
            [backgroundBorderLinePath addArcWithCenter:self.chartCenter radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        }else{
            [backgroundLinePath moveToPoint:CGPointMake(self.chartCenter.x + radius, self.chartCenter.y)];
            [backgroundLinePath addArcWithCenter:self.chartCenter radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        }
        
        radius -= self.lineInterval;
        if (i == 0) {
            [borderPointArray setArray:pointArray];
        }
    }
    //竖向直线
    
     for (NSValue *boardValue in borderPointArray) {
         CGPoint boardPoint = boardValue.CGPointValue;
         [backgroundValueLineLayer moveToPoint:self.chartCenter];
         [backgroundValueLineLayer addLineToPoint:boardPoint];
         
         [backgroundBorderCircleLayer moveToPoint:boardPoint];
         [backgroundBorderCircleLayer addArcWithCenter:boardPoint radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
     }
    
    
    self.backgroundBorderLineLayer.path = backgroundBorderLinePath.CGPath;
    [self.layer addSublayer:self.backgroundBorderLineLayer];
    
    self.backgroundBorderCircleLayer.path = backgroundBorderCircleLayer.CGPath;
    [self.layer addSublayer:self.backgroundBorderCircleLayer];
    
    self.backgroundLineLayer.path = backgroundLinePath.CGPath;
    [self.layer addSublayer:self.backgroundLineLayer];
    
    self.backgroundValueLineLayer.path = backgroundValueLineLayer.CGPath;
    [self.layer addSublayer:self.backgroundValueLineLayer];
    
    [self fl_drawRadarChartClassifyTextWithPointArray:borderPointArray];
}

/**
 绘制雷达图分类属性文字
 
 @param pointArray 每个角的坐标数组
 */
- (void)fl_drawRadarChartClassifyTextWithPointArray:(NSArray<NSValue *> *)pointArray {
    for (NSInteger j = 0; j < pointArray.count; j ++) {
        //边框的位置
        CGPoint textPoint = pointArray[j].CGPointValue;
        
        CATextLayer *textLayer = nil;
        //文字
        NSString *text = self.classifyDataArray[j];
        //文字大小
        CGSize textSize = [text fl_sizeForFont:self.classifyTextFont];
        
        if (textSize.height > self.classifyTextFont.pointSize * 2) {
            textSize.height += 4;// 换行需要多加
        }
        //文字的间隔
        CGFloat textInterval = 10;
        //多加一个判断条件
        if (textPoint.x < self.chartCenter.x && (self.chartCenter.x - textPoint.x) > 0.05) {
            CGRect frame = CGRectMake(textPoint.x - textSize.width - textInterval, textPoint.y - textSize.height / 2, textSize.width, textSize.height);
            textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
        } else if (textPoint.x > self.chartCenter.x && (textPoint.x - self.chartCenter.x) > 0.05) {
            CGRect frame = CGRectMake(textPoint.x + textInterval, textPoint.y - textSize.height / 2, textSize.width, textSize.height);
            textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
        } else  { //textPoint.x == self.chartCenter.x
            if (textPoint.y < self.chartCenter.y) {
                CGRect frame = CGRectMake(textPoint.x - textSize.width / 2, textPoint.y - textSize.height - textInterval, textSize.width, textSize.height);
                textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
            } else {
                CGRect frame = CGRectMake(textPoint.x - textSize.width / 2, textPoint.y + textInterval, textSize.width, textSize.height);
                textLayer = [self fl_getTextLayerWithString:text backgroundColor:[UIColor clearColor] frame:frame];
            }
        }
        [self.backgroundLineLayer addSublayer:textLayer];
    }
}



- (CATextLayer *)fl_getTextLayerWithString:(NSString *)text backgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame {
    //初始化一个CATextLayer
    CATextLayer *textLayer = [CATextLayer layer];
    //设置文字frame
    textLayer.frame = frame;
    //设置文字
    textLayer.string = text;
    //设置文字大小
    textLayer.fontSize = self.classifyTextFont.pointSize;
    //设置文字颜色
    textLayer.foregroundColor = self.classifyTextColor.CGColor;
    //设置背景颜色
    textLayer.backgroundColor = backgroundColor.CGColor;
    //设置对齐方式
    textLayer.alignmentMode = kCAAlignmentCenter;
    //设置分辨率
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    return textLayer;
}

- (CAShapeLayer *)fl_getColorCircleLayerWithColor:(UIColor *)color frame:(CGRect)frame {
    CAShapeLayer *colorCircleLayer = [CAShapeLayer layer];
    colorCircleLayer.fillColor = [color CGColor];
    colorCircleLayer.strokeColor = [color CGColor];
    colorCircleLayer.lineCap = kCALineCapRound;
    colorCircleLayer.lineWidth = 1;
    UIBezierPath *colorCircleLayerPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    colorCircleLayer.path = colorCircleLayerPath.CGPath;
    return colorCircleLayer;
}

#pragma mark - lazy load.
- (CAShapeLayer *)valueLayer {
    if (!_valueLayer) {
        _valueLayer = [CAShapeLayer layer];
    }
    return _valueLayer;
}

- (CAShapeLayer *)colorDescribeLayer {
    if (!_colorDescribeLayer) {
        _colorDescribeLayer = [CAShapeLayer layer];
    }
    return _colorDescribeLayer;
}

- (void)dealloc {
    NSLog(@"%@ has been released",self.class);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
