//
//  ComponentViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/27.
//

#import "ComponentViewController.h"
#import "THKComboViewController.h"
#import "THKMaterialClassificationVC.h"
#import "THKMaterialClassificationVM.h"
#import "THKMaterialHotRankVC.h"
#import "THKMaterialHotRankVM.h"
#import "THKDiaryBookVC.h"
#import "DynamicTabDemoList.h"
#import "THKQuickCommentsView.h"
#import "THKSelectMaterialHomeVC.h"
#import "THKNewcomerProcessVC.h"
#import "TMUINavigationBarDemoListViewController.h"
#import "TMUICycleCardView.h"
#import "CycleCardCell.h"

@interface ComponentViewController ()

@end

@implementation ComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self homelist];
    
    [self test];
    
    [self comment];
}


- (void)homelist{
//    id b1 =
//        [self createBtn]
//        .str(@"如何选材")
//        .onClick(^{
//            TRouter *router = [TRouter routerWithName:THKRouterPage_SelectMaterialCategoryDetail
//                                                param:@{@"mainCategoryId" : @4}
//                                       jumpController:self];
//            [[TRouterManager sharedManager] performRouter:router];
//        });
//    
//    id b2 =
//        [self createBtn]
//        .str(@"热门排行榜")
//        .onClick(^{
//            THKMaterialHotRankVM *vm = [[THKMaterialHotRankVM alloc] init];
//            THKMaterialHotRankVC *vc = [[THKMaterialHotRankVC alloc] initWithViewModel:vm];
//            [self.navigationController pushViewController:vc animated:YES];
//        });
//    
//    
//    id b3 =
//        [self createBtn]
//        .str(@"日记本")
//        .onClick(^{
//            THKDiaryBookVM *vm = [[THKDiaryBookVM alloc] init];
//            THKDiaryBookVC *vc = [[THKDiaryBookVC alloc] initWithViewModel:vm];
//            [self.navigationController pushViewController:vc animated:YES];
//        });
//    
//    id b4 =
//        [self createBtn]
//        .str(@"Tab组件")
//        .onClick(^{
//            DynamicTabDemoList *vc = [[DynamicTabDemoList alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        });
//    
//    id b5 =
//        [self createBtn]
//        .str(@"选材")
//        .onClick(^{
//            THKSelectMaterialHomeVM *vm = [[THKSelectMaterialHomeVM alloc] init];
//            THKSelectMaterialHomeVC *vc = [[THKSelectMaterialHomeVC alloc] initWithViewModel:vm];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        });
//    
//    id b6 =
//        [self createBtn]
//        .str(@"新人流程")
//        .onClick(^{
//            THKNewcomerProcessVM *vm = [[THKNewcomerProcessVM alloc] init];
//            THKNewcomerProcessVC *vc = [[THKNewcomerProcessVC alloc] initWithViewModel:vm];
//            [vc showInSomeRootVC:self];
//        });
//    
//    id b7 =
//        [self createBtn]
//        .str(@"展开Label")
//        .onClick(^{
////            THKExpandLabelViewController *vc = [[THKExpandLabelViewController alloc] init];
////            [self.navigationController pushViewController:vc animated:YES];
//        });
//    
//    id b8 =
//        [self createBtn]
//        .str(@"连击")
//        .onClick(^{
//            THKComboViewController *vc = [[THKComboViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        });
//    
//    id b9 =
//        [self createBtn]
//        .str(@"导航栏")
//        .onClick(^{
//            TMUINavigationBarDemoListViewController *vc = [[TMUINavigationBarDemoListViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        });
//    
//    VerStack(b1,b2,b3,b4,b5,b6,b7,b8,b9)
//    .gap(10)
//    .embedIn(UIScrollView.new.embedIn(self.view), 0, 20, 80);
//    
//    
//    GroupTV(
//            Section(
//                    Row.str(@"交互头部和菜单Tab").fnt(18).detailStr(@"动态tab子VC").subtitleStyle.cellHeightAuto.onClick(^{
//                        TRouter *router = [TRouter routerWithName:THKRouterPage_SelectMaterialCategoryDetail
//                                                            param:@{@"mainCategoryId" : @4}
//                                                   jumpController:self];
//                        [[TRouterManager sharedManager] performRouter:router];
//                    }),
//                    Row.str(@"沉浸式交互Tab").fnt(18).detailStr(@"动态tab子VC").subtitleStyle.cellHeightAuto.onClick(^{
//                        THKMaterialHotRankVM *vm = [[THKMaterialHotRankVM alloc] init];
//                        THKMaterialHotRankVC *vc = [[THKMaterialHotRankVC alloc] initWithViewModel:vm];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }),
//                    Row.str(@"单Tab组件").fnt(18).detailStr(@"动态tab子VC").subtitleStyle.cellHeightAuto.onClick(^{
//                        
//                    }),
//                    )
//            ).header(@0.01).footer(@0.01).embedIn(self.view);
}



- (UIButton *)createBtn{
    return
    Button
    .color(@"white")
    .bgColor(@"random")
    .borderRadius(4)
    .fixWH(TMUI_SCREEN_WIDTH - 40,44);
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
}

- (void)arrayCrash{
    
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 0; i < 5000; i++) {
        
//        NSLog(@"%p",mArray);
        dispatch_async(queue2, ^{
            
            NSString *url = [NSString stringWithFormat:@"%p__%d.png",mArray,i];
            [mArray addObject:url];
        });
        
    }
}

- (void)cycleCard{
    
    TMUICycleCardView *cycle = [[TMUICycleCardView alloc] initWithFrame:CGRectMake(100, 200, 230, 155)];
    [cycle registerCell:[CycleCardCell class]];
    [self.view addSubview:cycle];
    [cycle configCell:^(UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull model) {
        CycleCardCell *cardCell = (CycleCardCell *)cell;
        cardCell.textLbl.text = model;
    }];
    // 设置数据
    cycle.models = @[@"1",@"2",@"3"];
}

//CAAnimation *_anim;
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%@,%@",touches,event);
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(300, 300, 100, 30)];
//    view.backgroundColor = UIColor.tmui_randomColor;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    label.text = @"开工大吉";
//    [view addSubview:label];
////    view.layer.anchorPoint = CGPointMake(0, 0);
//    [self.navigationController.view addSubview:view];
//    CAAnimation *anim = [self commentFlyAnimate:CGPointMake(300, 300)];
//    __weak typeof(view) weakView = view;
//    anim.tmui_animationDidStopBlock = ^(__kindof CAAnimation * _Nonnull aAnimation, BOOL finished) {
//        [weakView removeFromSuperview];
//    };
//    [view.layer addAnimation:anim forKey:@"commentAnim"];
//
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%@,%@",touches,event);
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%@,%@",touches,event);
//}

- (void)test{
    
    // File: ani@3x.gif
//    UIImage *image = [YYImage imageNamed:@"718.apng"];
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
    [imageView setImageURL:[NSURL URLWithString:@"https://pic.to8to.com/infofed/20210701/d8377a0ac76c9c965d1fe3ca8295e27a.webp"]];
    [self.view addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.bottom.mas_equalTo(-100);
        make.width.height.mas_equalTo(100);
    }];
    
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
