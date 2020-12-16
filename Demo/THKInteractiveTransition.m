//
//  THKInteractiveTransition.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import "THKInteractiveTransition.h"
#import "UIView+TMUI.h"
@interface THKInteractiveTransition ()

@property (nonatomic, weak) UIViewController *vc;

@property (nonatomic, assign) NSInteger type;

@end

@implementation THKInteractiveTransition

- (void)addGestureWithVC:(UIViewController *)vc type:(NSInteger)type{
    self.vc = vc;
    self.type = type;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [vc.view addGestureRecognizer:pan];
}
/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    //手势百分比
    CGFloat persent = 0;
//    switch (_direction) {
//        case XWInteractiveTransitionGestureDirectionLeft:{
//            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
//            persent = transitionX / panGesture.view.frame.size.width;
//        }
//            break;
//        case XWInteractiveTransitionGestureDirectionRight:{
//            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
//            persent = transitionX / panGesture.view.frame.size.width;
//        }
//            break;
//        case XWInteractiveTransitionGestureDirectionUp:{
//            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
//            persent = transitionY / panGesture.view.frame.size.width;
//        }
//            break;
//        case XWInteractiveTransitionGestureDirectionDown:{
//            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
//            persent = transitionY / panGesture.view.frame.size.width;
//        }
//            break;
//    }
    
    CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
    persent = transitionY / panGesture.view.frame.size.width;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:persent];
            NSLog(@" persent = %f",persent);
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            if (persent > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startGesture{
    if (self.type == 0) {
        [self.vc dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.vc.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc{
    NSLog(@"%s %@",__func__,self);
}

@end
