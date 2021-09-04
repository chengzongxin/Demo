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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIImage *img = [UIImage imageNamed:@"diary_heart_fly"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//    imageView.frame = CGRectMake(point.x, point.y, img.size.width, img.size.height);
    imageView.frame = CGRectMake(200, 600, img.size.width, img.size.height);
    [self.navigationController.view addSubview:imageView];
    CGRect rect = [imageView tmui_convertRect:imageView.bounds toViewOrWindow:TMUI_AppWindow];
    
    [imageView.layer addAnimation:[self lightAnimationFrom:rect] forKey:nil];
    
    @weakify(imageView);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(imageView);
        [imageView removeFromSuperview];
    });
}


- (CAAnimation *)lightAnimationFrom:(CGRect)frame {
    CGPoint startP = frame.origin;
    CGPoint endP = CGPointMake(100, 100);
    CGFloat duration = 2.0;
    
    
//    CGMutablePathRef curvedPath = CGPathCreateMutable();
//    CGPoint point0 = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
//
//    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
//    NSInteger springWidth = frame.size.width * 1.5;
//    float x11 = point0.x - arc4random() % springWidth + springWidth;
//    float y11 = frame.origin.y - arc4random() % springWidth - springWidth;
//    float x1 = point0.x - arc4random() % (springWidth/2) + springWidth/2;
//    float y1 = y11 - arc4random() % springWidth - (springWidth * 1.3);
//    CGPoint point1 = CGPointMake(x1, y1);
//    CGPathAddQuadCurveToPoint(curvedPath, NULL, x11, y11, point1.x, point1.y);
    
//    int conffset2 = self.superview.bounds.size.width * 0.2;
//    int conffset21 = self.superview.bounds.size.width * 0.1;
//    float x2 = point0.x - arc4random() % conffset2 + conffset2;
//    float y2 = MAX(0.0, frame.origin.y - 280) + arc4random() % springWidth;
//    float x21 = point0.x - arc4random() % conffset21  + conffset21;
//    float y21 = (y2 + y1) / 2 + arc4random() % springWidth - springWidth;
//    CGPoint point2 = CGPointMake(x2, y2);
//    CGPathAddQuadCurveToPoint(curvedPath, NULL, x21, y21, point2.x, point2.y);
    
    // 位置
    CAKeyframeAnimation *positionAnim =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnim.beginTime = 0.1;
    positionAnim.duration = duration;
    positionAnim.removedOnCompletion = YES;
    positionAnim.fillMode = kCAFillModeRemoved;
    positionAnim.repeatCount = 0;
    positionAnim.calculationMode = kCAAnimationCubicPaced;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint point0 = startP;
    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
    CGPoint point1 = endP;
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 0, 0, point1.x, point1.y);
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
    scaleAnim2.toValue = [NSNumber numberWithFloat:0.5];
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
    animGroup.duration = 3;
    positionAnim.removedOnCompletion = YES;
    
    return animGroup;
}


@end
