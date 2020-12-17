//
//  THKTransitionAnimator.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import "THKAnimatorTransition.h"


@interface THKAnimatorTransition ()

@property (nonatomic, assign) THKTransitionStyle trainsitionStyle;

@property (nonatomic, weak) UIViewController *vc;

@property (nonatomic, assign) THKTransitionGestureDirection direction;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenInteractive;

@property (nonatomic, strong) UIImageView *animateImageView;

@end

@implementation THKAnimatorTransition


- (void)addGestureWithVC:(UIViewController *)vc direction:(THKTransitionGestureDirection)direction{
    self.vc = vc;
    self.direction = direction;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [vc.view addGestureRecognizer:pan];
}


/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    // animateImageView
    CGPoint translation = [panGesture translationInView:panGesture.view];
    
    CGFloat scale = 1 - (translation.y / UIScreen.mainScreen.bounds.size.width);
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    
    //手势百分比
    CGFloat percent = 0;
    switch (_direction) {
        case THKTransitionGestureDirectionLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            percent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case THKTransitionGestureDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            percent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case THKTransitionGestureDirectionUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            percent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case THKTransitionGestureDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            percent = transitionY / panGesture.view.frame.size.width;
        }
            break;
    }
    
    NSLog(@" percent = %f, scale = %f",percent,scale);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //手势开始的时候标记手势状态，并开始相应的事件
            self.percentDrivenInteractive = [[UIPercentDrivenInteractiveTransition alloc] init];
            self.animateImageView.hidden = NO;
            [self startGesture];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self.percentDrivenInteractive updateInteractiveTransition:percent];
            self.animateImageView.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2 + translation.x * scale, UIScreen.mainScreen.bounds.size.height/2 + translation.y);
            self.animateImageView.transform = CGAffineTransformMakeScale(scale, scale);
        }
            break;
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            if (percent > 0.5) {
                [self.percentDrivenInteractive finishInteractiveTransition];
                
                [UIView animateWithDuration:0.5 animations:^{
                    self.animateImageView.frame = self.imgFrame;
                } completion:^(BOOL finished) {
                    self.animateImageView.transform = CGAffineTransformIdentity;
                    self.animateImageView.hidden = YES;
                }];
            }else{
                [self.percentDrivenInteractive cancelInteractiveTransition];
                
                [UIView animateWithDuration:0.5 animations:^{
                    self.animateImageView.frame = UIScreen.mainScreen.bounds;
                } completion:^(BOOL finished) {
                    self.animateImageView.transform = CGAffineTransformIdentity;
                    self.animateImageView.hidden = YES;
                }];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startGesture{
    if (self.trainsitionStyle == THKTransitionStylePresent || self.trainsitionStyle == THKTransitionStyleDismiss) {
        [self.vc dismissViewControllerAnimated:YES completion:nil];
    }else if (self.trainsitionStyle == THKTransitionStylePush || self.trainsitionStyle == THKTransitionStylePop){
        [self.vc.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Delegate 方法集合
#pragma mark UIViewControllerTransitioningDelegate
#pragma mark Modal 代理
// present 动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.trainsitionStyle = THKTransitionStylePresent;
    return self;
}
// dismiss 动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.trainsitionStyle = THKTransitionStyleDismiss;
    return self;
}
// present 手势
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

// dismiss 手势
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.percentDrivenInteractive;
}

#pragma mark Push/Pop 代理
// push / pop 动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    self.trainsitionStyle = operation == UINavigationControllerOperationPush ? THKTransitionStylePush : THKTransitionStylePop;
    return self;
}

// push / pop 手势
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.trainsitionStyle == THKTransitionStylePop ? self.percentDrivenInteractive : nil;
}


#pragma mark 转场动画代理
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (self.trainsitionStyle) {
        case THKTransitionStylePresent:
            [self presentAnimation:transitionContext];
            break;
        case THKTransitionStyleDismiss:
            [self dismissAnimation:transitionContext];
            break;
        case THKTransitionStylePush:
            [self pushAnimation:transitionContext];
            break;
        case THKTransitionStylePop:
            [self popAnimation:transitionContext];
            break;
    }
}

#pragma mark - Private Method
#pragma mark 具体转场动画
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //取出转场前后的视图控制器
    UIViewController * toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
    //这里有个重要的概念containerView，要做转场动画的视图就必须要加入containerView上才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    //画两个圆路径
    UIBezierPath *startCycle =  [UIBezierPath bezierPathWithOvalInRect:self.imgFrame];
    CGFloat x = MAX(self.imgFrame.origin.x, containerView.frame.size.width - self.imgFrame.origin.x);
    CGFloat y = MAX(self.imgFrame.origin.y, containerView.frame.size.height - self.imgFrame.origin.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    //将maskLayer作为toVC.View的遮盖
    toVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContextPresent"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    //画两个圆路径
    CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//    self.imgFrame = CGRectMake(self.imgFrame.origin.x, self.imgFrame.origin.y, self.imgFrame.size.width * (2 - self.percent), self.imgFrame.size.height * (2 - self.percent));
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:self.imgFrame];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCycle.CGPath;
    fromVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContextDismiss"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

