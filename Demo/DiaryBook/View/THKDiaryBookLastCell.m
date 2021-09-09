//
//  THKDiaryBookLastCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/27.
//

#import "THKDiaryBookLastCell.h"
#import "THKDiaryBookCell.h"
#import "THKDiaryCircleView.h"
#import "UIView+THKDiaryAnimation.h"
//#import "THKHalfPresentLoginVC.h"

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)updateButtonClick:(UIButton *)btn{
    
    dispatch_block_t next = ^{
//        if (kCurrentUser.uid == self.uid) {
//            return;
//        }
        
        [self addAnimations];
        
        [self.urgeUpdateSubject sendNext:nil];
    };
    
//    if (![kCurrentUser isLoginStatus]) {
//        [THKHalfPresentLoginVC judgeLoginStateWithLoginedHandler:^(id obj) {
//            next();
//        } failHandler:^(id obj) {
//        }];
//    } else {
//        next();
//    }
    next();
}

- (void)addAnimations{
    [self btnAnimation];
    
    [self heartAnimation];
}


- (void)btnAnimation{
    if (self.updateButton.imageView.layer.animationKeys.count == 0) {
        CAAnimation *scaleImgAnimate = [self imageViewScale];
        [self.updateButton.imageView.layer addAnimation:scaleImgAnimate forKey:@"btnScale"];
        
        
        CAAnimation *bgColorAnimate = [self backgroundGlowAnimationFromColor:UIColor.whiteColor toColor:UIColorHex(F6F8F6)];
        [self.updateButton.layer addAnimation:bgColorAnimate forKey:@"backgroundColor"];
        
    }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDiaryAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationStartBlock) {
                    self.animationStartBlock();
                }
            });
}


- (void)heartAnimation{
    CGRect rect = [self.updateButton.imageView tmui_convertRect:self.updateButton.imageView.bounds toViewOrWindow:TMUI_AppWindow];
    self.animateStartPoint = CGPointMake(CGRectGetCenter(rect).x, rect.origin.y);
//    self.animateEndPoint = CGPointMake(66, 66);
    
    [self animate:arc4random()%4+1];
}

- (void)animate:(NSInteger)animateType{
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

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.animationStartBlock) {
        self.animationStartBlock();
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
