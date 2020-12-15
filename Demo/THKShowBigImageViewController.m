//
//  THKShowBigImageViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import "THKShowBigImageViewController.h"
#import "THKInteractiveTransition.h"
@interface THKShowBigImageViewController () <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL isDismiss;

@property (nonatomic, weak) UIViewController *preVC;

@property (nonatomic, strong) THKInteractiveTransition *interactiveTransition;

@property (nonatomic, assign) CGFloat percent;

@end

@implementation THKShowBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.transitioningDelegate = self;
//    self.modalPresentationStyle = UIModalPresentationCustom;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:pan];
    
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
            self.interactiveTransition.interation = YES;
            self.isDismiss = YES;
//            [self startGesture];
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self startInteractiveTransition:self];
//            [self.interactiveTransition startInteractiveTransition:self];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self.interactiveTransition updateInteractiveTransition:persent];
            self.percent = persent;
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            self.interactiveTransition.interation = NO;
            if (persent > 0.5) {
                [self.interactiveTransition finishInteractiveTransition];
            }else{
                [self.interactiveTransition cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

- (void)tap:(id)event{
    NSLog(@"touch begin");
    self.isDismiss = YES;
}

+ (void)showBigImageWithImageView:(UIImageView *)imageView{
    NSLog(@"%@",imageView);
    UIViewController *currentVC = (UIViewController *)imageView.nextResponder.nextResponder.nextResponder.nextResponder;
    currentVC.modalPresentationStyle = UIModalPresentationCustom;
    THKShowBigImageViewController *imageVC = [[THKShowBigImageViewController alloc] init];
    imageVC.image = imageView.image;
    imageVC.imgFrame = imageView.frame;
    imageVC.interactiveTransition = [[THKInteractiveTransition alloc] init];
    imageVC.transitioningDelegate = imageVC;
    [currentVC presentViewController:imageVC animated:YES completion:nil];
    imageVC.preVC = currentVC;
}

#pragma mark - UIViewControllerTransitioningDelegate
// present 动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self;
}
// dismiss 动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self;
}

// 手势
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
//    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
    return self.interactiveTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.interactiveTransition;
}

//- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (self.isDismiss) {
        [self dismissAnimation:transitionContext];
    }else{
        [self presentAnimation:transitionContext];
    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //取出转场前后的视图控制器
//    UIViewController * fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
//    //取出转场前后视图控制器上的视图view
//    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
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
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    
    //如果加入了手势交互转场，就需要根据手势交互动作是否完成/取消来做操作，完成标记YES，取消标记NO，必须标记，否则系统认为还处于动画过程中，会出现无法交互之类的bug
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    if ([transitionContext transitionWasCancelled]) {
        //如果取消转场
        [transitionContext cancelInteractiveTransition];
    }else{
        //完成转场
        [transitionContext finishInteractiveTransition];
//        [transitionContext updateInteractiveTransition:self.percent];
            
    }
    
    
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    //画两个圆路径
    CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    self.imgFrame = CGRectMake(self.imgFrame.origin.x, self.imgFrame.origin.y, self.imgFrame.size.width * (2 - self.percent), self.imgFrame.size.height * (2 - self.percent));
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
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    //如果加入了手势交互转场，就需要根据手势交互动作是否完成/取消来做操作，完成标记YES，取消标记NO，必须标记，否则系统认为还处于动画过程中，会出现无法交互之类的bug
    
    if ([transitionContext transitionWasCancelled]) {
        //如果取消转场
        [transitionContext cancelInteractiveTransition];
    }else{
        //完成转场
//        [transitionContext finishInteractiveTransition];
        [transitionContext updateInteractiveTransition:self.percent];
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    switch (_type) {
//        case XWCircleSpreadTransitionTypePresent:{
//            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
//            [transitionContext completeTransition:YES];
////            [transitionContext viewControllerForKey:UITransitionContextToViewKey].view.layer.mask = nil;
//        }
//            break;
//        case XWCircleSpreadTransitionTypeDismiss:{
//            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            if ([transitionContext transitionWasCancelled]) {
//                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
//            }
//        }
//            break;
//    }
    
    NSLog(@"%@",anim);
}


@end
