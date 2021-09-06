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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *image = [[UIImage imageNamed:@"diary_noti_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 2) resizingMode:UIImageResizingModeTile];
    UIButton *button = [[UIButton alloc] init];

    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.whiteColor;
//    label.backgroundColor = [UIColor redColor];
    label.text = @"日本动漫dsadsadsadsafdjhdsads  dsa";
    label.font = [UIFont systemFontOfSize:15];
    //计算label的宽度
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByTruncatingTail;

    CGSize size = [label.text boundingRectWithSize:CGSizeMake(150, 20)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:textStyle}
                                            context:nil].size;

    CGFloat labelW = ceil(size.width) + 1;
    label.frame = CGRectMake(10, 4, labelW, 20);
    [button addSubview:label];

    button.frame = CGRectMake(100, 200, image.size.width + labelW - 8, image.size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:button];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
////    [self test];
//
//    UIImage *image = [UIImage imageNamed:@"diary_noti_bg"];
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 10) resizingMode:UIImageResizingModeTile];
//    UIImageView *imgV = [[UIImageView alloc] initWithImage:image];
//    imgV.image = image;
//    imgV.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:imgV];
//
//    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(200);
//        make.left.mas_equalTo(100);
//        make.size.mas_equalTo(CGSizeMake(200, 36));
//    }];
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self animate1:1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animate1:2];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animate1:3];
    });
}

- (void)animate1:(NSInteger)animateType{
    UIImage *img = [UIImage imageNamed:@"diary_heart_fly"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(-1000, -1000, img.size.width, img.size.height);
    [self.navigationController.view addSubview:imageView];
    imageView.alpha = 0;
//    CGRect rect = [imageView tmui_convertRect:imageView.bounds toViewOrWindow:TMUI_AppWindow];
    
    
    CGPoint startPoint = CGPointMake(200, 700);
    CGPoint endPoint = CGPointMake(100, 80);
    
    CAAnimation *animate;
    
    switch (animateType) {
        case 1:
            animate = [self heartFlyAnimate1:startPoint endPoint:endPoint];
            break;
        case 2:
            animate = [self heartFlyAnimate2:startPoint endPoint:endPoint];
            break;
        case 3:
            animate = [self heartFlyAnimate3:startPoint endPoint:endPoint];
            break;
            
        default:
            break;
    }
    
    [imageView.layer addAnimation:animate forKey:nil];
    
    @weakify(imageView);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(imageView);
        [imageView removeFromSuperview];
    });
}


- (CAAnimation *)heartFlyAnimate1:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGPoint controlPoint = CGPointMake(startPoint.x + 200, (startPoint.y - endPoint.y)/2);
    CGFloat duration = 2.0;
    
    // 位置
    CAKeyframeAnimation *positionAnim =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.beginTime = 0;
    positionAnim.duration = duration;
    positionAnim.removedOnCompletion = YES;
    positionAnim.fillMode = kCAFillModeRemoved;
    positionAnim.repeatCount = 0;
    positionAnim.calculationMode = kCAAnimationCubicPaced;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint point0 = startPoint;
    CGPoint point1 = endPoint;
    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint.x, controlPoint.y, point1.x, point1.y);
    positionAnim.path = curvedPath;
    
    CGPathRelease(curvedPath);
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    float stayAlpha1Sec = 1;
    CABasicAnimation *opacity1Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity1Anim.fromValue = [NSNumber numberWithFloat:0.1];
    opacity1Anim.toValue = [NSNumber numberWithFloat:1.0];
    opacity1Anim.removedOnCompletion = NO;
    opacity1Anim.beginTime = 0;
    opacity1Anim.duration = stayAlpha1Sec;
    
    //正常显示stayAlpha1Sec秒后，再渐变alpha消失
    CABasicAnimation *opacity2Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity2Anim.fromValue = [NSNumber numberWithFloat:1.0];
    opacity2Anim.toValue = [NSNumber numberWithFloat:0];
    opacity2Anim.removedOnCompletion = NO;
    opacity2Anim.beginTime = stayAlpha1Sec;
    opacity2Anim.duration = duration - stayAlpha1Sec;
    
    // 比例
    float stayScale1Sec = 1;
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:0.1];
    scaleAnim1.toValue = [NSNumber numberWithFloat:1];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = stayScale1Sec;
    
    CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim2.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim2.toValue = [NSNumber numberWithFloat:0.2];
    scaleAnim2.removedOnCompletion = NO;
    scaleAnim2.fillMode = kCAFillModeForwards;
    scaleAnim2.beginTime = duration - stayScale1Sec;
    scaleAnim2.duration = duration - stayScale1Sec;
    
    // 旋转
    float stayRotation1Sec = 1;
    CABasicAnimation *rotationAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnim1.fromValue = [NSNumber numberWithFloat:0.5 * M_PI];
    rotationAnim1.toValue = [NSNumber numberWithFloat:0];
    rotationAnim1.removedOnCompletion = NO;
    rotationAnim1.fillMode = kCAFillModeForwards;
    rotationAnim1.beginTime = 0;
    rotationAnim1.duration = stayRotation1Sec;
    
    CABasicAnimation *rotationAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnim2.fromValue = [NSNumber numberWithFloat:0];
    rotationAnim2.toValue = [NSNumber numberWithFloat:-0.3 * M_PI];
    rotationAnim2.removedOnCompletion = NO;
    rotationAnim2.fillMode = kCAFillModeForwards;
    rotationAnim2.beginTime = duration - stayRotation1Sec;
    rotationAnim2.duration = duration - stayRotation1Sec;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[scaleAnim1, scaleAnim2, rotationAnim1, rotationAnim2, opacity1Anim, opacity2Anim, positionAnim];
    animGroup.duration = duration;
    positionAnim.removedOnCompletion = YES;
    
    return animGroup;
}