// 核心动画不支持手势驱动
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        if ([anim valueForKey:@"transitionContextPresent"]) {
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContextPresent"];
            [transitionContext completeTransition:YES];
        }else if ([anim valueForKey:@"transitionContextDismiss"]) {
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContextDismiss"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            }
        }
    }
}

/**
 *  执行push过渡动画
 */
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //对tempView做动画，避免bug;
//    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
//    tempView.frame = fromVC.view.frame;
    UIView *containerView = [transitionContext containerView];
//    [containerView addSubview:toVC.view];
//    [containerView addSubview:tempView];
//    fromVC.view.hidden = YES;
//    [containerView insertSubview:toVC.view atIndex:0];
////    [tempView setAnchorPointTo:CGPointMake(0, 0.5)];
//    CGPoint point = CGPointMake(0, 0.5);
//    tempView.frame = CGRectOffset(tempView.frame, (point.x - tempView.layer.anchorPoint.x) * tempView.frame.size.width, (point.y - tempView.layer.anchorPoint.y) * tempView.frame.size.height);
//    tempView.layer.anchorPoint = point;
//    CATransform3D transfrom3d = CATransform3DIdentity;
//    transfrom3d.m34 = -0.002;
//    containerView.layer.sublayerTransform = transfrom3d;
//    //增加阴影
//    CAGradientLayer *fromGradient = [CAGradientLayer layer];
//    fromGradient.frame = fromVC.view.bounds;
//    fromGradient.colors = @[(id)[UIColor blackColor].CGColor,
//                        (id)[UIColor blackColor].CGColor];
//    fromGradient.startPoint = CGPointMake(0.0, 0.5);
//    fromGradient.endPoint = CGPointMake(0.8, 0.5);
//    UIView *fromShadow = [[UIView alloc]initWithFrame:fromVC.view.bounds];
//    fromShadow.backgroundColor = [UIColor clearColor];
//    [fromShadow.layer insertSublayer:fromGradient atIndex:1];
//    fromShadow.alpha = 0.0;
//    [tempView addSubview:fromShadow];
//    CAGradientLayer *toGradient = [CAGradientLayer layer];
//    toGradient.frame = fromVC.view.bounds;
//    toGradient.colors = @[(id)[UIColor blackColor].CGColor,
//                            (id)[UIColor blackColor].CGColor];
//    toGradient.startPoint = CGPointMake(0.0, 0.5);
//    toGradient.endPoint = CGPointMake(0.8, 0.5);
//    UIView *toShadow = [[UIView alloc]initWithFrame:fromVC.view.bounds];
//    toShadow.backgroundColor = [UIColor clearColor];
//    [toShadow.layer insertSublayer:toGradient atIndex:1];
//    toShadow.alpha = 1.0;
//    [toVC.view addSubview:toShadow];
//    NSLog(@"%s %@",__FUNCTION__,transitionContext);
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        tempView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
//        fromShadow.alpha = 1.0;
//        toShadow.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//        if ([transitionContext transitionWasCancelled]) {
//            [tempView removeFromSuperview];
//            fromVC.view.hidden = NO;
//        }
//    }];
    
    
    
    [containerView addSubview:fromVC.view];
    [containerView addSubview:self.animateImageView];
    self.animateImageView.hidden = NO;
    self.animateImageView.frame = self.imgFrame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.alpha = 0;
        self.animateImageView.frame = UIScreen.mainScreen.bounds;
//        toVC.view.alpha = 1;
//        toVC.view.frame = UIScreen.mainScreen.bounds;
    } completion:^(BOOL finished) {
        toVC.view.frame = UIScreen.mainScreen.bounds;
        [containerView addSubview:toVC.view];
        fromVC.view.alpha = 1;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

/**
 *  执行pop过渡动画
 */
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    //拿到push时候的
//    UIView *tempView = containerView.subviews.lastObject;
    [containerView addSubview:toVC.view];
//    [containerView addSubview:fromVC.view];
    [containerView addSubview:self.animateImageView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        tempView.layer.transform = CATransform3DIdentity;
//        fromVC.view.subviews.lastObject.alpha = 1.0;
//        tempView.subviews.lastObject.alpha = 0.0;
        fromVC.view.frame = self.imgFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            [toVC.view removeFromSuperview];
        }
    }];
    NSLog(@"pop animation");
}


#pragma mark - Getter
- (UIImageView *)animateImageView{
    if (!_animateImageView) {
        _animateImageView = [[UIImageView alloc] init];
        _animateImageView.frame = UIScreen.mainScreen.bounds;
        _animateImageView.image = [UIImage imageNamed:@"com_preload_head_img"];
        _animateImageView.contentMode = UIViewContentModeScaleAspectFit;
        _animateImageView.hidden = YES;
    }
    return _animateImageView;
}



- (void)dealloc{
    NSLog(@"%@ %s",self,__func__);
}

@end
