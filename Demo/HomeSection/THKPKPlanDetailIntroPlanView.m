//
//  THKPKPlanDetailIntroPlanView.m
//  Demo
//
//  Created by Joe.cheng on 2023/8/21.
//

#import "THKPKPlanDetailIntroPlanView.h"

@interface THKPKPlanDetailIntroPlanView ()

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation THKPKPlanDetailIntroPlanView

- (void)thk_setupViews {
    [super thk_setupViews];
    
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.effectView];
    [self.bottomView addSubview:self.titleLbl];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(83);
    }];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
    }];
    
    [self tmui_addSingerTapWithBlock:^{
        NSLog(@"click");
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
        }];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.effectView.y = self.height - self.effectView.height;
}

//
//- (void)thk_setupViews {
//    [super thk_setupViews];
//
//    NSMutableAttributedString *text = [NSMutableAttributedString new];
//    UIFont *font = [UIFont systemFontOfSize:16]; // 添加文本
//    NSString *title = @"dwwdqwddqdqdqdqwdqdqwdqwdqdqdqdqwdqwdqdqdqwdqdqwdqdqdqdqdqdqwdq当前的群无多群无多群无多群无多群无多群多群无多群无多群无多群无多群多群多群多群当前的群无多群多群无多群多群多群多群多群多群多群多群的权威的权威的期望多无群多群无多群多群多群多群无多群无多群无多群无多群无多群无多群多群无多群无多群多群无多群多群无多无多无群多多群无多群多群多群多群无多群多无！";
//
//    [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
//
//    text.font = font ;
//    _label = [YYLabel new];
//    _label.userInteractionEnabled = YES;
//    _label.numberOfLines = 0;
//    _label.textVerticalAlignment = YYTextVerticalAlignmentTop;
//    _label.frame = CGRectMake(40,60, self.frame.size.width-80,150);
//    _label.attributedText = text;
//    [self addSubview:_label];
//
//    _label.layer.borderWidth = 0.5;
//    _label.layer.borderColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:1.000].CGColor; // 添加全文
// [self addSeeMoreButton];
//}
//#pragma mark - 添加全文
//- (void)addSeeMoreButton {
//
//    __weak __typeof(self) weakSelf = self;
//
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...全文"];
//
//    YYTextHighlight *hi = [YYTextHighlight new];
//    [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
//
//    hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) { // 点击全文回调 YYLabel *label = weakSelf.label;
//        [self.label sizeToFit];
//    };
//
//    [text setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000] range:[text.string rangeOfString:@"全文"]];
//    [text setTextHighlight:hi range:[text.string rangeOfString:@"全文"]];
//    text.font = _label.font;
//
//    YYLabel *seeMore = [YYLabel new];
//    seeMore.attributedText = text;
//    [seeMore sizeToFit];
//
//    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
//
//    _label.truncationToken = truncationToken;
//}

#pragma mark - Getter && Setter

TMUI_PropertyLazyLoad(UIView, bottomView);

- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
//        _effectView.tmui_foregroundColor = UIColorHex(F6F8F6);
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, 82)];
//        [view tmui_gradientWithColors:@[UIColorHex(FFFFFF),[UIColorHex(F6F8F6) colorWithAlphaComponent:0]] gradientType:TMUIGradientTypeTopToBottom locations:@[@0.3]];
//        [_effectView.contentView addSubview:view];
        _effectView.alpha = 0.8;
    }
    return _effectView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFontMedium(16);
        _titleLbl.textColor = UIColorWhite;
        _titleLbl.text = @"方案一";
    }
    return _titleLbl;
}


@end
