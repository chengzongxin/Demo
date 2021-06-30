//
//  THKMaterialTitleRankView.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKMaterialTitleRankView.h"

static CGFloat const kBlueAddWidth = 36;
static CGFloat const kGlodAddWidth = 23;

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
    
    if (self.style & (THKMaterialTitleRankViewStyleBlue | THKMaterialTitleRankViewStyleGold)) {
        /// 有皇冠
        self.topIcon.hidden = NO;
        self.topLeftLine.hidden = NO;
        self.topRightLine.hidden = NO;
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
    
    
    [self.topIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(self);
    }];
    
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        
        if (self.style & (THKMaterialTitleRankViewStyleBlue | THKMaterialTitleRankViewStyleGold)) {
            make.top.equalTo(self.topIcon.mas_bottom);
        }else{
            make.centerY.equalTo(self);
        }
    }];
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        if (self.style & (THKMaterialTitleRankViewStyleBlue | THKMaterialTitleRankViewStyleGold)) {
            make.top.equalTo(self.topIcon.mas_bottom);
        }else{
            make.centerY.equalTo(self);
        }
    }];
    
    [self.topLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topIcon);
        make.left.lessThanOrEqualTo(self.leftIcon.mas_right);
        make.right.equalTo(self.topIcon.mas_left).offset(-6.5);
        make.height.mas_equalTo(0.8);
    }];
    
    [self.topRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topIcon);
        make.left.equalTo(self.topIcon.mas_right).offset(6.5);
        make.width.mas_equalTo(self.topLeftLine);
        make.height.mas_equalTo(0.8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.style & (THKMaterialTitleRankViewStyleBlue | THKMaterialTitleRankViewStyleGold)) {
            make.centerY.equalTo(self.leftIcon);
            make.centerX.equalTo(self);
        }else{
            make.center.equalTo(self);
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIColor *theColor = self.style == THKMaterialTitleRankViewStyleBlue ? UIColorHex(#2D76CF) : UIColorHex(#FFE9BE);
    NSArray *colors = @[[UIColor colorWithRed:1 green:1 blue:1 alpha:0],theColor];
    [self.topLeftLine tmui_gradientWithColors:colors gradientType:TMUIGradientTypeLeftToRight locations:@[@0]];
    [self.topRightLine tmui_gradientWithColors:colors.tmui_reverse gradientType:TMUIGradientTypeLeftToRight locations:@[@0]];
}

#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{

}

- (void)setText:(NSString *)text{
    self.titleLabel.text = text;
    
    if (self.superview == nil) {
        return;
    }
    
    CGFloat textW = [self.titleLabel.text tmui_widthForFont:self.titleFont];
    CGSize size = CGSizeZero;
    if (self.style == THKMaterialTitleRankViewStyleBlue) {
        size.width = textW + kBlueAddWidth;
        size.height = 33;
    }else{
        size.width = textW + kGlodAddWidth;
        size.height = 19;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}


#pragma mark - Private



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
