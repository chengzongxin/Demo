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
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    [self addParticleEffect];
}

- (void)updateButtonClick:(UIButton *)btn{
//    [self addParticleEffect:CGPointMake(btn.centerX, btn.y)];

    [self heartEffect:CGPointMake(btn.centerX, btn.y)];
}

- (void)heartEffect:(CGPoint)point{
    
    UIImage *img = [UIImage imageNamed:@"diary_bixin_icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(point.x, point.y, img.size.width, img.size.height);
    [self.contentView addSubview:imageView];
    
    CGRect rect = [imageView tmui_convertRect:imageView.bounds toViewOrWindow:TMUI_AppWindow];
    
    [imageView.layer addAnimation:[self lightAnimationFrom:rect] forKey:nil];
    
    @weakify(imageView);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(imageView);
        [imageView removeFromSuperview];
    });
}

- (CAAnimation *)lightAnimationFrom:(CGRect)frame {
    
    // 位置
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.beginTime = 0.1;
    animation.duration = 2.0;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 0;
    animation.calculationMode = kCAAnimationCubicPaced;
    
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
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint point0 = frame.origin;
    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
    CGPoint point1 = CGPointMake(100, 100);
//    CGPathAddQuadCurveToPoint(curvedPath, NULL, 0, 0, point1.x, point1.y);
    CGPathAddLineToPoint(curvedPath, NULL, point1.x, point1.y);
//    CGPathCloseSubpath(curvedPath);
    animation.path = curvedPath;
    
    CGPathRelease(curvedPath);
    
    // 透明度变化
    //因视图设置了alpha为0，为了一开始能正常显示出来，这里加一个固定stayAlpha1Sec秒，alpha为1的动画(仅仅是为了在前stayAlpha1Sec秒内视图能正常显示出来)
    float stayAlpha1Sec = 1;
    CABasicAnimation *opacityAnim_alphaOf1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim_alphaOf1.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim_alphaOf1.toValue = [NSNumber numberWithFloat:1.0];
    opacityAnim_alphaOf1.removedOnCompletion = NO;
    opacityAnim_alphaOf1.beginTime = 0;
    opacityAnim_alphaOf1.duration = stayAlpha1Sec;
    
    //正常显示stayAlpha1Sec秒后，再渐变alpha消失
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0];
    opacityAnim.removedOnCompletion = NO;
    opacityAnim.beginTime = stayAlpha1Sec;
    opacityAnim.duration = 3 - stayAlpha1Sec;
    
    // 比例
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = [NSNumber numberWithFloat:.0];
    scaleAnim.toValue = [NSNumber numberWithFloat:1];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.fillMode = kCAFillModeForwards;
    scaleAnim.duration = .5;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects: scaleAnim, opacityAnim, animation, opacityAnim_alphaOf1, nil];
    animGroup.duration = 3;
    
    return animGroup;
}


- (void)addParticleEffect:(CGPoint)point{
    self.layer.zPosition = 9999;
    [self removeParticleEffect];
    // 1.创建发射器
    CAEmitterLayer *emitter = [[CAEmitterLayer alloc] init];
    // 2.发射器位置
    emitter.emitterPosition = point;
    // 3.开启三维效果
    emitter.preservesDepth = true;
    
    NSMutableArray *cells = [NSMutableArray array];
    for (int i = 0; i < 1; i++) {
        // 4.设置 Cell(对应其中一个粒子)
        // 4.0.创建粒子
        CAEmitterCell *cell = [[CAEmitterCell alloc] init];
        // 4.1.每秒发射粒子数
        cell.birthRate = 1;
        // 4.2.粒子存活时间
        cell.lifetime = 5;
        cell.lifetimeRange = 2.5;
        // 4.3.缩放比例
        cell.scale = 3;
        cell.scaleRange = 0.3;
        // 4.4.粒子发射方向
        cell.emissionLongitude = -M_PI_2;
        cell.emissionRange = M_PI_4 * 0.6;
        // 4.5.粒子速度
        cell.velocity = 100;
        cell.velocityRange = 50;
        // 4.6.旋转速度
//        cell.spin = M_PI_2;
        // 4.7.粒子内容
        cell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"icon_crown_yellow"].CGImage);
        [cells addObject:cell];;
    }
    // 5.将粒子添加到发射器中
    emitter.emitterCells = cells;
    [self.layer addSublayer:emitter];
}

- (void)removeParticleEffect{
    NSArray *emitters = [self.layer.sublayers tmui_filter:^BOOL(__kindof CALayer * _Nonnull item) {
        return [item isKindOfClass:CAEmitterLayer.class];
    }];
    
    if (emitters.count) {
        [emitters makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    }
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

@end
