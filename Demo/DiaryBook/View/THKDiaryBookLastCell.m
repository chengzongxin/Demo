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
    [self addParticleEffect:CGPointMake(btn.centerX, btn.y)];
    
    [self.urgeUpdateSubject sendNext:nil];
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

TMUI_PropertyLazyLoad(RACSubject, urgeUpdateSubject);

@end
