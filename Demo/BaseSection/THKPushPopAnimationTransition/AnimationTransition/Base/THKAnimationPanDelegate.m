//
//  THKAnimationPanDelegate.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKAnimationPanDelegate.h"

@interface THKAnimationPanDelegate () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation THKAnimationPanDelegate

+(THKAnimationPanDelegate *)setPanDelegate:(UIPanGestureRecognizer *)pan scrollView:(UIScrollView *)scrollView {
    THKAnimationPanDelegate *d = [[THKAnimationPanDelegate alloc] init];
    d.panGestureRecognizer = pan;
    d.panGestureRecognizer.delegate = d;
    d.scrollView = scrollView;
    return d;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]] || [touch.view isKindOfClass:[UIControl class]] || [touch.view.backgroundColor isEqual:[UIColor clearColor]]) {//剔除键盘弹出的蒙层
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(gestureRecognizer == self.panGestureRecognizer) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ) {
            if(otherGestureRecognizer.view == self.scrollView) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint point = [self.panGestureRecognizer translationInView:self.scrollView];
        UIGestureRecognizerState state = gestureRecognizer.state;
        
        CGFloat locationDistance = [UIScreen mainScreen].bounds.size.height;
        
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStatePossible) {
            CGPoint location = [gestureRecognizer locationInView:self.scrollView];
            if (self.scrollView.contentOffset.y <= -self.scrollView.contentInset.top && point.y > 0 ) {
                return YES;
            }
        }
    }
    return NO;
}


@end
