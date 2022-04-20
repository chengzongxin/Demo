//
//  TMUINavigationBar.m
//  Demo
//
//  Created by Joe.cheng on 2022/4/7.
//

#import "TMUINavigationBar.h"

@interface TMUINavigationBar ()

// 阴影线条
@property (nonatomic, strong) UIView *shadowView;
// 左边按钮容器
@property (nonatomic, strong) UIStackView *leftSpaceStackView;
// 右边按钮容器
@property (nonatomic, strong) UIStackView *rightSpaceStackView;

@end


@implementation TMUINavigationBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializationSubViews];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.centerTitleLabel.text = title;
}

- (void)setShadowView:(UIView *)shadowView {
    _shadowView = shadowView;
    self.shadowView.hidden = !shadowView;
}

- (void)addLeftViews:(NSArray<UIView *> *)view {
    [view enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.leftSpaceStackView addArrangedSubview:obj];
    }];
    self.leftSpaceStackView.spacing = 5;
}

- (void)addRightViews:(NSArray<UIView *> *)view {
    [view enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rightSpaceStackView addArrangedSubview:obj];
    }];
    self.rightSpaceStackView.spacing = 5;
}

- (void)initializationSubViews {
    
    // 默认背景颜色
    self.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1];
    
    self.hidenShadow = NO;
    
    self.leftSpaceStackView = [[UIStackView alloc] initWithArrangedSubviews:@[]];
    self.leftSpaceStackView.axis = UILayoutConstraintAxisHorizontal;
    [self addSubview:self.leftSpaceStackView];
    
    self.rightSpaceStackView = [[UIStackView alloc] initWithArrangedSubviews:@[]];
    self.rightSpaceStackView.axis = UILayoutConstraintAxisHorizontal;
    [self addSubview:self.rightSpaceStackView];
    
    self.shadowView = [[UIView alloc] init];
    self.shadowView.backgroundColor = [UIColor colorWithRed:180 / 255.0 green:180 / 255.0 blue:180 / 255.0 alpha:1];
    [self addSubview:self.shadowView];
    
    self.centerTitleLabel = [[UILabel alloc] init];
    self.centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.centerTitleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    self.centerTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.centerTitleLabel];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self addLeftViews:@[self.backButton]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 使用Autolayout为了不设置固定的宽
    self.leftSpaceStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.leftSpaceStackView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:15],
        [NSLayoutConstraint constraintWithItem:self.leftSpaceStackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.leftSpaceStackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:44],
    ]];
    
    self.rightSpaceStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.rightSpaceStackView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15],
        [NSLayoutConstraint constraintWithItem:self.rightSpaceStackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.rightSpaceStackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:44],
    ]];
        
    CGFloat leftSpaceWidth = CGRectGetWidth(self.bounds) - (CGRectGetMaxX(self.leftSpaceStackView.frame) + 5 + CGRectGetWidth(self.rightSpaceStackView.frame) + 5 + 15);
    CGFloat titleTextWidth = [self titleWidth:self.title];
    
    // 如果文字的宽度小于左右留的空隙则居中
    if (leftSpaceWidth >= titleTextWidth) {
        self.centerTitleLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - 44 / 2);
        self.centerTitleLabel.bounds = CGRectMake(0, 0, titleTextWidth, 44);
    } else {
        self.centerTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.leftSpaceStackView.frame) + 5, CGRectGetHeight(self.bounds) - 44, leftSpaceWidth, 44);
    }
    
    // 底部阴影线条
    self.shadowView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5);
}

- (CGFloat)titleWidth:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightBold]} context:nil].size.width;
}
@end
