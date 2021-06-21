//
//  UIScrollView+TScroll.m
//  HouseKeeper
//
//  Created by ben.gan on 2018/8/15.
//  Copyright © 2018年 binxun. All rights reserved.
//

#import "UIScrollView+TScroll.h"
#import <objc/runtime.h>

#define kEffectiveOrx   40

@implementation UIScrollView (TScroll)

- (void)setAllowScrolling:(BOOL)allowScrolling
{
    objc_setAssociatedObject(self, "AllowScrolling", @(allowScrolling), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)allowScrolling
{
    return [objc_getAssociatedObject(self, "AllowScrolling") boolValue];
}

- (void)setCannotSetAlwaysBoundcesToYES:(NSNumber *)cannotSetAlwaysBoundcesToYES
{
    objc_setAssociatedObject(self, "cannotSetAlwaysBoundcesToYES__", cannotSetAlwaysBoundcesToYES, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)cannotSetAlwaysBoundcesToYES
{
    return objc_getAssociatedObject(self, "cannotSetAlwaysBoundcesToYES__");
}

//一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

//location_X可自己定义,其代表的是滑动返回距左边的有效长度
- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    //是滑动返回距左边的有效长度
    int location_X = kEffectiveOrx;
    if (gestureRecognizer ==self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            //这是允许每张图片都可实现滑动返回
            int temp1 = location.x;
            int temp2 = kScreenWidth;
            NSInteger XX = temp1 % temp2;
            if (point.x >0 && XX < location_X) {
                return YES;
            }
            //下面的是只允许在第一张时滑动返回生效
//            if (point.x > 0 && location.x < location_X && self.contentOffset.x <= 0) {
//                return YES;
//            }
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}

@end

