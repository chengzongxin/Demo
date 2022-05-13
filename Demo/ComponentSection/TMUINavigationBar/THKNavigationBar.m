//
//  THKNavigationBar.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import "THKNavigationBar.h"
#import "THKNavigationAvatarTitleView.h"
#import "THKNavigationBarSearchViewModel.h"

@interface THKNavigationBar ()

@property (nonatomic, strong) THKNavigationBarViewModel *viewModel;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *contentSubView;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;

@property (nonatomic, assign) BOOL hasApplyAppearence;

@end


@implementation THKNavigationBar
@dynamic viewModel;

static NSDictionary *config = nil;
static NSString const *kBackIconKey = @"kBackIconKey";
static NSString const *kTintColorKey = @"kTintColorKey";
static NSString const *kBackgroundKey = @"kBackgroundKey";
static NSString const *kRighticonKey = @"kRighticonKey";
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = @{
            @(THKNavigationBarStyle_Light):@{
                kBackIconKey:[UIImage imageNamed:@"nav_back_black"],
                kBackgroundKey:UIColor.whiteColor,
                kTintColorKey:UIColor.blackColor,
                kRighticonKey:[UIImage imageNamed:@"nav_share_black"],
            },
            @(THKNavigationBarStyle_Dark):@{
                kBackIconKey:[UIImage imageNamed:@"nav_back_white"],
                kBackgroundKey:UIColor.blackColor,
                kTintColorKey:UIColor.whiteColor,
                kRighticonKey:[UIImage imageNamed:@"nav_share_white"],
            },
        };
    
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    THKNavigationBar *appearance = [THKNavigationBar appearance];
    // 应用外观时会走到这里，然后调用applyStyle设置属性，注意需要所有成员不为nil，否则应用失效
    [appearance applyStyle:THKNavigationBarStyle_Light];
    
}

- (void)applyStyle:(THKNavigationBarStyle)style{
    if (self.hasApplyAppearence) {
        // init 应用后，在view渲染的时候就不重复应用，避免覆盖后面修改了配置
        return;
    }
    [self setBarStyle:style];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, tmui_navigationBarHeight())]) {
        _isBackButtonHidden = NO;
        _isRightButtonHidden = YES;
        // 左
        UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn = backBtn;
        [backBtn addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.equalTo(self);
            make.width.equalTo(@54);
            make.height.equalTo(@44);
        }];
        
        // 右
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn = rightBtn;
        [rightBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(self);
            make.height.equalTo(@44);
            make.width.equalTo(@0);
        }];
        
        // 中
        UIView * contentView = [[UIView alloc] init];
        _contentView = contentView;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backBtn.mas_right);
            make.right.equalTo(_rightBtn.mas_left).offset(-20);
            make.bottom.equalTo(self);
            make.height.equalTo(@44);
        }];
        
        [self tmui_applyAppearance];
        self.hasApplyAppearence = YES;
    }
    return self;
}

- (void)navBackAction:(UIButton *)btn
{
    UIViewController * nexResponder = self.viewController;
    if ([nexResponder respondsToSelector:@selector(navBackAction:)]) {
        [nexResponder navBackAction:btn];
    }
#if DEBUG
    else {
        NSString * msg = [NSString stringWithFormat:@"`%@` does not respondsToSelector `%@`", [nexResponder class], NSStringFromSelector(_cmd)];
        NSAssert(NO, msg);
    }
#endif
}

- (void)shareAction
{
    UIViewController * nexResponder = self.viewController;
    if ([nexResponder respondsToSelector:@selector(shareAction)]) {
        [(id)nexResponder shareAction];
    }
#if DEBUG
    else {
        NSString * msg = [NSString stringWithFormat:@"`%@` does not respondsToSelector `%@`", [nexResponder class], NSStringFromSelector(_cmd)];
        NSAssert(NO, msg);
    }
#endif
}


#pragma mark - Public

- (void)bindViewModel{
    [super bindViewModel];
    
    if (self.viewModel.contentType == THKNavigationBarContentType_Normal) {
        // 常规导航栏
        if (self.viewModel.attrTitle) {
            [self setAttrTitle:self.viewModel.attrTitle];
        } else if (self.viewModel.title) {
            [self setTitle:self.viewModel.title];
        }
    }else if (self.viewModel.contentType == THKNavigationBarContentType_Avatar) {
        // 用户信息
        THKNavigationAvatarTitleView *avatar = [[THKNavigationAvatarTitleView alloc] initWithViewModel:self.viewModel];
        self.titleView = avatar;
    }else if (self.viewModel.contentType == THKNavigationBarContentType_Search) {
        // 搜索
        THKNavigationBarSearchViewModel *vm = (THKNavigationBarSearchViewModel *)self.viewModel;
        TMUISearchBar *search = [[TMUISearchBar alloc] initWithStyle:vm.barStyle];
        self.titleView = search;
    }
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    [self addTitleViewToContentView:self.titleLbl];
    
    self.titleLbl.text = title;
}