- (CAAnimation *)heartFlyAnimate2:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGPoint controlPoint = CGPointMake(startPoint.x - 200, startPoint.y);
    CGFloat duration = 2.0;
    
    // 位置
    CAKeyframeAnimation *positionAnim =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.beginTime = 0;
    positionAnim.duration = duration;
    positionAnim.removedOnCompletion = YES;
    positionAnim.fillMode = kCAFillModeRemoved;
    positionAnim.repeatCount = 0;
    positionAnim.calculationMode = kCAAnimationCubicPaced;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint point0 = startPoint;
    CGPoint point1 = endPoint;
    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint.x, controlPoint.y, point1.x, point1.y);
    positionAnim.path = curvedPath;
    
    CGPathRelease(curvedPath);
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    float stayAlpha1Sec = 1;
    CABasicAnimation *opacity1Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity1Anim.fromValue = [NSNumber numberWithFloat:0.1];
    opacity1Anim.toValue = [NSNumber numberWithFloat:1.0];
    opacity1Anim.removedOnCompletion = NO;
    opacity1Anim.beginTime = 0;
    opacity1Anim.duration = stayAlpha1Sec;
    
    //正常显示stayAlpha1Sec秒后，再渐变alpha消失
    CABasicAnimation *opacity2Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity2Anim.fromValue = [NSNumber numberWithFloat:1.0];
    opacity2Anim.toValue = [NSNumber numberWithFloat:0];
    opacity2Anim.removedOnCompletion = NO;
    opacity2Anim.beginTime = stayAlpha1Sec;
    opacity2Anim.duration = duration - stayAlpha1Sec;
    
    // 比例
    float stayScale1Sec = 1;
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:0.1];
    scaleAnim1.toValue = [NSNumber numberWithFloat:1];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = stayScale1Sec;
    
    CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim2.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim2.toValue = [NSNumber numberWithFloat:0.2];
    scaleAnim2.removedOnCompletion = NO;
    scaleAnim2.fillMode = kCAFillModeForwards;
    scaleAnim2.beginTime = duration - stayScale1Sec;
    scaleAnim2.duration = duration - stayScale1Sec;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[scaleAnim1, scaleAnim2, opacity1Anim, opacity2Anim, positionAnim];
    animGroup.duration = duration;
    positionAnim.removedOnCompletion = YES;
    
    return animGroup;
}

