//
//  UIView+Godeye.m
//  Pods
//
//  Created by jerry.jiang on 2019/2/18.
//

#import "UIView+Godeye.h"
#import <objc/runtime.h>

@implementation UIView (Godeye)

- (NSString *)geWidgetUid
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGeWidgetUid:(NSString *)geWidgetUid
{
    objc_setAssociatedObject(self, @selector(geWidgetUid), geWidgetUid, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSString *)geWidgetHref
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGeWidgetHref:(NSString *)geWidgetHref
{
    objc_setAssociatedObject(self, @selector(geWidgetHref), geWidgetHref, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isDisplayedInScreen
{
    if (!self) {
        return NO;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return NO;
    }
    
    // window显示
    if ([self isKindOfClass:[UIWindow class]]) {
        return YES;
    }
    
    // 若没有superview
    if (!self.superview) {
        return NO;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        return NO;
    }
    
    // 父视图是ScrollView
    if ([self.superview isKindOfClass:[UIScrollView class]] && ![self isVisibleInScrollView]) {
        return NO;
    }
    
    // 是否在父试图范围内显示
    if (![self isVisibleInSuperview]) {
        return NO;
    }
    
    // 父试图是否显示
    if (![self.superview isDisplayedInScreen]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isVisibleInScrollView {
    
    UIScrollView *scrollView = self.superview;
    
    CGRect scrollViewVisibleRect = (CGRect){scrollView.contentOffset, scrollView.bounds.size};
    
    // 获取 该view与可见范围 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(self.frame, scrollViewVisibleRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isVisibleInSuperview {
    
    // 获取 该view与superview 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(self.frame, self.superview.bounds);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    return YES;
}

@end