- (void)setAttrTitle:(NSAttributedString *)attrTitle{
    _attrTitle = attrTitle;
   
    [self addTitleViewToContentView:self.titleLbl];
    
    self.titleLbl.attributedText = attrTitle;
}


- (void)setTitleView:(UIView *)titleView{
    _titleView = titleView;
    
    [self addTitleViewToContentView:titleView];
}


- (void)addTitleViewToContentView:(UIView *)titleView{
    [_contentSubView removeFromSuperview];
    
    _contentSubView = titleView;
    [_contentView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentView);
    }];
}

- (void)setBarStyle:(THKNavigationBarStyle)barStyle{
    _barStyle = barStyle;
    
    NSDictionary *aStyle = config[@(self.barStyle)];
    self.backBtn.tmui_image = aStyle[kBackIconKey];
    self.backgroundColor = aStyle[kBackgroundKey];
    self.rightBtn.tmui_image = aStyle[kRighticonKey];
    if (self.title) {
        self.titleLbl.textColor = aStyle[kTintColorKey];
    }
}

- (void)setIsBackButtonHidden:(BOOL)isBackButtonHidden{
    if (_isBackButtonHidden != isBackButtonHidden) {
        _isBackButtonHidden = isBackButtonHidden;
        
        if (isBackButtonHidden) {
            [_backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
//                make.height.equalTo(@0);
            }];
            
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backBtn.mas_right).offset(20);
            }];
            
        }else{
            [_backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@54);
//                make.height.equalTo(@44);
            }];
            
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backBtn.mas_right).offset(0);
            }];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)setIsRightButtonHidden:(BOOL)isRightButtonHidden{
    if (_isRightButtonHidden != isRightButtonHidden) {
        _isRightButtonHidden = isRightButtonHidden;
        
        if (isRightButtonHidden) {
            [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
//                make.height.equalTo(@0);
            }];
            
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_rightBtn.mas_left).offset(-20);
            }];
        }else{
            [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@54);
//                make.height.equalTo(@44);
            }];
            
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_rightBtn.mas_left).offset(0);
            }];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)configContent:(__kindof UIView * (^)(UIView * contentView))blk;
{
    if (blk) {
        UIView * subView = blk(_contentView);
        _contentSubView = subView;
    }
}

- (void)configLeftContent:(void (^)(UIButton * backBtn))blk
{
    if (blk) {
        blk(_backBtn);
    }
}

- (void)configRightContent:(void (^)(UIButton * rightBtn))blk
{
    if (blk) {
        blk(_rightBtn);
    }
}

#pragma mark - v7.3 增加导航条颜色可在scrollview滑动时手动控制渐变效果

/**
 设置导航条的颜色及tintColor(会影响子视图颜色)
 
 @param color 导航条最终颜色
 @param oriTintColor 导航条上的内容变化之前的默认颜色
 @param toTintColor 导航条上的内容可能也需要调整的目标颜色
 @param percent 颜色的过渡进度百分比，取值【0，1】，<=0 按0， >=1 按1
 @warning 此函数调用时内部会将translucent自动赋值为NO
 @warning 导航条上的内容颜色过渡由oriTintColor和toTintColor联合决定
 */

