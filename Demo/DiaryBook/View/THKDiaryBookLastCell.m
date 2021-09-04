//
//  THKDiaryBookLastCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/27.
//

#import "THKDiaryBookLastCell.h"
#import "THKDiaryBookCell.h"
#import "THKDiaryCircleView.h"

@interface THKDiaryBookLastCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) THKDiaryCircleView *circleView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *updateButton;

@property (nonatomic, strong) RACSubject *urgeUpdateSubject;

@property (nonatomic, assign) CGPoint animateStartPoint;
@property (nonatomic, assign) CGPoint animateEndPoint;

@end

@implementation THKDiaryBookLastCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.updateButton];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView.mas_centerX);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(2);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(THKDiaryCircleWidth);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kDiaryContentInset.left);
        make.right.mas_equalTo(-kDiaryContentInset.right);
    }];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(50);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(140, 50));
    }];
     
    [self.contentLabel tmui_setAttributesString:@"屋主还在为自己的家努力，你可以提醒TA继续更新～" lineSpacing:6];
    self.circleView.hidden = YES;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    [self addParticleEffect];
}

- (void)updateButtonClick:(UIButton *)btn{
    
    CGRect rect = [btn.imageView tmui_convertRect:btn.imageView.bounds toViewOrWindow:TMUI_AppWindow];
    self.animateStartPoint = rect.origin;
    self.animateEndPoint = CGPointMake(100, 80);
    [self addHeartFlyAnimate];
    
    [self.urgeUpdateSubject sendNext:nil];
}

- (void)addHeartFlyAnimate{
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
    [self.tmui_viewController.navigationController.view addSubview:imageView];
    imageView.alpha = 0;
    
    CGPoint startPoint = self.animateStartPoint;
    CGPoint endPoint = self.animateEndPoint;
    
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

- (void)bindViewModel:(THKDiaryBookCellVM *)viewModel{
    
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize realSize = CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(kDiaryContentInset), 0);
    
    realSize.height += [self.contentLabel tmui_sizeForWidth:realSize.width].height;
    realSize.height += 150;
    
    return realSize;
}


- (THKDiaryCircleView *)circleView{
    if (!_circleView) {
        _circleView = [[THKDiaryCircleView alloc] init];
        _circleView.type = THKDiaryCircleType_Row;
    }
    return _circleView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorHex(ECEEEC);
    }
    return _lineView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = UIColorHex(010101);
        _contentLabel.font = UIFont(16);
    }
    return _contentLabel;
}

- (UIButton *)updateButton{
    if (!_updateButton) {
        _updateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 50)];
        _updateButton.backgroundColor = UIColor.whiteColor;
        _updateButton.tmui_image = UIImageMake(@"diary_bixin_icon");
        _updateButton.tmui_text = @"求更新";
        _updateButton.layer.cornerRadius = 25;
        _updateButton.layer.borderColor = UIColorHex(F6F8F6).CGColor;
        _updateButton.layer.borderWidth = 0.5;
        _updateButton.tmui_font = UIFont(16);
        _updateButton.tmui_titleColor = UIColorHex(333533);
        [_updateButton.layer tmui_setLayerShadow:UIColor.blackColor offset:CGSizeMake(0, 5) alpha:0.05 radius:5 spread:0];
        [_updateButton tmui_addTarget:self action:@selector(updateButtonClick:)];
    }
    return _updateButton;
}

TMUI_PropertyLazyLoad(RACSubject, urgeUpdateSubject);

@end
