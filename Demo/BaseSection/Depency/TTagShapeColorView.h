//
//  TTagShapeColorView.h
//  xxxx
//
//  Created by nigel.ning on 2018/6/20.
//  Copyright © 2018年 npp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTagShapeColorView : UIView

/**
 外部完成此block以返回方式传入一个作为mask遮罩的path对象
 */
@property (nonatomic, copy)UIBezierPath *(^maskPathSetBlock)(TTagShapeColorView *view);

@property (nonatomic, assign)CGPoint startPointPosition;///< 渐变起始点位置，(x,y)取值(0,0)~(1,1),默认(0.5,0)表示中上部位置开始
@property (nonatomic, assign)CGPoint endPointPosition;///< 渐变结束点位置，(x,y)取值(0,0)~(1,1),默认(0.5,1)表示中下部位置结束
@property (nonatomic, strong)NSArray *colors;///< 渐变色数组，内部需要CGColor对象且数组count必须>=2。注意此渐变与实际背景色的冲突

@end