- (void)setNavigationBarColor:(UIColor *)color originTintColor:(UIColor *)oriTintColor toTintColor:(UIColor *)toTintColor gradientPercent:(float)percent
{
    percent = MAX(0, MIN(1, percent));
    self.backgroundColor = percent == 1 ? color : [color colorWithAlphaComponent:percent];

    NSArray *subvs = [self subviews];
    if (subvs.count == 0) {
        return;
    }
    UIColor *currentTintColor = nil;

    if (percent == 0.0) {
        currentTintColor = oriTintColor ? oriTintColor : toTintColor;
    }else if (percent == 1.0) {
        currentTintColor = toTintColor;
    }else {
        if (oriTintColor && toTintColor) {
            //过渡方法1. 从oriTintColor 直接按比例过渡到toTintColor
            CGFloat or = 0,  og = 0, ob = 0, oa = 0;
            CGFloat tr = 0, tg = 0, tb = 0, ta = 0;
            [oriTintColor getRed:&or green:&og blue:&ob alpha:&oa];
            [toTintColor getRed:&tr green:&tg blue:&tb alpha:&ta];
            currentTintColor = [UIColor colorWithRed:or + (tr-or)*percent green:og + (tg-og)*percent blue:ob + (tb-ob)*percent alpha:1];
        }else {
            currentTintColor = [toTintColor colorWithAlphaComponent:percent];
        }
    }
    // 左边
    [self foreachImageViewsIn:_backBtn toTintColor:currentTintColor];
    
    // 右边
    if (_rightBtn && !_rightBtn.isHidden) {
        [self foreachImageViewsIn:_rightBtn toTintColor:currentTintColor];
    }
    // 中间视图
    for (UIView * v in subvs) {
        [self foreachLabelViewsIn:v toTextColor:currentTintColor];
    }
    
    // 动态切换statusBar
    [self setStatusBarStyle:percent];
}

- (void)foreachLabelViewsIn:(UIView *)view toTextColor:(UIColor *)textColor {
    if ([view isKindOfClass:[UILabel class]]) {
        [(UILabel *)view setTextColor:textColor];
    }
    else if (![view isKindOfClass:NSClassFromString(@"THKFocusButtonView")]) {
        for (UIView *subv in view.subviews) {
            [self foreachLabelViewsIn:subv toTextColor:textColor];
        }
    }
}

- (void)foreachImageViewsIn:(UIView *)view toTintColor:(UIColor *)tintColor {
    if ([view isKindOfClass:[UILabel class]]) {
        [self foreachLabelViewsIn:view toTextColor:tintColor];
        return;
    }
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imgV = (UIImageView*)view;
        imgV.tintColor = tintColor;
        if (tintColor) {
            imgV.image = [imgV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }else {
            imgV.image = [imgV.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }else {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            UIImage *img = [btn imageForState:UIControlStateNormal];
            if (img) {
                img = [img tmui_imageWithTintColor:tintColor];
                [btn setImage:img forState:UIControlStateNormal];
            }
        }else {
            for (UIView *subv in view.subviews) {
                [self foreachImageViewsIn:subv toTintColor:tintColor];
            }
        }
    }
}

- (void)setStatusBarStyle:(float)percent{
    UIViewController *vc = self.superview.tmui_viewController;
    if ([vc isKindOfClass:UIViewController.class] && [self aIsMethodOverride:vc.class selector:@selector(preferredStatusBarStyle)]) {
        if (percent >= 0.5) {
            if (@available(iOS 13.0, *)) {
                self.preferredStatusBarStyle = UIStatusBarStyleDarkContent;
            } else {
                // Fallback on earlier versions
                self.preferredStatusBarStyle = UIStatusBarStyleDefault;
            }
        }else{
            self.preferredStatusBarStyle = UIStatusBarStyleLightContent;
        }
        [vc setNeedsStatusBarAppearanceUpdate];
    }
}

/// 判断一个类是否重写suerper方法
- (BOOL)aIsMethodOverride:(Class)cls selector:(SEL)sel {
    IMP clsIMP = class_getMethodImplementation(cls, sel);
    IMP superClsIMP = class_getMethodImplementation([cls superclass], sel);
    return clsIMP != superClsIMP;
}

///注：9.10二级装企页面专用 0 透明底白字白图标 1 白底黑字黑图标。
- (void)setStyle:(CGFloat)style{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:style];
    if (style<.5) {
        _rightBtn.tmui_image = [UIImage imageNamed:@"icon_dec_search_white"];
        _backBtn.tmui_image = [UIImage imageNamed:@"nav_back_white"];
        if ([_contentSubView isKindOfClass:[UILabel class]]) {
            //防止挡住图片
            ((UILabel *)_contentSubView).textColor = [UIColor clearColor];
        }
    }
    else {
        _rightBtn.tmui_image = [UIImage imageNamed:@"icon_dec_search_new"];
        _backBtn.tmui_image = [UIImage imageNamed:@"nav_back_black"];
        if ([_contentSubView isKindOfClass:[UILabel class]]) {
            ((UILabel *)_contentSubView).textColor = THKColor_333333;
        }
    }
}



#pragma mark - lazy getter
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFontMedium(18);
        _titleLbl.textColor = UIColorHex(333333);
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}


@end
