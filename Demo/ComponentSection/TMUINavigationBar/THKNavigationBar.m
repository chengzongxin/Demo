//
//  THKNavigationBar.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import "THKNavigationBar.h"
@interface THKNavigationBar ()
{
    UIButton * _backBtn;
    UIView * _contentView;
    UIView * _contentSubView;
    UIButton * _shareBtn;
}
@property (nonatomic, assign, readwrite) UIStatusBarStyle preferredStatusBarStyle;
@end

@implementation THKNavigationBar

+ (instancetype)createInstance {
    THKNavigationBar *view = [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTNavigationBarHeight())];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 左
        UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn = backBtn;
        [backBtn setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal]; //  icon_video_nav_back
        [backBtn addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.equalTo(self);
            make.width.equalTo(@54);
            make.height.equalTo(@44);
        }];
        
        // 中
        UIView * contentView = [[UIView alloc] init];
        _contentView = contentView;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(backBtn.mas_trailing);
          
            make.bottom.equalTo(self);
            make.height.equalTo(@44);
        }];
        
        // 右
        UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn = shareBtn;
        [shareBtn setImage:[UIImage imageNamed:@"note_share_w"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(self);
            make.height.equalTo(@44);
            make.width.equalTo(@54);
            make.leading.equalTo(contentView.mas_trailing);
        }];
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

- (void)configContent:(__kindof UIView * (^)(UIView * contentView))blk;
{
    if (blk) {
        UIView * subView = blk(_contentView);
        _contentSubView = subView;
    }
}

- (__kindof UIView *)contentSubView
{
    return _contentSubView;
}

- (void)setHideShareBtn:(BOOL)hideShareBtn
{
    _shareBtn.hidden = YES;
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
        blk(_shareBtn);
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
    if (_shareBtn && !_shareBtn.isHidden) {
        [self foreachImageViewsIn:_shareBtn toTintColor:currentTintColor];
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
- (void)setStyle:(CGFloat)style
{
    //
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:style];
    if (style<.5) {
        _shareBtn.tmui_image = [UIImage imageNamed:@"icon_dec_search_white"];
        _backBtn.tmui_image = [UIImage imageNamed:@"nav_back_white"];
        if ([_contentSubView isKindOfClass:[UILabel class]]) {
            //防止挡住图片
            ((UILabel *)_contentSubView).textColor = [UIColor clearColor];
        }
    }
    else {
        _shareBtn.tmui_image = [UIImage imageNamed:@"icon_dec_search_new"];
        _backBtn.tmui_image = [UIImage imageNamed:@"nav_back_black"];
        if ([_contentSubView isKindOfClass:[UILabel class]]) {
            ((UILabel *)_contentSubView).textColor = THKColor_333333;
        }
    }
}
//，3D漫游页面在用
- (void)set3DDesignStyle:(CGFloat)style{
    if (style<.5) {
        _shareBtn.tmui_image = [UIImage imageNamed:@"icon_dec_search_white"];
        _backBtn.tmui_image = [UIImage imageNamed:@"nav_back_white"];
        if ([_contentSubView isKindOfClass:[UILabel class]]) {
            //防止挡住图片
            ((UILabel *)_contentSubView).textColor = [UIColor clearColor];
        }
    }
    else {
        _shareBtn.tmui_image = [UIImage imageNamed:@"icon_dec_search_new"];
        _backBtn.tmui_image = [UIImage imageNamed:@"nav_back_black"];
        if ([_contentSubView isKindOfClass:[UILabel class]]) {
            ((UILabel *)_contentSubView).textColor = THKColor_333333;
        }
    }
}
@end
