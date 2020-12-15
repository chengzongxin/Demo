//
//  THKShadowImageView.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/15.
//

#import "THKShadowImageView.h"

@interface THKShadowImageView ()

@property (nonatomic, strong, readwrite) UIImageView *contentImageView;


@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat radius;
@end

@implementation THKShadowImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubviews];
    }
    return self;
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//
//    [self setLayerShadow:self.shadowColor offset:self.shadowOffset radius:self.radius];
//
//}

- (void)addSubviews{
    [self addSubview:self.contentImageView];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void)setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.shadowColor = color;
    self.shadowOffset = offset;
    self.radius = radius;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setLayerCorner:(CGFloat)corner borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    self.contentImageView.layer.cornerRadius = corner;
    self.contentImageView.layer.borderColor = color.CGColor;
    self.contentImageView.layer.borderWidth = borderWidth;
}

- (UIImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = UIImageView.new;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _contentImageView;
}

@end
