//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKMaterialClassificationVC.h"
#import "THKMaterialClassificationVM.h"
#import "THKMaterialHotRankVC.h"
#import "THKMaterialHotRankVM.h"
#import "THKDiaryBookVC.h"
#import "THKExpandLabel.h"
#import "DynamicTabDemoList.h"
#import "THKQuickCommentsView.h"
#import "THKSelectMaterialHomeVC.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)test{
    self.view.backgroundColor = UIColor.tmui_randomColor;
    
    Button.str(@"如何选材").bgColor(@"random").xywh(100,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        TRouter *router = [TRouter routerWithName:THKRouterPage_SelectMaterialCategoryDetail
                                            param:@{@"mainCategoryId" : @4}
                                   jumpController:self];
        [[TRouterManager sharedManager] performRouter:router];
    });
    
    Button.str(@"热门排行榜").bgColor(@"random").xywh(250,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        THKMaterialHotRankVM *vm = [[THKMaterialHotRankVM alloc] init];
        THKMaterialHotRankVC *vc = [[THKMaterialHotRankVC alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    // File: ani@3x.gif
//    UIImage *image = [YYImage imageNamed:@"718.apng"];
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
    [imageView setImageURL:[NSURL URLWithString:@"http://pic.to8to.com/infofed/20210701/d8377a0ac76c9c965d1fe3ca8295e27a.webp"]];
    [self.view addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(100);
        make.width.height.mas_equalTo(100);
    }];
    
    
    Button.str(@"日记本").bgColor(@"random").xywh(100,250,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        THKDiaryBookVM *vm = [[THKDiaryBookVM alloc] init];
        THKDiaryBookVC *vc = [[THKDiaryBookVC alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    Button.str(@"Tab组件").bgColor(@"random").xywh(250,250,100,100).addTo(self.view).onClick(^{
        DynamicTabDemoList *vc = [[DynamicTabDemoList alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    
    Button.str(@"选材").bgColor(@"random").xywh(100,400,100,100).addTo(self.view).onClick(^{
        THKSelectMaterialHomeVM *vm = [[THKSelectMaterialHomeVM alloc] init];
        THKSelectMaterialHomeVC *vc = [[THKSelectMaterialHomeVC alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    [self comment];
}

- (void)comment{
    THKQuickCommentsView *view = [[THKQuickCommentsView alloc] init];
    
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.top.equalTo(@600);
        make.height.equalTo(@30);
    }];
    
    THKQuickCommentsViewModel *vm = [[THKQuickCommentsViewModel alloc] init];
    vm.comments = @[@"房间路发😆多少",@"🔥 房开发多少",@"😋房间发多少",@"房上路发多少😆",@"路发多少",@"开上多少",@"房间大发多少",@"房间多少",@"房路发少"];
    [view bindViewModel:vm];
    
    view.tapItem = ^(NSString * _Nonnull text) {
        NSLog(@"%@",text);
    };
}


CAAnimation *_anim;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(300, 300, 100, 30)];
    view.backgroundColor = UIColor.tmui_randomColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    label.text = @"开工大吉";
    [view addSubview:label];
//    view.layer.anchorPoint = CGPointMake(0, 0);
    [self.navigationController.view addSubview:view];
    CAAnimation *anim = [self commentFlyAnimate:CGPointMake(300, 300)];
    __weak typeof(view) weakView = view;
    anim.tmui_animationDidStopBlock = ^(__kindof CAAnimation * _Nonnull aAnimation, BOOL finished) {
        [weakView removeFromSuperview];
    };
    [view.layer addAnimation:anim forKey:@"commentAnim"];
    
}


- (CAAnimation *)commentFlyAnimate:(CGPoint)startPoint{
    
    CGFloat duration = 3;
    
    // 位置
    CGPoint point0 = startPoint;
    
    CAKeyframeAnimation *positionAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim1.beginTime = 0;
    positionAnim1.duration = 1;
    positionAnim1.removedOnCompletion = YES;
    positionAnim1.fillMode = kCAFillModeRemoved;
    positionAnim1.repeatCount = 0;
    positionAnim1.calculationMode = kCAAnimationLinear;
    CGMutablePathRef curvedPath1 = CGPathCreateMutable();
    CGPoint point1 = CGPointMake(point0.x, point0.y - 48);
    CGPathMoveToPoint(curvedPath1, NULL, point0.x, point0.y);
    CGPathAddLineToPoint(curvedPath1, NULL,  point1.x, point1.y);
    positionAnim1.path = curvedPath1;
    CGPathRelease(curvedPath1);
    
    CAKeyframeAnimation *positionAnim2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim2.beginTime = 1;
    positionAnim2.duration = 1;
    positionAnim2.removedOnCompletion = YES;
    positionAnim2.fillMode = kCAFillModeRemoved;
    positionAnim2.repeatCount = 0;
    positionAnim2.calculationMode = kCAAnimationLinear;
    CGMutablePathRef curvedPath2 = CGPathCreateMutable();
    CGPoint point2 = CGPointMake(point1.x, point1.y);
    CGPathMoveToPoint(curvedPath2, NULL, point1.x, point1.y);
    CGPathAddLineToPoint(curvedPath2, NULL,  point2.x, point2.y);
    positionAnim2.path = curvedPath2;
    CGPathRelease(curvedPath2);
    
    CAKeyframeAnimation *positionAnim3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim3.beginTime = 2;
    positionAnim3.duration = 1;
    positionAnim3.removedOnCompletion = YES;
    positionAnim3.fillMode = kCAFillModeRemoved;
    positionAnim3.repeatCount = 0;
    positionAnim3.calculationMode = kCAAnimationLinear;
    CGPoint point3 = CGPointMake(point2.x, point2.y - 85);
    CGMutablePathRef curvedPath3 = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath3, NULL, point2.x, point2.y);
    CGPathAddLineToPoint(curvedPath3, NULL,  point3.x, point3.y);
    positionAnim3.path = curvedPath3;
    CGPathRelease(curvedPath3);
    
    // 比例
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:0.95];
    scaleAnim1.toValue = [NSNumber numberWithFloat:1];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = 0.33;
    
//    CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnim2.fromValue = [NSNumber numberWithFloat:0.9];
//    scaleAnim2.toValue = [NSNumber numberWithFloat:1.0];
//    scaleAnim2.removedOnCompletion = NO;
//    scaleAnim2.fillMode = kCAFillModeForwards;
//    scaleAnim2.beginTime = 0.33;
//    scaleAnim2.duration = 0.33;
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim1.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnim1.toValue = [NSNumber numberWithFloat:1.0];
    opacityAnim1.removedOnCompletion = NO;
    opacityAnim1.beginTime = 0.5;
    opacityAnim1.duration = 0.5;
    //正常显示stayAlpha1Sec秒后，再渐变alpha消失
    CABasicAnimation *opacityAnim2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim2.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim2.toValue = [NSNumber numberWithFloat:1.0];
    opacityAnim2.removedOnCompletion = NO;
    opacityAnim2.beginTime = 0.5;
    opacityAnim2.duration = 2.25 - 1;
    
    CABasicAnimation *opacityAnim3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim3.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim3.toValue = [NSNumber numberWithFloat:0];
    opacityAnim3.removedOnCompletion = NO;
    opacityAnim3.beginTime = 2.25;
    opacityAnim3.duration = duration - 2.25;

    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[positionAnim1,positionAnim2,positionAnim3,opacityAnim1,opacityAnim2,opacityAnim3,scaleAnim1];
    animGroup.duration = duration;
    
    return animGroup;
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    self.tabBarController.tabBar.hidden = NO;
//}

@end
