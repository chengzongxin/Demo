//
//  THKMaterialTitleRankView.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKMaterialTitleRankView.h"

@interface THKMaterialTitleRankView ()

@property (nonatomic, assign) THKMaterialTitleRankViewStyle style;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIImageView *topIcon;
@property (nonatomic, strong) UIView *topLeftLine;
@property (nonatomic, strong) UIView *topRightLine;
@property (nonatomic, strong) UIImageView *leftIcon;
@property (nonatomic, strong) UIImageView *rightIcon;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation THKMaterialTitleRankView
#pragma mark - Life Cycle
- (void)dealloc{
    NSLog(@"%@ did dealloc",self);
}

/// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

/// init or initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (instancetype)initWithStyle:(THKMaterialTitleRankViewStyle)style titleFont:(UIFont *)titleFont{
    if (self = [super init]) {
        self.style = style;
        self.titleFont = titleFont;
        
        [self didInitalize];
    }
    return self;
}

- (void)didInitalize{
    
    NSAssert(self.titleFont, @"必须设置字体");
    
    if (self.style & (THKMaterialTitleRankViewStyleBlue | THKMaterialTitleRankViewStyleBlue_NoCrown)) {
        /// 蓝色
        self.topIcon.image = UIImageMake(@"icon_crown_blue");
        self.leftIcon.image = UIImageMake(@"icon_left_olive_blue");
        self.rightIcon.image = UIImageMake(@"icon_right_olive_blue");
        self.titleLabel.textColor = UIColorHex(#2D76CF);
    }else{
        /// 金色
        self.topIcon.image = UIImageMake(@"icon_crown_yellow");
        self.leftIcon.image = UIImageMake(@"icon_left_olive_yellow");
        self.rightIcon.image = UIImageMake(@"icon_right_olive_yellow");
        self.titleLabel.textColor = UIColorHex(#FFE9BE);
    }
    
    BOOL hadCrown = [self hadCrwon];
    
    if (hadCrown) {
        /// 有皇冠
        self.topIcon.hidden = NO;
        self.topLeftLine.hidden = NO;
        self.topRightLine.hidden = NO;
        self.topLeftLine.cornerRadius = 1;
        self.topRightLine.cornerRadius = 1;
    }else{
        /// 无皇冠
        self.topIcon.hidden = YES;
        self.topLeftLine.hidden = YES;
        self.topRightLine.hidden = YES;
    }
    
    self.titleLabel.font = self.titleFont;
    
    [self addSubview:self.topIcon];
    [self addSubview:self.topLeftLine];
    [self addSubview:self.topRightLine];
    [self addSubview:self.leftIcon];
    [self addSubview:self.rightIcon];
    [self addSubview:self.titleLabel];
    
    if (hadCrown) {
        [self hadCrownLayout];
    }else{
        [self noCrownLayout];
    }
    
    
    NSLog(@"font = %@,fontsize = %f,lh = %f",self.titleFont,self.titleFont.pointSize,self.titleLabel.font.lineHeight);
}


- (void)hadCrownLayout{
    
    [self.topIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(self.topIcon.image.size);
    }];
    
    [self.topLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topIcon);
        make.left.lessThanOrEqualTo(self.leftIcon.mas_right);
        make.right.equalTo(self.topIcon.mas_left).offset(-6.5);
        make.height.mas_equalTo(1);
    }];
    
    [self.topRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topIcon);
        make.left.equalTo(self.topIcon.mas_right).offset(6.5);
        make.width.mas_equalTo(self.topLeftLine);
        make.height.mas_equalTo(1);
    }];
    
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.topLeftLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.equalTo(self.topRightLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.equalTo(self);
    }];
}

- (void)noCrownLayout{
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIColor *theColor = self.style == THKMaterialTitleRankViewStyleBlue ? UIColorHex(#2D76CF) : UIColorHex(#FFE9BE);
    NSArray *colors = @[[UIColor colorWithRed:1 green:1 blue:1 alpha:0],theColor];
    BOOL hadCrown = [self hadCrwon];
    if (hadCrown) {
        [self.topLeftLine tmui_gradientWithColors:colors gradientType:TMUIGradientTypeLeftToRight locations:@[@0]];
        [self.topRightLine tmui_gradientWithColors:colors.tmui_reverse gradientType:TMUIGradientTypeLeftToRight locations:@[@0]];
    }
}

#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{

}

- (void)setText:(NSString *)text{
    self.titleLabel.text = text;
    
    
    NSLog(@"font = %@,fontsize = %f",self.titleFont,self.titleFont.pointSize);
    
    if (self.superview == nil) {
        return;
    }
    
    CGFloat textW = [self.titleLabel.text tmui_widthForFont:self.titleFont];
    CGFloat addWidth = self.titleLabel.font.lineHeight * 0.8 * 2; // 左右增加的按字体大小增加0.8 * 2倍
    CGFloat width = textW + addWidth;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}


#pragma mark - Private
- (BOOL)hadCrwon{
    return self.style & (THKMaterialTitleRankViewStyleBlue | THKMaterialTitleRankViewStyleGold);
}


#pragma mark - Getter && Setter


TMUI_PropertyLazyLoad(UIImageView, topIcon)
TMUI_PropertyLazyLoad(UIView, topLeftLine)
TMUI_PropertyLazyLoad(UIView, topRightLine)
TMUI_PropertyLazyLoad(UIImageView, leftIcon)
TMUI_PropertyLazyLoad(UIImageView, rightIcon)

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

@end
