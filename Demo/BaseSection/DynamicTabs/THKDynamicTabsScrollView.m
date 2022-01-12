//
//  THKPageScrollView.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import "THKDynamicTabsScrollView.h"
#import <objc/runtime.h>

@interface THKDynamicTabsScrollView ()<UIGestureRecognizerDelegate>

@end

@implementation THKDynamicTabsScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollsToTop = NO;
        self.isEnableInfiniteScroll = NO;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    int location_X = 0.15 * TMUI_SCREEN_WIDTH;

    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            int temp1 = location.x;
            int temp2 = TMUI_SCREEN_WIDTH;
            NSInteger XX = temp1 % temp2;
            if (point.x >0 && XX < location_X) {
                return YES;
            }
        }
    }
    return NO;
}


- (BOOL)infiniteScroll:(UIGestureRecognizer *)gestureRecognizer {
    if (self.contentOffset.x + self.visibleSize.width == self.contentSize.width) {
        // 滑到顶了
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            if (point.x < 0) {
                // 往左滑
                return YES;
            }
        }
    }
    if (self.contentOffset.x == 0) {
        // 滑到顶了
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            if (point.x > 0) {
                // 往右滑
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    
    if (self.isEnableInfiniteScroll && [self infiniteScroll:gestureRecognizer]) {
        return NO;
    }
    
    return YES;
}


@end