- (CAAnimation *)heartFlyAnimate3:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGPoint controlPoint0 = CGPointMake(startPoint.x, (startPoint.y + endPoint.y) / 2);
    CGPoint controlPoint1 = CGPointMake((startPoint.x + endPoint.x) /2, endPoint.y - 50);
    CGFloat duration = 2.0;
    
    // 位置
    CAKeyframeAnimation *positionAnim =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.beginTime = 0;
    positionAnim.duration = duration;
    positionAnim.removedOnCompletion = YES;
    positionAnim.fillMode = kCAFillModeRemoved;
    positionAnim.repeatCount = 0;
    positionAnim.calculationMode = kCAAnimationCubicPaced;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint point0 = startPoint;
    CGPoint point1 = endPoint;
    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint0.x, controlPoint0.y, point0.x, point1.y);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, controlPoint1.x, controlPoint1.y, point1.x, point1.y);
    positionAnim.path = curvedPath;
    
    CGPathRelease(curvedPath);
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    float stayAlpha1Sec = 1;
    CABasicAnimation *opacity1Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity1Anim.fromValue = [NSNumber numberWithFloat:0.1];
    opacity1Anim.toValue = [NSNumber numberWithFloat:1.0];
    opacity1Anim.removedOnCompletion = NO;
    opacity1Anim.beginTime = 0;
    opacity1Anim.duration = stayAlpha1Sec;
    
    //正常显示stayAlpha1Sec秒后，再渐变alpha消失
    CABasicAnimation *opacity2Anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity2Anim.fromValue = [NSNumber numberWithFloat:1.0];
    opacity2Anim.toValue = [NSNumber numberWithFloat:0];
    opacity2Anim.removedOnCompletion = NO;
    opacity2Anim.beginTime = stayAlpha1Sec;
    opacity2Anim.duration = duration - stayAlpha1Sec;
    
    // 比例
    float stayScale1Sec = 1;
    CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim1.fromValue = [NSNumber numberWithFloat:0.1];
    scaleAnim1.toValue = [NSNumber numberWithFloat:1];
    scaleAnim1.removedOnCompletion = NO;
    scaleAnim1.fillMode = kCAFillModeForwards;
    scaleAnim1.beginTime = 0;
    scaleAnim1.duration = stayScale1Sec;
    
    CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim2.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim2.toValue = [NSNumber numberWithFloat:0.2];
    scaleAnim2.removedOnCompletion = NO;
    scaleAnim2.fillMode = kCAFillModeForwards;
    scaleAnim2.beginTime = duration - stayScale1Sec;
    scaleAnim2.duration = duration - stayScale1Sec;
    
    // 旋转
    float stayRotation1Sec = 1;
    CABasicAnimation *rotationAnim1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnim1.fromValue = [NSNumber numberWithFloat:-0.5 * M_PI];
    rotationAnim1.toValue = [NSNumber numberWithFloat:0];
    rotationAnim1.removedOnCompletion = NO;
    rotationAnim1.fillMode = kCAFillModeForwards;
    rotationAnim1.beginTime = 0;
    rotationAnim1.duration = stayRotation1Sec;
    
    CABasicAnimation *rotationAnim2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnim2.fromValue = [NSNumber numberWithFloat:0];
    rotationAnim2.toValue = [NSNumber numberWithFloat:0.3 * M_PI];
    rotationAnim2.removedOnCompletion = NO;
    rotationAnim2.fillMode = kCAFillModeForwards;
    rotationAnim2.beginTime = duration - stayRotation1Sec;
    rotationAnim2.duration = duration - stayRotation1Sec;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[scaleAnim1, scaleAnim2, opacity1Anim, opacity2Anim, rotationAnim1, rotationAnim2,positionAnim];
    animGroup.duration = duration;
    positionAnim.removedOnCompletion = YES;
    
    return animGroup;
}


- (void)test{
    
    
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
    
    NSString *tag = @"#123入住新家#  ";
    NSString *str = @"hdhhdsa  来电文字大萨达俺爹是  dfsfdshhfesf sddsfkjd lkfdsj lfjh sdjkfhk egf hsjfg dhs fghdsfg ewhj dfgjshf jdshfg hdsf gdsfdsfd asdhjk dhkaj方加快速度发多少粉红色的发多askj ldksaf jldsafafdsafewsa fds fadsf das fdas fdsaf dsaf dsaf dsaefrg 12313123213 sdad  来电文字大萨达俺爹是  佛挡杀佛第三方加快速度发多少粉红dsad发多少";
    
    THKExpandLabel *label = THKExpandLabel.new;
    
    label.numberOfLines = 5;
    label.lineGap = 6;
    label.maxWidth = TMUI_SCREEN_WIDTH - 100;
    label.preferFont = UIFont(16);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(50);
        make.top.mas_equalTo(400);
    }];
    @weakify(label);
    label.unfoldClick = ^{
        @strongify(label);
        NSLog(@"%@",label.text);
    };
//    label.tagStr = @"入住新家";
//    label.contentStr = str;
//    [label setTagStr:@"#123入住新家#  " contentStr:str];
    [label setTagStr:tag
         tagAttrDict:@{NSForegroundColorAttributeName:THKColor_999999,NSFontAttributeName:UIFontMedium(16)}
          contentStr:str
     contentAttrDict:@{NSForegroundColorAttributeName:UIColorHex(#1A1C1A),NSFontAttributeName:UIFont(16)}];
}

@end
